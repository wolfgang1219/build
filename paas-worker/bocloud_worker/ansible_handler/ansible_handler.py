#!/usr/bin/env python
# -*- coding: utf-8 -*-
import time
import traceback
from base64 import b64decode
import yaml
from os import path, access, R_OK, makedirs
HAS_ANSIBLE = False
try:
    from ansible.cli import CLI
    from ansible.errors import AnsibleOptionsError, AnsibleError
    from ansible.utils.vars import combine_vars
    from ansible.parsing.dataloader import DataLoader
    from ansible.vars.manager import VariableManager
    from ansible.inventory.manager import InventoryManager
    from ansible.inventory.host import Host
    from ansible.executor.playbook_executor import PlaybookExecutor
    HAS_ANSIBLE = True
except ImportError:
    pass

from collections import namedtuple
from collections import MutableMapping
from callback_plugins.result_rabbitMQ import CallbackModule
from callback_plugins.result_file import ResultCallback
from ansible_utils import log_result
from ansible_utils import handle_job_exception
from ansible_task import AnsibleTask
from common.utils import logger
from common.utils import BOCLOUD_WORKER_CONFIG
from common.utils import BOCLOUD_WORKER_SQLITEDB
from common.utils import BOCLOUD_ANSIBLE_CONFIG
from common.base_handler import BaseHandler
from common.db.bocloud_worker_db import BocloudWorkerDB

# the max times that ansible operate job failure
MAX_TRY_TIMES = 3


