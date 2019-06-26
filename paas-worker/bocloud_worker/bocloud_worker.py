#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import os
import sqlite3
import sys
import threading
import time
import traceback
import socket
import signal

import flask_restful
from flask import Flask
from flask import abort
from flask import request

from ansible_handler.ansible_handler import AnsibleHandler, JobRunHandler, JobEnv
from common.base_handler import BaseHandler
from common.daemon import Daemon
from common.db.bocloud_worker_db import ASYNC_TASK_STATUS_COMPLETE
from common.db.bocloud_worker_db import ASYNC_TASK_STATUS_RUNNING
from common.db.bocloud_worker_db import BocloudWorkerDB
from common.rabbitmq_handler import intergrate_send_result_to_rabbitmq
from common.status import get_status
from common.threads_monitor import ThreadsMonitor
from common.threads_monitor import threads_pool
from common.threads_monitor import threads_pool_lock
from common.utils import BOCLOUD_WORKER_CONFIG, ZOOKEEPER_CONFIG, CONSUL_CONFIG
from common.utils import BOCLOUD_WORKER_SQLITEDB
from common.utils import check_white_blacklist
from common.utils import global_dict_update
from common.utils import logger
from common.utils import get_file_content
from zookeeper_handler.node_register import NodeRegister
import consul

reload(sys)
sys.setdefaultencoding('utf-8')

os.environ["PYTHONOPTIMIZE"] = "1"
app = Flask(__name__)
api = flask_restful.Api(app)
ansible_result = {}
tps = 0
start_time = None
reset_thread = None
is_daemon = False


@app.before_request
def init_request():
    '''Check whether or not the ip have permession to access the BOCLOUD_worker service.
    '''
    ip = request.remote_addr
    logger.debug("The IP of requestment is %s", ip)
    # write every request to sqlite3 DB
    try:
        logger.debug("insert a request to sqlite DB")
        db = BocloudWorkerDB(BOCLOUD_WORKER_SQLITEDB)
        request_id = db.insert_task_requests(request)
        logger.debug("The request id in task_requests table is %d" % request_id)
        request.task_request_id = request_id
    except sqlite3.Error as e:
        logger.error("Failed to insert request with sqlite3 exception: %s" % str(e))
        abort(500)
    except Exception, e:
        logger.error(traceback.format_exc())
        logger.error("Failed to insert request with unknown exception: %s" % str(e))
        abort(500)
    finally:
        db.close()

    result = check_white_blacklist(ip)
    if not result:
        logger.error("The IP %s don't have the permission to access the BOCLOUD_Worker service", ip)
        abort(403)


@app.after_request
def after_request(response):
    return response
    # the response of request update to sqlite3 DB
    status_code = response.status_code
    if not hasattr(request, 'task_request_id'):
        abort(400)
        return
    request_id = request.task_request_id
    queue = None
    if request.json and "queue" in request.json:
        queue = request.json["queue"]
    tr_values = dict()
    aos_values = dict()
    tr_values["respond_code"] = status_code
    if status_code == 200:
        message = json.loads(response.data)
        # async job can't success running
        if "success" in message and message["success"] is False:
            tr_values["error_message"] = message.get("message", "")
            aos_values["status"] = ASYNC_TASK_STATUS_COMPLETE
    else:
        tr_values["error_message"] = response.data

    try:
        logger.debug("update DB before send response to server")
        db = BocloudWorkerDB(BOCLOUD_WORKER_SQLITEDB)
        db.update_task_requests(request_id, tr_values)
        if queue and len(aos_values) > 0:
            db.update_async_task_status(queue, aos_values)
    except sqlite3.Error as e:
        logger.error("Failed to update request result with sqlite3 exception: %s" % str(e))
    except Exception, e:
        logger.error(traceback.format_exc())
        logger.error("Failed to update request result with unknown exception: %s" % str(e))
    finally:
        db.close()

    return response

