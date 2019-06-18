#!/usr/bin/python
# -*- coding: utf-8 -*-

import os,sys
from kazoo.client import KazooClient
from kazoo.client import KazooState
import logging
logging.basicConfig()

import configparser

config = configparser.ConfigParser()

DIR=sys.path[0]

CONFIG_FILE=DIR+"/../config/Common.conf"

os.path.exists(CONFIG_FILE)
config.read(CONFIG_FILE)

# Get info from config
#DB_IP=config.get('DB', 'DB_CLUSTER_VIP')
DB_IP=config.get('DB', 'DB_HOST_IP')
DB_USER=config.get('DB', 'DB_USER')
DB_PASS=config.get('DB', 'DB_PASS')
DB_PORT=config.get('DB', 'DB_PORT')

#ZABBIX_IP=config.get('ZABBIX', 'ZABBIX_HOST_IP')
PIPLELINE_IP=config.get('PIPLELINE', 'PIPELINE_HOST_IP')

# Common Info
BASE_USER=config.get('DEFAULT', 'BASE_USER')
BASE_PASS=config.get('DEFAULT', 'BASE_PASSWD')

'''
application={"jdbc.url":"jdbc:mysql://127.0.0.1:3306/nacha_deployer?characterEncoding=utf8",\
"jdbc.username":"root","jdbc.password":"onceas","v2ResourceSwitch":"false"}
'''
application_data={}
def inject_application(key, value):
    #print("Inject application data")
    application_data[key] = value


inject_application("jdbc.url", str("jdbc:mysql://"+DB_IP+":"+DB_PORT+"/nacha_deployer?characterEncoding=utf8"))
inject_application("jdbc.username", str(DB_USER))
inject_application("jdbc.password", str(DB_PASS))
inject_application("v2ResourceSwitch", str("false"))


'''
deployer={"jdbc.url":"jdbc:mysql://127.0.0.1:3306/nacha_deployer?characterEncoding=utf8",\
"jdbc.username":"root","jdbc.password":"onceas"}
'''
deployer_data={}
def inject_deployer(key, value):
    #print("Inject pipeline data")
    deployer_data[key] = value


inject_deployer("jdbc.url", str("jdbc:mysql://"+DB_IP+":"+DB_PORT+"/nacha_deployer?characterEncoding=utf8"))
inject_deployer("jdbc.username", str(DB_USER))
inject_deployer("jdbc.password", str(DB_PASS))


'''
monitor={"jdbc.url":"jdbc:mysql://127.0.0.1:3306/zabbix?characterEncoding=utf8",\
"jdbc.username":"zabbix","jdbc.password":"zabbix","zabbix.server.url":"http://127.0.0.1:80",\
"zabbix.user":"Admin","zabbix.pwd":"zabbix"}
'''

#monitor_data = {}
#def inject_monitor(key, value):
#    #print("Inject monitor  data")
#    monitor_data[key] = value
#

#inject_monitor("jdbc.url", str("jdbc:mysql://"+ZABBIX_IP+":3306/zabbix?characterEncoding=utf8"))
#inject_monitor("jdbc.username", str("zabbix"))
#inject_monitor("jdbc.password", str("zabbix"))
#inject_monitor("zabbix.server.url", str("http://"+ZABBIX_IP+":80"))
#inject_monitor("zabbix.user", str("Admin"))
#inject_monitor("zabbix.pwd", str("zabbix"))


'''
pipeline={"jdbc.url":"jdbc:mysql://127.0.0.1:3306/nacha_pipeline?characterEncoding=utf8",\
"jdbc.username":"root","jdbc.password":"password","pipeline.host.ip":"127.0.0.1",\
"pipeline.host.user":"root","pipeline.host.pwd":"password"}

---update_0627---
pipeline={"jdbc.url":"jdbc:mysql://192.168.1.86:3306/nacha_pipeline?characterEncoding=utf8",\
"jdbc.username":"root","jdbc.password":"onceas",
"jenkins.workspace":"/abcs/jenkins-2.46.3/jenkins/workspace/",
"jenkins.user":"admin","jenkins.pwd":"admin",
"jenkins.url":"http://192.168.1.82:8080/jenkins/",
"jenkins.strategy.daysToKeep":"5","jenkins.strategy.numToKeep":"20"}
'''
pipeline_data = {}

def inject_pipeline(key, value):
    #print("Inject pipeline data")
    pipeline_data[key] = value


inject_pipeline("jdbc.url", str("jdbc:mysql://"+DB_IP+":"+DB_PORT+"/nacha_pipeline?characterEncoding=utf8"))
inject_pipeline("jdbc.username", str(DB_USER))
inject_pipeline("jdbc.password", str(DB_PASS))
inject_pipeline("jenkins.workspace",str("/abcs/jenkins-2.46.3/jenkins/workspace/"))
inject_pipeline("jenkins.url", str("http://"+PIPLELINE_IP+":8080/jenkins/"))
inject_pipeline("jenkins.user", str("admin"))
inject_pipeline("jenkins.pwd", str("admin"))
inject_pipeline("jenkins.strategy.daysToKeep", str("5"))
inject_pipeline("jenkins.strategy.numToKeep", str("20"))


'''
runtime={"jdbc.url":"jdbc:mysql://127.0.0.1:3306/nacha_runtime?characterEncoding=utf8"\
,"jdbc.username":"root","jdbc.password":"password","pipeline.host.ip":"127.0.0.1",\
"pipeline.host.user":"root","pipeline.host.pwd":"password","image.copy.threads":"2",\
"image.copy.cron":"0 0/5 * * * ?","registry.update.cron":"0 0/5 * * * ?",\
"cluster.health.cron":"0/30 * * * * ?","http.time.out":"1800000","monitor.host.cron":"0 0/2 * * * ?"}
'''