class AnsibleHandler(BaseHandler):
    '''
    Operate ansible, it just work for >= ansible2.4
    '''
    TIME_FORMAT = "%b %d %Y %H:%M:%S"
    def __init__(self, request, threading_name, result_signal=None, db=BOCLOUD_WORKER_SQLITEDB):
        super(AnsibleHandler, self).__init__(name=threading_name,
                                             timeout=request.get('timeout', BOCLOUD_WORKER_CONFIG["job_timeout"]))
        self.task = AnsibleTask(request, threading_name, result_signal=result_signal)
        self.ansible_result = dict()
        self.result_signal = result_signal
        self.worker_db = db

    def __del__(self):
        logger.info("The task finished. cleanup it.")
        self.task.cleanup()

    @classmethod
    def check_ansible_valid(cls):
        return HAS_ANSIBLE

    def run(self):
        if not self.check_targets_category(self.task.hosts):
            error_msg = "Bocloud_worker only support to operate all windows targets or all linux targets per request."
            handle_job_exception(self.task.queue, error_msg, self.result_signal, self.ansible_result)
            return

        if not HAS_ANSIBLE:
            error_msg = "Ansible is not installed correctly."
            handle_job_exception(self.task.queue, error_msg, self.result_signal, self.ansible_result)
            return

        logger.info("ansible start to work, the task detail is below. %s" % self.task.queue)
        counter = 0
        while True:
            try:
                # cleanup results that have compeleted from async_task_results
                if counter > 0:
                    db = BocloudWorkerDB(self.worker_db)
                    db.cleanup_results(self.task.queue, self.task.ip_list)

                self._task_exec()
                break
            except (SystemExit, SystemError), e:
                msg = "ansible don't response a long time for job %s. \
                       Force terminate the job." % self.task.queue
                logger.error(str(e))
                handle_job_exception(self.task.queue, msg, self.result_signal, self.ansible_result)
                break
            except ValueError, e:
                handle_job_exception(self.task.queue, str(e), self.result_signal, self.ansible_result)
                break
            except Exception, e:
                counter += 1
                logger.error(str(e))
                logger.error(traceback.format_exc())
                logger.warning("The %d times %s job operate failure" %
                               (counter, self.task.queue))
                if counter >= MAX_TRY_TIMES:
                    #msg = "Exceed the max try times %d, Failure the job" % \
                    #      MAX_TRY_TIMES
                    msg = "Job Failed: %s" %(str(e))
                    logger.error(msg)
                    with open(self.logpath, 'a+') as logf:
                        logf.write("%s\n" %(msg))
                    handle_job_exception(self.task.queue, msg, self.result_signal, self.ansible_result)
                    break
                else:
                    time.sleep(1)
                    continue
        return

    def _set_ansible_options_passwords(self):
        '''build ansible options
        '''

        # get all option values
        become = True
        sudo = None
        become_method = None
        become_user = None
        module_path = None
        fork_num = BOCLOUD_ANSIBLE_CONFIG["forks"]
        passwords = dict(vault_pass='secret')
        if self.task.options and 'become' in self.task.options:
            become = self.task.options.get('become')
        if self.task.options and 'sudo' in self.task.options:
            sudo = self.task.options.get('sudo')
        if become or sudo:
            become = True
        if become:
            become_method = self.task.options.get('becomeMethod', 'sudo') if self.task.options else 'sudo'
            become_user = self.task.options.get('becomeUser', 'root') if self.task.options else 'root'
            passwords['become_pass'] = self.task.options.get('becomePass', '') if self.task.options else ''

        # set all option values to options
        option_items = ['connection', 'module_path', 'forks', 'become', 'become_method', 'become_user', 'check',
                        'diff', 'listhosts', 'listtasks', 'listtags', 'syntax']

        Options = namedtuple('Options', option_items)
        ops = Options(connection=self.task.connection, module_path=module_path, forks=fork_num, become=become,
                      become_method=become_method, become_user=become_user, check=False, diff=False,
                      listhosts=None, listtasks=None, listtags=None, syntax=None)
        logger.debug("The ansible options value is %s" % ops._asdict())

        return ops, passwords

    def _task_exec(self):
        # initialize needed objects
        loader = DataLoader()
        # set ansible connection values
        options, passwords = self._set_ansible_options_passwords()

        # create inventory and pass to var manager
        host_list = [host['host'] + ":" + str(host.get('port', 22)) for host in self.task.hosts]
        if len(host_list) == 1:
            # sources must include comma in string.
            # Otherwise, hostlist plugin don'think it is a valid host_list sources.
            sources = ','.join(host_list) + ','
        else:
            sources = ','.join(host_list)
        inventory = self._create_inventory(loader, sources)

        variable_manager = VariableManager(loader=loader, inventory=inventory)
        # We need to remember all targets(or hosts in groups) that mapped Host instances
        # Avoid to create the reduplicated Host instances.
        # Note, if a host has alias at groups. the host will create two Host instances
        ansible_hosts = self._init_ansible_host_and_variable(variable_manager)

        # Note, we must add group_vars at first because host_vars have the more priority
        self._add_variable_by_group(variable_manager, inventory, ansible_hosts)

        # add host_vars to worker target host
        self._add_host_vars(variable_manager, ansible_hosts)

        extra_vars = dict(queue=self.task.queue)
        if self.task.connection == 'winrm':
            extra_vars['ansible_winrm_server_cert_validation'] = 'ignore'
            # read_timeout_sec must exceed operation_timeout_sec, and both must be non-zero
            extra_vars['ansible_winrm_read_timeout_sec'] = self.timeout
            extra_vars['ansible_winrm_operation_timeout_sec'] = self.timeout - 1
            logger.info(extra_vars)
        variable_manager.extra_vars = extra_vars

        # Please refer cli/__init__.py when add options_vars
        options_vars = dict()
        options_vars['ansible_version'] = CLI.version_info(gitinfo=False)
        variable_manager.options_vars = options_vars

        if self.task.playbooks:
            # playbook rabbitmq callback send playbook file name to clean generated playbook file
            results_callback = CallbackModule(self.task, result=self.ansible_result,
                                              result_signal=self.result_signal, worker_db=self.worker_db)
            try:
                print("playbooks=>%s \n inventory=%s \n var=> %s" %(self.task.playbooks, inventory, variable_manager))
                pbex = PlaybookExecutor(self.task.playbooks, inventory, variable_manager, loader, options, passwords,
                                        callback=results_callback)
                result = pbex.run()
                log_result(self.task, result)
                return result
            except (SystemExit, SystemError), e:
                raise SystemExit("Force terminate ansible job %s. %s" %
                                 (self.task.queue, str(e)))
            except Exception, e:
                logger.error(traceback.format_exc())
                raise Exception("Run %s job exception. %s" % (self.task.queue, str(e)))
        else:
            msg = "The task didn't generate playbooks. Do nothing"
            logger.error(msg)
            raise ValueError(msg)

    # accouding to group of task, to create the inventory
    def _create_inventory(self, loader, sources):
        inventory = InventoryManager(loader=loader, sources=sources)

        if self.task.groups is None:
            return inventory

        for group_item in self.task.groups:
            inventory.add_group(group_item["name"])
            # add the host of the group to inventory
            for host in group_item["hosts"]:
                ansible_inventory_hostname = host["host"]
                host_vars = host.get('vars', None)
                # if the host has alias of inventory_hostname, used the alias
                if host_vars and 'alias' in host_vars:
                    ansible_inventory_hostname = host_vars['alias']
                inventory.add_host(ansible_inventory_hostname, group_item["name"])

        return inventory

    def _add_hosts_in_childen_group(self, inventory, group_name, childen_group_info):
        if not childen_group_info:
            return

        # add the host of the group to inventory
        if "hosts" in childen_group_info and childen_group_info["hosts"]:
            for host in childen_group_info["hosts"]:
                inventory.add_host(host, group_name)

        return

    # Add group_vars to worker target hosts.
    def _add_variable_by_group(self, variable_manager, inventory, ansible_hosts):
        if self.task.groups is None:
            return

        group_dict = inventory.get_groups_dict()
        for group_name, hosts in group_dict.iteritems():
            logger.debug("The group %s includes hosts: %s" % (group_name, hosts))
            for group_info in self.task.groups:
                if group_name != group_info["name"]:
                    continue

                # if don't exist the group_vars, return from function
                if "vars" not in group_info or not group_info["vars"]:
                    break

                self._add_group_vars_to_hosts(variable_manager, group_info, hosts, ansible_hosts)
                break

        return

    # hosts is host ip address list
    def _add_group_vars_to_hosts(self, variable_manager, group_info, hosts, ansible_hosts):
        for host in hosts:
            ansible_host = ansible_hosts.get(host, None)
            if ansible_host is None:
                logger.error("The host %s instance don't exist" % host)
                continue
            for key, value in group_info["vars"].iteritems():
                variable_manager.set_host_variable(ansible_host, key, value)

        return

    # add host_vars
    def _add_host_vars(self, variable_manager, ansible_hosts):
        if self.task.groups is None:
            return

        for group_info in self.task.groups:
            for host_info in group_info["hosts"]:
                if "vars" not in host_info or not host_info["vars"]:
                    continue

                ansible_host = self._get_ansible_host(ansible_hosts, host_info)
                if ansible_host is None:
                    logger.error("can't get %s ansible Host instance. %s" % (host_info, ansible_hosts))
                    continue
                for key, value in host_info["vars"].iteritems():
                    # igore variable is "alias" that it is inventory_hostname
                    if key == "alias":
                        continue
                    variable_manager.set_host_variable(ansible_host, key, value)

    # get ansible Host instance from host info in groups
    def _get_ansible_host(self, ansible_hosts, host_info):
        ansible_inventory_hostname = host_info['host']
        if 'vars' in host_info and 'alias' in host_info['vars']:
            ansible_inventory_hostname = host_info['vars']['alias']

        return ansible_hosts.get(ansible_inventory_hostname, None)

    # create ansible Host instance from targets and groups
    # add normal variable information to variable_manager
    # The host ip or alias in host_vars will be as key of results
    def _init_ansible_host_and_variable(self, variable_manager):
        results = dict()
        for target in self.task.hosts:
            ansible_inventory_hostname = target['host']
            if ansible_inventory_hostname not in results:
                ansible_host = Host(ansible_inventory_hostname)
                results[ansible_inventory_hostname] = ansible_host
                self._set_ansible_variable_manager(variable_manager, ansible_host, target)

        if not self.task.groups:
            return results

        for group in self.task.groups:
            hosts = group['hosts']
            for host in hosts:
                host_ip = host['host']
                host_vars = host.get('vars', None)
                ansible_inventory_hostname = host_ip
                # Check whether the host have inventory_name, parameter is alias
                if host_vars and 'alias' in host_vars:
                    ansible_inventory_hostname = host_vars['alias']

                if ansible_inventory_hostname not in results:
                    ansible_host = Host(ansible_inventory_hostname)
                    results[ansible_inventory_hostname] = ansible_host
                    # get the target info of the host
                    target = self._get_target_info(host_ip)
                    self._set_ansible_variable_manager(variable_manager, ansible_host, target)

        return results

    # get target info by host ip
    def _get_target_info(self, host_ip):
        for target in self.task.hosts:
            if target['host'] == host_ip:
                return target

        return None

    # set basic target info to ansible variable_manager
    def _set_ansible_variable_manager(self, variable_manager, ansible_host, target_info):
        if not target_info:
            return

        # differcent username, password pair for various hosts
        variable_manager.set_host_variable(ansible_host, 'ansible_ssh_port',
                                           target_info.get('port', 5986 if self.task.connection == 'winrm' else 22))
        variable_manager.set_host_variable(ansible_host, 'ansible_connection', self.task.connection)
        variable_manager.set_host_variable(ansible_host, 'ansible_ssh_user', target_info.get('user', None))
        variable_manager.set_host_variable(ansible_host, 'ansible_ssh_pass', target_info.get('pasd', None))
        # the host in target must exist
        variable_manager.set_host_variable(ansible_host, 'ansible_ssh_host', target_info['host'])
        if self.task.is_sudo():
            variable_manager.set_host_variable(ansible_host, 'ansible_su_pass', target_info.get('pasd', None))