@app.route('/job/run', methods=['POST'])
def run_playbook():
    global tps
    logger.info("The /job/run request is %s" % json.dumps(request.json, ensure_ascii=False))
    tps += 1
    message = "The job is sent to worker successful. uuid is %s" % request.json['uuid']
    response_context = {'code': '200', "state": 'success', "message": "initial"}
    ret=job_run(request.json)
    print "ret===>%s" %ret
    if ret['success']:
        response_context['state'] = 'success'
    else:
        response_context['state'] = 'failed'
    response_context['message'] = ret['message']
    return json.dumps(response_context)
    try:
        ret=job_run(request.json)
        print(ret)
        if ret['success']:
            response_context['state'] = 'success'
        else:
            response_context['state'] = 'failed'
        response_context['message'] = ret['message']
    except Exception as ex:
        logger.error(traceback.format_exc())
        message = "This Job run improperly"
        logger.error(message) 
    return json.dumps(response_context)


@app.route('/job/submit', methods=['POST'])
def handle_job():
    """this interface is used to execute jobs
    the rest instant response means the jobs is sent to worker successfully
    after worker finish all jobs, send job results to rabbitmq.
    :return:
    {
        "message": "The 123 job is sent to worker successful.",
        "success": true
    }
    """
    logger.info("The /job/submit request is %s" % json.dumps(request.json, ensure_ascii=False))
    global tps
    tps += 1
    if not BaseHandler.check_request(request.json,
                                     "/job/submit"):
        abort(400)

    result = True
    queue = request.json.get("queue", "job_submit" + str(time.time()))
    message = "The job is sent to worker successful. Queue is %s" % queue

    context = None
    try:
        context = job_exec(request.json, queue)
        print("hhaa--->%s" %(context))
    except Exception as ex:
        logger.error(traceback.format_exc())
        message = "The job is failure to operate. Queue is %s. %s" % (queue, ex)
        logger.error(message)
        result = False

    if not context:
        context = {"success": result,
                   "message": message}

    return json.dumps(context)


@app.route('/job/recovery', methods=['POST'])
def recovery_job():
    """
    this interface is used to recovery offline worker jobs
    :return:
    {
        "message": "ok",
        "success": true
    }
    """
    logger.info("The /job/recovery request is %s" % json.dumps(request.json))
    result = {"success": True,
              "message": "ok"}
    try:
        recovery_exec(request.json['host'], request.json['port'])
    except Exception as e:
        logger.error(traceback.format_exc())
        result = {"success": False,
                  "message": str(e)}

    return json.dumps(result)


@app.route('/server/status/scan', methods=['POST'])
def machines_scan():
    """this interface is used to get server status
    :return:
    {
        "message": "Finished the job 123",
        "data": [
            {
                "status": "online",
                "host": "192.168.2.73"
            }
        ],
        "success": true
    }
    """
    logger.debug("The /server/status/scan request is %s" % json.dumps(request.json))

    if not BaseHandler.check_request(request.json,
                                     "/server/status/scan"):
        abort(400)

    result = True
    queue = request.json["queue"]
    message = "The %s job is sent to worker successful." % queue

    try:
        request_json = request.json
        request_json["module"] = {}
        request_json["module"]["name"] = "ping"
        context = job_exec(request.json, queue)
    except Exception as ex:
        logger.error(traceback.format_exc())
        logger.error("Failure operate job %s. %s" % (queue, ex))
        result = False
        message = "The %s job is failure to operate. %s" % (queue, ex)

    if not context:
        context = {"success": result,
                   "message": message}
    return json.dumps(context)


@app.route('/status', methods=['GET'])
def status():
    """this interface is used to get worker status
    :return: json string
    {
        "data": {
            "cpu.worker.usage": 0.0,
            "ip": "192.168.200.128",
            "memory.system.free": 74,
            "memory.system.total": 977,
            "memory.worker.memory": 796,
            "memory.worker.resident": 34,
            "memory.worker.stacksize": 0,
            "memory.worker.threads": 7,
            "os.arch": "x86_64",
            "os.cpu.number": 1,
            "os.name": "Linux-3.10.0-327.el7.x86_64-x86_64-with-centos-7.2.1511-Core",
            "tps": 0,
            "uptime.worker": 53
        },
        "message": "ok",
        "success": true
    }
    """
    return json.dumps(dict(data=get_status(tps, start_time),
                           success=True,
                           message='ok'))