runtime_data={}
def inject_runtime(key, value):
    #print("Inject runtime data")
    runtime_data[key] = value


inject_runtime("jdbc.url", str("jdbc:mysql://"+DB_IP+":"+DB_PORT+"/nacha_runtime?characterEncoding=utf8"))
inject_runtime("jdbc.username", str(DB_USER))
inject_runtime("jdbc.password", str(DB_PASS))
inject_runtime("pipeline.host.ip", str(PIPLELINE_IP))
inject_runtime("pipeline.host.user", str(BASE_USER))
inject_runtime("pipeline.host.pwd", str(BASE_PASS))
inject_runtime("image.copy.threads", str("2"))
inject_runtime("image.copy.cron", str("0 0/5 * * * ?"))
inject_runtime("registry.update.cron", str("0 0/5 * * * ?"))
inject_runtime("cluster.health.cron", str("0/30 * * * * ?"))
inject_runtime("http.time.out", str("1800000"))
inject_runtime("monitor.host.cron", str("0 0/2 * * * ?"))


'''
system={"pipeline.host.ip":"127.0.0.1","pipeline.host.user":"root","pipeline.host.pwd":"password"}
'''
system_data = {}
def inject_system(key, value):
    #print("Inject System Data")
    system_data[key] = value


inject_system("pipeline.host.ip", str(PIPLELINE_IP))
inject_system("pipeline.host.user", str(BASE_USER))
inject_system("pipeline.host.pwd", str(BASE_PASS))


'''
appstore={"jdbc.url":"jdbc:mysql://127.0.0.1:3306/nacha_appstore?characterEncoding=utf8",\
"jdbc.username":"root","jdbc.password":"onceas"}
'''

appstore_data = {}
def inject_appstore(key, value):
    #print("Inject Appstore Data")
    appstore_data[key] = value


inject_appstore("jdbc.url", str("jdbc:mysql://"+DB_IP+":"+DB_PORT+"/nacha_appstore?characterEncoding=utf8"))
inject_appstore("jdbc.username", str(DB_USER))
inject_appstore("jdbc.password", str(DB_PASS))


'''
auth={"file.upload.dir":"/abcsys/upload"}
'''
auth_data = {}
def inject_auth(key, value):
    #print("Inject Auth Data")
    auth_data[key] = value


inject_auth("file.upload.dir", str("/abcsys/upload"))


#ZK
ZK_HOST=config.get('ZK', 'ZK_HOST_01_IP')
zk = KazooClient(hosts=ZK_HOST+':2181')

#def state_listener(state):
#    if state == KazooState.LOST:
#        # Register somewhere that the session was lost
#        zk.start()
#    elif state == KazooState.SUSPENDED:
#        # Handle being disconnected from Zookeeper
#        zk.start()
#    else:
#        # Handle being connected/reconnected to Zookeeper
#        print("OK")
#
#
#zk.add_listener(state_listener)

#print str(application_data).encode('raw_unicode_escape')  
zk.start()

# Ensure a path, create if necessary
zk.ensure_path('/boc/configs')

# application
if zk.exists("/boc/configs/application"):
    zk.set("/boc/configs/application", str(application_data).encode('utf-8'))
else:
    zk.delete("/boc/configs/application", recursive=True)
    zk.create("/boc/configs/application", str(application_data).encode('utf-8'))

# depolyer
if zk.exists("/boc/configs/deployer"):
    zk.set("/boc/configs/deployer", str(deployer_data).encode('utf-8'))
else:
    # zk.delete("/boc/configs/deployer", recursive=True)
    zk.create("/boc/configs/deployer", str(deployer_data).encode('utf-8'))

## monitor
#if zk.exists("/boc/configs/monitor"):
#    zk.set("/boc/configs/monitor", str(monitor_data).encode('utf-8'))
#else:
#    # zk.delete("/boc/configs/monitor", recursive=True)
#    zk.create("/boc/configs/monitor", str(monitor_data).encode('utf-8'))

# pipeline
if zk.exists('/boc/configs/pipeline'):
    zk.set("/boc/configs/pipeline", str(pipeline_data).encode('utf-8'))
else:
    # Create a node with data
    zk.create("/boc/configs/pipeline", str(pipeline_data).encode('utf-8'))

# runtime
if zk.exists("/boc/configs/runtime"):
    zk.set("/boc/configs/runtime", str(runtime_data).encode('utf-8'))
else:
    # zk.delete("/boc/configs/runtime", recursive=True)
    zk.create("/boc/configs/runtime", str(runtime_data).encode('utf-8'))

# system
if zk.exists("/boc/configs/system"):
    zk.set("/boc/configs/system", str(system_data).encode('utf-8'))
else:
    # zk.delete("/boc/configs/system", recursive=True)
    zk.create("/boc/configs/system", str(system_data).encode('utf-8'))

# Appstore
if zk.exists("/boc/configs/appstore"):
    zk.set("/boc/configs/appstore", str(appstore_data).encode('utf-8'))
else:
    # zk.delete("/boc/configs/appstore", recursive=True)
    zk.create("/boc/configs/appstore", str(appstore_data).encode('utf-8') )

# auth
if zk.exists("/boc/configs/auth"):
    zk.set("/boc/configs/auth", str(auth_data).encode('utf-8'))
else:
    # zk.delete("/boc/configs/auth", recursive=True)
    zk.create("/boc/configs/auth", str(auth_data).encode('utf-8'))

zk.stop()