class JobRunHandler(AnsibleHandler):
    def __init__(self, job_env, result_signal=None):
        self.inventory_file = "%s/%s" %(BOCLOUD_ANSIBLE_CONFIG['inventory_genpath'], job_env.uuid)
        self.vars_file = "%s/%s_vars" %(BOCLOUD_ANSIBLE_CONFIG['inventory_genpath'], job_env.uuid)
        self.inventory_string = job_env.inventory_string
        self.vars_string = job_env.vars_string
        self.action = job_env.action
        self.logpath = "%s/%s.log" %(BOCLOUD_ANSIBLE_CONFIG['playbook_logs'], job_env.uuid)
        if not path.exists(path.dirname(self.logpath)):
            makedirs(path.dirname(self.logpath))
        with open(self.logpath, 'a+') as logf:
            now = time.strftime(self.TIME_FORMAT, time.localtime())  
            logf.write("%s %s START\n" %(now, self.action))
        super(JobRunHandler, self).__init__(job_env.req, job_env.uuid, result_signal)
    def __del__(self):
        with open(self.logpath, 'a+') as logf:
            now = time.strftime(self.TIME_FORMAT, time.localtime())
            logf.write("%s %s END\n" %(now, self.action))
    def load_extra_vars(self, loader):
        extra_vars = {}
        with open(self.vars_file,'w') as fx:
            fx.write(self.vars_string)
        data = loader.load_from_file(self.vars_file)
        if data:
            if isinstance(data, MutableMapping):
                extra_vars = combine_vars(extra_vars, data)
            else:
                raise AnsibleOptionsError("Invalid extra vars data supplied. vars could not be made into a dictionary")
        logger.info(extra_vars)
        return extra_vars
    def _create_inventory(self, loader):
        with open(self.inventory_file,'w') as fx:
            fx.write(self.inventory_string)
        return super(JobRunHandler, self)._create_inventory(loader, self.inventory_file)
    def _set_ansible_options_passwords(self):
        '''build ansible options
        '''
        # get all option values
        become = True
        sudo = None
        become_method = None
        become_user = None
        module_path = None
        fork_num = BOCLOUD_ANSIBLE_CONFIG["forks"]
        passwords = dict(vault_pass='secret')
        if self.task.options and 'become' in self.task.options:
            become = self.task.options.get('become')
        if self.task.options and 'sudo' in self.task.options:
            sudo = self.task.options.get('sudo')
        if become or sudo:
            become = True
        if become:
            become_method = self.task.options.get('becomeMethod', 'sudo') if self.task.options else 'sudo'
            become_user = self.task.options.get('becomeUser', 'root') if self.task.options else 'root'
            passwords['become_pass'] = self.task.options.get('becomePass', '') if self.task.options else ''

        # set all option values to options
        option_items = ['connection', 'module_path', 'forks', 'become', 'become_method', 'become_user', 'check',
                        'diff', 'listhosts', 'listtasks', 'listtags', 'syntax']

        Options = namedtuple('Options', option_items)
        ops = Options(connection='smart', module_path=module_path, forks=fork_num, become=become,
                      become_method=become_method, become_user=become_user, check=False, diff=False,
                      listhosts=None, listtasks=None, listtags=None, syntax=None)
        logger.debug("The ansible options value is %s" % ops._asdict())

        return ops, passwords
    def _task_exec(self):
        loader = DataLoader()
        options, passwords = self._set_ansible_options_passwords()
        print(options)
        try: 
            inventory = self._create_inventory(loader)
            variable_manager = VariableManager(loader=loader, inventory=inventory)
            variable_manager.extra_vars = self.load_extra_vars(loader)
            options_vars = dict()
            options_vars['ansible_version'] = CLI.version_info(gitinfo=False)
            variable_manager.options_vars = options_vars
        except Exception, e:
                logger.error(traceback.format_exc())
                raise Exception("%s" %(str(e)))
        print("playbook-->%s" %(self.task.playbooks))
        
        if self.task.playbooks:
            # playbook rabbitmq callback send playbook file name to clean generated playbook file
            results_callback = ResultCallback(self.logpath, self.action)
            try:
                print("playbooks=>%s \n inventory=%s \n var=> %s" %(self.task.playbooks, inventory, \
                                                                    variable_manager))
                pbex = PlaybookExecutor(self.task.playbooks, inventory, variable_manager, loader, \
                                        options, passwords,callback=results_callback)
                result = pbex.run()
                log_result(self.task, result)
                return result
            except (SystemExit, SystemError), e:
                raise SystemExit("Force terminate ansible job %s. %s" %
                                 (self.task.queue, str(e)))
            except Exception, e:
                logger.error(traceback.format_exc())
                raise Exception("Run %s job exception. %s" % (self.task.queue, str(e)))
        else:
            msg = "The task didn't generate playbooks. Do nothing"
            logger.error(msg)
            raise ValueError(msg)