@app.route('/logview', methods=['POST'])
def log_view():
    """this interface is used to get remote log file content
    file content return immediately
    :return: json object
    {
        "message": "55555\n666666\n7777777\n88888888\n",  # 文件内容或是错误信息
        "filesize": 65,      # 读取了返回的文件内容后，文件最后的位置
        "success": true      # API是否执行成功
    }
    """
    logger.debug("The /logview request is %s" % json.dumps(request.json))

    if not BaseHandler.check_request(request.json,
                                     "/logview"):
        abort(400)

    position = request.json.get("position", 0)
    presize = request.json.get("presize", 1024)
    # presize is 0, use default presize 1024
    if presize == 0:
        presize = 1024

    # if just want to see itself log of worker, don't suggest to call ansible.
    # this maybe cause worker can't normal worker and crash.
    if BOCLOUD_WORKER_CONFIG['host'] == request.json['target']:
        file_name = request.json['filepath']
        if file_name == "":
            file_name = BOCLOUD_WORKER_CONFIG['log']['file']

        success, content, curr_position = get_file_content(file_name, position, presize)
        context = {"success": success,
                   "message": content,
                   "filesize": curr_position}
        return json.dumps(context)

    new_request = dict()
    target = dict(host=request.json['target'])
    for optional in ['user', 'pasd', 'port']:
        if optional in request.json:
            target[optional] = request.json[optional]
    new_request['targets'] = [target]
    new_request['module'] = dict()
    new_request['module']['name'] = 'bocloud_logview'
    new_request['module']['args'] = dict()
    if BOCLOUD_WORKER_CONFIG['host'] == request.json['target'] and request.json['filepath'] == "":
        new_request['module']['args']['log_file'] = BOCLOUD_WORKER_CONFIG['log']['file']
    else:
        new_request['module']['args']['log_file'] = request.json['filepath']
    new_request['module']['args']['position'] = position

    new_request['module']['args']['presize'] = presize
    thread_name = "logview" + str(time.time())
    result_signal = threading.Event()
    ansible_thread = AnsibleHandler(new_request, thread_name, result_signal=result_signal)
    logger.info("the new logview request is %s" % new_request)
    ansible_thread.start()
    global_dict_update(threads_pool,
                       ansible_thread,
                       lock=threads_pool_lock,
                       value=time.time(),
                       operate="append")

    if result_signal.wait(timeout=60):
        if ansible_thread.ansible_result["success"]:
            msg = ansible_thread.ansible_result["data"][0]["message"]["bocloud_worker_msg"].get("content", "")
            position = ansible_thread.ansible_result["data"][0]["message"]["bocloud_worker_msg"]["curr_position"]
        else:
            msg = ansible_thread.ansible_result["data"][0]["message"]["msg"]
            position = 0

        context = {"success": ansible_thread.ansible_result["success"],
                   "message": msg,
                   "filesize": position}
    else:
        context = {"success": False,
                   "message": "Get special log content failure. please check requestment"}
    return json.dumps(context)

def job_run(request_json):
    try:
        env = JobEnv(request_json)
        ansible_thread = JobRunHandler(env, result_signal=None)
        ansible_thread.start()
        global_dict_update(threads_pool,
                       ansible_thread,
                       lock=threads_pool_lock,
                       value=time.time(),
                       operate="append")
    except Exception, e:
        return {"success": False,
                "message": str(e)
                }
    return {"success": True, "message": "The job[%s] is sent to worker successful" %(request_json['uuid'])}

def job_exec(request_json, queue, recovery=False, worker_db=BOCLOUD_WORKER_SQLITEDB):
    """exec jobs using ansible
    :param request_json:
    :param type:
    :param recovery:
    :return:
    """
    size = len(request_json["targets"])
    response_type = request_json.get("response", "async_result")
    is_async = False if response_type == "sync" else True
    print ("---> response_type=%s" %response_type)
    # update task status and mark the job is running
    # just insert async task to DB
    if recovery is False and is_async is True:
        try:
            db = BocloudWorkerDB(worker_db)
            values = dict()
            values["status"] = ASYNC_TASK_STATUS_RUNNING
            values["total_count"] = size
            db.update_async_task_status(queue, values)
        except sqlite3.Error as e:
            logger.error("Failed to update task status with sqlite3 exception: %s" % str(e))
        except Exception, e:
            logger.error(traceback.format_exc())
            logger.error("Failed to update task status with unknown exception: %s" % str(e))
        finally:
            db.close()

    result_signal = None
    # if response type is sync, we generate an event to wait result.
    if is_async is False:
        result_signal = threading.Event()
    ansible_thread = AnsibleHandler(request_json, queue,
                                    result_signal=result_signal, db=worker_db)
    ansible_thread.start()
    global_dict_update(threads_pool,
                       ansible_thread,
                       lock=threads_pool_lock,
                       value=time.time(),
                       operate="append")

    content = None
    print("hhahahaha-->%s" %(result_signal))
    # wait the result if this is sync request
    if result_signal:
        if result_signal.wait(timeout=60):
            return ansible_thread.ansible_result
        else:
            content = {"success": False,
                       "message": "The task is timeout."}

    return content