class JobEnv(object):
    def __init__(self,request):
        try:
            self.uuid = request['uuid']
            self.inventory_string = b64decode(request['inventory'])
            self.vars_string = b64decode(request['var'])
            self.playbook = request['playbook']
            self.action = "%s" %(request['action'])
            self.check_yaml()
            self.check_ansible_protery()
        except Exception, e:
            raise Exception((u"非法的HTTP请求 - %s" %(str(e))).encode("UTF-8"))
#            raise Exception("Invalid HTTP request - %s" %(str(e)))    
        self.req = request
    def check_yaml(self):
        error_str = u"载入yaml文件失败"
        try:
            yaml_path = u"%s/%s.yaml" %(self.playbook, self.action)
            yml_path = u"%s/%s.yml" %(self.playbook, self.action)
            xpath = yaml_path
            if path.exists(yaml_path):
                xpath = yaml_path
                self.action = "%s.yaml"%(self.action)
            if path.exists(yml_path):
                xpath = yml_path
                self.action = "%s.yml"%(self.action)
            logger.info(xpath)
            #yaml.load(self.inventory_string)
            yaml.load(self.vars_string)
            #yaml.load(self.inventory_string, Loader=yaml.FullLoader)
            #yaml.load(self.vars_string, Loader=yaml.FullLoader)
            if not path.exists(xpath):
                error_str = u"%s: %s 文件路径不存在" %(error_str, xpath)  
                raise
            if not path.isfile(xpath):
                error_str = u"%s: %s 文件不存在" %(error_str, xpath)
                raise
            if not access(xpath, R_OK):
                error_str = u"%s: 访问%s权限不足" %(error_str, xpath)
                raise
        except Exception, e:
            raise Exception(error_str.encode("UTF-8"))
            #raise Exception("loading yaml failed")
    def check_ansible_protery(self):
        loader = DataLoader()
        data = loader.load(self.vars_string)
        if data and  not isinstance(data, MutableMapping):
            raise AnsibleOptionsError((u"非法的extra vars,请检查var.yaml文件").encode("UTF-8"))
            #raise AnsibleOptionsError("Invalid extra vars data supplied. var.yaml could not be made into a dictionary")
        