def recovery_exec(worker_host, worker_port):
    kv = dict()
    kv["nfs_path"] = BOCLOUD_WORKER_CONFIG["nfs_path"]
    kv["host"] = worker_host
    kv["port"] = worker_port
    worker_db = "{0[nfs_path]}/{0[host]}_{0[port]}/bocloud_worker.db".format(kv)
    logger.debug("Start to recovery uncompleted tasks. database is %s" % worker_db)

    try:
        # get all not running async tasks
        db = BocloudWorkerDB(worker_db)
        tasks = db.get_new_tasks()
        for task in tasks:
            logger.debug("recocery new task: %s" % task)
            request_data = task["request_data"]
            recovery_request = json.loads(request_data, encoding='utf-8')
            sync = recovery_request.get("response", None)
            if sync:
                # mark the task as finished
                db.set_task_as_finished(recovery_request["queue"])
                continue
            job_exec(recovery_request, recovery_request["queue"], worker_db=worker_db)

        # get all uncompleted async tasks
        db = BocloudWorkerDB(worker_db)
        tasks = db.get_uncompleted_tasks()
        for task in tasks:
            request_data = json.loads(task["request_data"], encoding='utf-8')
            request_id = task['request_id']
            # filter out completed targets from the request
            db.refresh_request_data_for_uncompleted_target(request_id,
                                                           request_data)
            logger.debug("recovery uncompleted task %d, request data is %s" % (request_id, request_data))
            if len(request_data["targets"]) == 0:
                # don't have tasks need ansible to do, just intergrate the exist result
                # and send the result to rabbitmq
                queue = request_data["queue"]
                _, results = db.get_task_all_result(queue)
                intergrate_send_result_to_rabbitmq(queue, results)
                db.set_task_as_finished(queue)
            else:
                sync = recovery_request.get("response", None)
                if sync:
                    # mark the task as finished
                    db.set_task_as_finished(recovery_request["queue"])
                    continue
                job_exec(request_data, request_data["queue"], recovery=True, worker_db=worker_db)
    except sqlite3.Error as e:
        logger.error("Failed to operate sqlite3 exception: %s" % str(e))
    except Exception, e:
        logger.error(traceback.format_exc())
        logger.error("Failed to operate sqlite3 with unknown exception: %s" % str(e))
    finally:
        db.close()


def _reset_tps():
    '''
    this is a timer to reset tps
    :return:
    '''
    global tps
    tps = 0
    global reset_thread
    reset_thread = threading.Timer(1.0, _reset_tps)
    reset_thread.start()

class Reg2Consul(object):
  def __init__(self, consul_ip="localhost", consul_port=8500, service_name="", master_token="987bd467-a93e-8558-1aaf-f7c4036c406b"):
    self.consul_ip = consul_ip
    self.consul_port = consul_port
    self.token = master_token
    self.consul_client = consul.Consul(host=self.consul_ip, port=self.consul_port, scheme="http", token=master_token)
    self.service_name = service_name
    self.service_id = "%s-%s"%(service_name, socket.gethostname())
  def register(self, ip, port):
      print("[%s]register sevice launching" %(self.service_name))
      check = consul.Check.tcp(ip, port, CONSUL_CONFIG['check_interval'])
      self.consul_client.agent.service.register(self.service_name, service_id=self.service_id, address=ip, port=port, check=check, token=self.token)
      print("[%s]register service success", self.service_name)

  def getservice(self):
      data = self.consul_client.catalog.service(self.service_name)
      for value in data[1]:
        print(value)
  def deregister(self):
      if self.consul_client.agent.service.deregister(self.service_id, self.token):
        print("[%s]deregister service success", self.service_id)
      else:
        print("[%s]deregister service failed", self.service_id)

def onsignal_term(a,b):  
    logger.info("term.....")
    raise SystemExit('Exiting')
def main():
    signal.signal(signal.SIGTERM,onsignal_term)    
    global start_time
    start_time = time.time()
    import socket
    host = socket.gethostbyname(socket.gethostname())
    #host = BOCLOUD_WORKER_CONFIG["host"]
    port = BOCLOUD_WORKER_CONFIG["port"]
    print os.getenv('consul_host')
    print os.getenv('consul_port') 
    print os.getenv('consul_token')
    print os.getenv('consul_app')
    if os.getenv('consul_host'):
        consul_host_ip = os.getenv('consul_host')
    else:
        consul_host_ip = CONSUL_CONFIG['consul_server']
    if os.getenv('consul_port'):
        consul_port = os.getenv('consul_port')
    else:
        consul_port = CONSUL_CONFIG['consul_port']
    if os.getenv('consul_token'):
        consul_token = os.getenv('consul_token')
    else:
        consul_token = CONSUL_CONFIG['master_token']
    print "%s:%s" %(consul_host_ip, consul_port)
    if CONSUL_CONFIG['enable']:
        consulx = Reg2Consul(consul_host_ip, consul_port, BOCLOUD_WORKER_CONFIG['app_name'], consul_token)
        consulx.register(host, BOCLOUD_WORKER_CONFIG['port'])
        logger.info("Consul Register checked.")
    if ZOOKEEPER_CONFIG['enable']:
        # zk = ZkHandler(ZOOKEEPER_CONFIG["zk_server"])
        #ezk_thread = threading.Thread(target=zk.register)
        zk = NodeRegister(ZOOKEEPER_CONFIG["zk_server"])
        zk_thread = threading.Thread(target=zk.service)
        zk_thread.setName("zk-thread")
        zk_thread.setDaemon(True)
        zk_thread.start()
        logger.info("ZooKeeper Register checked.")
    
    # reset tps per second
    global reset_thread
    reset_thread = threading.Timer(1.0, _reset_tps)
    reset_thread.daemon = True
    reset_thread.start()

    logger.info("Threads monitor thread is start.")
    monitor = ThreadsMonitor()
    monitor.setDaemon(True)
    monitor.start()

    flask_debug = BOCLOUD_WORKER_CONFIG["flask_debug"]
    try:
        # create bocloud_worker database if it is not existing
        worker_db = "{0[nfs_path]}/{0[host]}_{0[port]}/bocloud_worker.db".format(BOCLOUD_WORKER_CONFIG)
        logger.debug("The worker db is local at %s" % worker_db)
        init_sql = BOCLOUD_WORKER_CONFIG["init_sql"]
        logger.debug("The initialization database is %s" % init_sql)
        BocloudWorkerDB.create_bocloud_worker_schema(worker_db, init_sql)

        app.run(debug=flask_debug, host=host, port=port, use_reloader=False)
    except KeyboardInterrupt as err:
        logger.info("Close BOCLOUD worker with Ctrl+c")
    except Exception as err:
        logger.error("Close BOCLOUD worker, Unknown error: %s" % str(err))
    except SystemExit as err:
        if CONSUL_CONFIG['enable']:
            consulx.deregister()
            consulx = None
        if ZOOKEEPER_CONFIG['enable']: zk.close()
        logger.error("BOCLOUD_worker exit, code status is: %s" % str(err))
    finally:
        logger.info("BOCLOUD worker exit. cleanup used source")
        monitor.terminate()
        logger.info("try to terminate all threads. Please wait ...")
        monitor.join(10)
        if CONSUL_CONFIG['enable'] and consulx: consulx.deregister()
        if ZOOKEEPER_CONFIG['enable']: zk.close()
        sys.exit(0)

# create a new daemon class to override work function in base class.
class BOCLOUDWorker(Daemon):
    def work(self):
        main()

if __name__ == "__main__":
    if is_daemon:
        # run bocloud_worder as daemon process
        bocloud_worker = BOCLOUDWorker()
        bocloud_worker.run()
    else:
        main()
