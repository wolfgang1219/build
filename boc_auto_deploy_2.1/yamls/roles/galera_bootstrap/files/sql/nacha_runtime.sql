/*
Navicat MySQL Data Transfer

Source Server         : 192.168.2.181
Source Server Version : 50505
Source Host           : 192.168.2.181:3306
Source Database       : nacha_runtime

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2018-03-26 17:14:45
*/
CREATE database if NOT EXISTS `nacha_runtime` default character set utf8 collate utf8_general_ci;

USE nacha_runtime;

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for runtime_alert_rule
-- ----------------------------
DROP TABLE IF EXISTS `runtime_alert_rule`;
CREATE TABLE `runtime_alert_rule`(  
  `ID` int(11) NOT NULL Auto_increment COMMENT '告警ID',
  `ALERT` varchar(50) COMMENT '告警名称',
  `MONITOR_TYPE` tinyint(4) COMMENT '监控类型 0主机 1容器',
  `METRIC` varchar(50) COMMENT '监控指标 CPU MEM DISK NETWORK',
  `SEVERITY` varchar(20) COMMENT '告警级别  warning警告 critical严重 error致命',
  `OPERATOR` varchar(10) COMMENT '操作符 < = >',
  `VALUE` varchar(10) COMMENT '阈值',
  `DURATION` varchar(10) COMMENT '持续时间',
  `UNIT` varchar(10) COMMENT '时间单位 m分钟 h小时 d天',
  `EXPR` varchar(200) COMMENT '最终生成的监控表达式',
  `DESCRIPTION` varchar(200) COMMENT '描述',
  `STATUS` tinyint(4) DEFAULT 1 COMMENT '状态 1正常 0删除',
  `STATE` tinyint(4) DEFAULT 1 COMMENT '可用状态 1可用 0禁用',
  `CLUSTER_ID` int(11) COMMENT '集群Id',
  `USER_ID` int(11) COMMENT '创建者Id',
  `CREATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  primary key (`ID`)
) ENGINE=InnoDB charset=utf8 collate=utf8_general_ci;

-- ----------------------------
-- Table structure for runtime_cluster
-- ----------------------------
DROP TABLE IF EXISTS `runtime_cluster`;
CREATE TABLE `runtime_cluster` (
  `CLUSTER_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '集群的唯一标识符',
  `CLUSTER_NAME` varchar(80) NOT NULL COMMENT '集群名称，可以给默认名称，规则是用户+集群+ID',
  `CLUSTER_HOST_ID` varchar(90) NOT NULL COMMENT '集群所在主机IP,最多有3个，通过;区分，适用高可用场景',
  `CLUSTER_PORT` varchar(100) DEFAULT NULL COMMENT '端口',
  `CLUSTER_TYPE` varchar(10) NOT NULL DEFAULT 'http' COMMENT '集群类型',
  `CLUSTER_REGISTRY_ID` varchar (100) DEFAULT NULL COMMENT '仓库集群关联仓库 可多选 ,隔开',
  `CLUSTER_STATUS` tinyint(4) NOT NULL DEFAULT '1' COMMENT '集群状态, 如 0:不可用（集群中无Host资源），1:健康，2不健康',
  `CLUSTER_DESC` varchar(200) DEFAULT NULL COMMENT '描述信息',
  `CLUSTER_RES_TYPE` tinyint(4) DEFAULT '0' COMMENT '0:资源共享(CPU按照1：3比例放大，MEM按照默认1GB计算)   1：资源独占',
  `CLUSTER_TOTAL_CPU` int(11) NOT NULL DEFAULT '0' COMMENT 'CPU',
  `CLUSTER_TOTAL_MEM` int(11) NOT NULL DEFAULT '0' COMMENT '内存',
  `CLUSTER_FREE_CPU` int(11) NOT NULL DEFAULT '0' COMMENT 'CPU',
  `CLUSTER_FREE_MEM` int(11) NOT NULL DEFAULT '0' COMMENT '内存',
  `CLUSTER_CREATETIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `CLUSTER_CREATOR` int(11) NOT NULL COMMENT '创建用户',
  `SERVICE_IP` varchar(100) DEFAULT NULL COMMENT '高可用地址',
  `HA_ENABLE` tinyint(4) DEFAULT NULL COMMENT '高可用(1是，0否)',
  `PLATFORM_TYPE` varchar(255) DEFAULT 'kubernetes' COMMENT '平台类型',
  `DEFAULT_ENVID` int(11) DEFAULT NULL COMMENT '默认环境ID',
  `DEFAULT_ENVNAME` varchar(255) DEFAULT '' COMMENT '默认租户名称',
  `TOKEN` varchar(2048) DEFAULT '' COMMENT 'openshift token',
  `LOG_ADDR` varchar(255) DEFAULT '' COMMENT '集群日志收集地址',
  `INGRESS_ADDR` varchar(255) DEFAULT '' COMMENT '集群负载Ingress地址',
  `PROMETHEUS_ADDR` varchar(255) DEFAULT '' COMMENT '集群Prometheus地址',
  `VERSION` varchar(255) DEFAULT '' COMMENT '集群版本',
  `ES_ADDR` varchar(255) DEFAULT '' COMMENT 'es地址',
  `ES_NAME` varchar(255) DEFAULT '' COMMENT 'es名称',
  `CLUSTER_REAL_NAME` varchar(255) NULL COMMENT '集群实际使用的拼音',
  `REMOTE_API_ADDR` varchar(255) DEFAULT NULL COMMENT '集群API地址',
  `KUBEWATCH_NAME` varchar(255) DEFAULT NULL COMMENT 'kubewarch name',
  `SKYWALKING_ADDR` varchar(255) DEFAULT '' COMMENT 'skywalkingAddr地址',
  `SKYWALKING_PROBE_ADDR` varchar(255) DEFAULT '' COMMENT 'skywalking探针地址',
  `NETWORK_TYPE` varchar(255) DEFAULT '' COMMENT '网络类型 fabric,calico',
  `APOLLO_CALLBACK_ADDR` varchar(255) DEFAULT '' COMMENT 'Apollo回调地址',
  `ES_ALERT_ADDR` varchar(255) DEFAULT '' COMMENT 'ElastAlert地址',
  PRIMARY KEY (`CLUSTER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of runtime_cluster
-- ----------------------------

-- ----------------------------
-- Table structure for runtime_host_tag
-- ----------------------------
DROP TABLE IF EXISTS `runtime_host_tag`;
CREATE TABLE `runtime_host_tag` (
  `TAG_ID` int (11) NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `CLUSTER_ID` int (11) COMMENT '集群ID',
  `HOST_IDS` varchar (100) COMMENT '主机ID们，用,隔开',
  `TAG_KEY` varchar (250) COMMENT '标签Key',
  `TAG_VALUE` varchar (250) COMMENT '标签值',
  `STATUS` tinyint(4) DEFAULT 1 NULL COMMENT '状态 1存在 0删除',
  `partition_id` int(11)  COMMENT '分区编号',
  `env_id` int(11) COMMENT '租户id',
  primary key (`TAG_ID`)
) ENGINE = InnoDB charset = utf8 collate = utf8_general_ci ;

-- ----------------------------
-- Records of runtime_host_tag
-- ----------------------------

-- ----------------------------
-- Table structure for runtime_cluster_health
-- ----------------------------
DROP TABLE IF EXISTS `runtime_cluster_health`;
CREATE TABLE `runtime_cluster_health` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `CLUSTER_ID` int(11) DEFAULT NULL COMMENT '集群ID',
  `HOST_ID` int(11) DEFAULT NULL COMMENT '主机ID',
  `CONDITION_TYPE` varchar(20) DEFAULT NULL COMMENT 'Node状态类型',
  `CONDITION_STATUS` tinyint(4) DEFAULT NULL COMMENT 'Node状态 0 False 1 True 2 Unknown 3 属于服务检测的标志位 5是集群同步主机异常  7属于提示类信息',
  `CONDITION_MESSAGE` varchar(256) DEFAULT NULL COMMENT 'Node状态信息',
  `CONDITION_REASON` varchar(128) DEFAULT NULL COMMENT 'Node状态理由',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of runtime_cluster_health
-- ----------------------------

-- ----------------------------
-- Table structure for runtime_dockerfile_template
-- ----------------------------
DROP TABLE IF EXISTS `runtime_dockerfile_template`;
CREATE TABLE `runtime_dockerfile_template` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `FILE_NAME` varchar(200) DEFAULT NULL COMMENT '文件名称',
  `FILE_LABEL` varchar(200) DEFAULT NULL COMMENT '文件标签，用于文件分类，可模糊查询',
  `FILE_CONTENT` mediumblob COMMENT '文件内容',
  `STATUS` tinyint(4) DEFAULT NULL COMMENT '状态（0删除，1正常可用）',
  `CREATOR_ID` int(11) DEFAULT NULL COMMENT '创建人',
  `CREATOR_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `ENV_ID` int(11) DEFAULT NULL COMMENT '环境ID',
  `PROJECT_IDS` varchar(50) DEFAULT NULL COMMENT '项目IDS 可能会有多个ID',
  `FILE_TYPE` tinyint(4) DEFAULT NULL COMMENT '文件类型（0Dockerfile,1yaml）',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of runtime_dockerfile_template
-- ----------------------------

-- ----------------------------
-- Table structure for runtime_event
-- ----------------------------
DROP TABLE IF EXISTS `runtime_event`;
CREATE TABLE `runtime_event` (
  `EVENT_ID` int(11) NOT NULL AUTO_INCREMENT  COMMENT '主键',
  `EVENT_TYPE` varchar(10) DEFAULT NULL COMMENT '事件所属类型(cluster或者其他)',
  `EVENT_DESC` varchar(255) DEFAULT NULL COMMENT '实践描述',
  `EVENT_RESULT` varchar(255) DEFAULT NULL COMMENT '事件执行结果',
  `EVENT_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT '事件创建时间',
  `EVENT_OBJECT_ID` int(11) DEFAULT NULL COMMENT '事件产生的对象',
  `EVENT_NAME` varchar(255) DEFAULT NULL COMMENT '事件名称',
  `EVENT_CREATOR` int(11) DEFAULT NULL COMMENT '执行人',
  PRIMARY KEY (`EVENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of runtime_event
-- ----------------------------

-- ----------------------------
-- Table structure for runtime_host
-- ----------------------------
DROP TABLE IF EXISTS `runtime_host`;
CREATE TABLE `runtime_host` (
  `HOST_ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主机id',
  `HOST_UUID` varchar(64) DEFAULT NULL COMMENT '主机uuid',
  `HOST_NAME` varchar(80) DEFAULT NULL COMMENT '主机名称',
  `HOST_IP` varchar(30) DEFAULT NULL COMMENT '主机ip',
  `HOST_REAL_NAME` varchar(255) DEFAULT NULL COMMENT '主机实际名称',
  `HOST_USER` varchar(80) DEFAULT NULL COMMENT '主机用户名（登录）',
  `HOST_PWD` blob COMMENT '密码',
  `HOST_TYPE` tinyint(4) DEFAULT NULL COMMENT '主机类型(0,master,1,node,2,registry,3,lb,4,只作为监控对象)',
  `HOST_CPU` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'CPU',
  `HOST_MEM` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '内存',
  `HOST_GPU` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'GPU',
  `HOST_STATUS` tinyint(4) NOT NULL DEFAULT '1' COMMENT '主机状态(0,删除，1正常，2.关机，3，异常，4，维护,5安装中,6删除中,7安装成功,8安装失败,9删除成功，10删除失败)',
  `HOST_DESC` varchar(200) DEFAULT NULL COMMENT '描述信息',
  `HOST_KERNEL_VERSION` varchar(80) DEFAULT NULL COMMENT 'kernel版本信息',
  `DOCKER_VERSION` varchar(100) DEFAULT NULL COMMENT 'docker的版本',
  `HOST_CREATETIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `HOST_CREATOR` int(10) unsigned NOT NULL COMMENT '创建人',
  `CLUSTER_ID` int(11) DEFAULT NULL COMMENT '所属集群',
  `KUBE_VERSION` varchar(100) DEFAULT NULL COMMENT 'kubernetes版本',
  `KUBE_TYPE` varchar(10) DEFAULT NULL COMMENT '集群类型（https支持dns）',
  `REGISTRY_VERSION` varchar(100) DEFAULT NULL COMMENT '私有仓库版本',
  `HOST_OS` varchar(255) DEFAULT NULL COMMENT '系统信息',
  `HOST_BOOT` timestamp NULL DEFAULT NULL COMMENT '启动时间',
  `REGISTRY_ID` int(11) DEFAULT NULL COMMENT '仓库',
  `NETWOKR` varchar(4000) DEFAULT NULL COMMENT '网络',
  `NGINX_VERSION` varchar(100) DEFAULT NULL COMMENT 'nginx服务版本',
  `HOST_MONITOR_STATUS` tinyint(4) DEFAULT NULL COMMENT '主机监控状态 0异常 1正常',
  `ENV_ID` int(11) DEFAULT NULL COMMENT '所属租户',
  `PLATFORM_TYPE` varchar(255) DEFAULT 'kubernetes' COMMENT '平台类型',
  `SCHEDULING_STATUS` tinyint (4) DEFAULT 1 NOT NULL COMMENT '调度状态 0不可调度 1可调度',
  partition_id INTEGER(11) default null COMMENT '主机所属分区',
  INSTALL_STATUS INTEGER(4) DEFAULT NULL COMMENT '主机安装状态(5安装中,6删除中,7安装成功,8安装失败,9删除成功，10删除失败)',
  `HOST_POD` int(11) UNSIGNED NOT NULL DEFAULT 110 COMMENT '主机pod数',
  `NETWORK_TYPE` varchar(255) DEFAULT '' COMMENT '网络类型 fabric,calico',
  PRIMARY KEY (`HOST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of runtime_host
-- ----------------------------

-- ----------------------------
-- Table structure for runtime_image
-- ----------------------------
DROP TABLE IF EXISTS `runtime_image`;
CREATE TABLE `runtime_image` (
  `IMAGE_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '镜像id',
  `IMAGE_UUID` varchar(64) DEFAULT NULL COMMENT '镜像的uuid',
  `IMAGE_STATUS` tinyint(4) NOT NULL COMMENT '镜像状态(0异常，1正常)',
  `IMAGE_NAME` varchar(512) CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL COMMENT '镜像名称',
  `IMAGE_LABEL` varchar(255) DEFAULT NULL COMMENT '镜像标签名称',
  `IMAGE_TAG` varchar(100) DEFAULT NULL COMMENT '镜像版本信息',
  `IMAGE_SIZE` varchar(10) DEFAULT NULL COMMENT '镜像大小',
  `IMAGE_DESC` varchar(200) DEFAULT NULL COMMENT '描述信息',
  `APPLICATION_ID` int(10) unsigned DEFAULT NULL COMMENT '应用id',
  `PROJECT_ID` int(10) DEFAULT NULL COMMENT '项目id',
  `APPLICATION_NAME` varchar(255) DEFAULT NULL COMMENT '所属应用名称',
  `IMAGE_TYPE` varchar(50) DEFAULT NULL COMMENT '镜像类型(BASIC,APPLICATION,PUBLIC)',
  `REGISTRY_ID` int(11) DEFAULT NULL COMMENT '所属仓库ID',
  `IMAGE_CREATETIME` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `IMAGE_CREATOR` int(10) unsigned DEFAULT NULL COMMENT '创建者',
  `ENV_ID` int(11) DEFAULT NULL COMMENT '所属租户ID',
  `IMAGE_SCAN_STATUS` tinyint(4) DEFAULT NULL COMMENT '镜像扫描状态（0：未扫描，1：扫描成功，2：扫描失败，3：正在扫描）',
  `DEPLOY_STATUS` tinyint(4) DEFAULT NULL COMMENT '部署状态（0未部署，1已部署）',
  `ENV_NAME` varchar(255) DEFAULT NULL COMMENT '租户名称',
  `IMAGE_SOURCE` varchar(50) DEFAULT NULL COMMENT '镜像来源',
  PRIMARY KEY (`IMAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of runtime_image
-- ----------------------------

-- ----------------------------
-- Table structure for runtime_image_copy
-- ----------------------------
DROP TABLE IF EXISTS `runtime_image_copy`;
CREATE TABLE `runtime_image_copy` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `IMAGE_NAME` varchar(512) CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL COMMENT '镜像名称',
  `IMAGE_TAG` varchar(64) DEFAULT NULL COMMENT '镜像版本Tag',
  `REGISTRY_OLD` int(11) DEFAULT NULL COMMENT '源仓库ID',
  `REGISTRY_NEW` int(11) DEFAULT NULL COMMENT '新仓库ID',
  `COPY_STATUS` tinyint(4) DEFAULT NULL COMMENT '执行状态 0未执行 1成功 2失败 3执行中',
  `COPY_GROUP` varchar(20) DEFAULT NULL COMMENT '分组时间戳',
  `ENV_ID` int(11) DEFAULT NULL COMMENT '环境ID',
  `USER_ID` int(11) DEFAULT NULL COMMENT '创建者',
  `IMAGE_ID` int(11) DEFAULT NULL COMMENT '源镜像在镜像表中的id',
  `IMAGE_UUID` varchar(64) DEFAULT NULL COMMENT '源镜像在镜像表中的uuid',
  `IMAGE_TYPE` varchar(50) DEFAULT NULL COMMENT '源镜像在镜像表中的镜像类型',
  `COPY_MESSAGE` varchar(100) DEFAULT NULL COMMENT 'Copy信息描述',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of runtime_image_copy
-- ----------------------------

-- ----------------------------
-- Table structure for runtime_ipmanager
-- ----------------------------
DROP TABLE IF EXISTS `runtime_ipmanager`;
CREATE TABLE `runtime_ipmanager` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `IP_ADDRESS` varchar(30) DEFAULT NULL COMMENT 'IP地址',
  `IP_STATUS` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：1可用，0占用',
  `IP_REMARK` tinyint(4) DEFAULT NULL COMMENT '标识',
  `USE_OBJECT` varchar(255) DEFAULT NULL COMMENT '使用对象',
  `USE_TYPE` varchar(255) DEFAULT NULL COMMENT '使用对象类型',
  `OBEJCT_ID` int(11) DEFAULT NULL COMMENT '使用对象主键',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IP_ADDRESS` (`IP_ADDRESS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of runtime_ipmanager
-- ----------------------------

-- ----------------------------
-- Table structure for runtime_registry
-- ----------------------------
DROP TABLE IF EXISTS `runtime_registry`;
CREATE TABLE `runtime_registry` (
  `REGISTRY_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `REGISTRY_NAME` varchar(255) DEFAULT NULL COMMENT '仓库名称',
  `REGISTRY_PORT` varchar(11) DEFAULT NULL COMMENT '仓库端口',
  `REGISTRY_STATUS` tinyint(4) DEFAULT NULL COMMENT '仓库状态(0不正常，1正常，2监控异常)',
  `HOST_ID` varchar(255) DEFAULT NULL COMMENT '仓库主机ID,多个用，分隔',
  `REGISTRY_DESC` varchar(255) DEFAULT NULL COMMENT '描述信息',
  `REGISTRY_CREATETIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `REGISTRY_CREATOR` int(11) DEFAULT NULL COMMENT '创建人',
  `REGISTRY_SERVICE_IP` varchar(255) DEFAULT NULL COMMENT '仓库虚拟IP',
  `HA_ENABLE` tinyint(4) DEFAULT NULL COMMENT '是否启用仓库高可用（1是，0否，2未定义）',
  `REGISTRY_URL` varchar(200) NOT NULL COMMENT '仓库',
  `REGISTRY_TYPE` varchar(255) DEFAULT NULL COMMENT '仓库类型（PRIVATE,PUBLIC）',
  `REGISTRY_NETWORK_TYPE` varchar (10) DEFAULT 'http' NOT NULL COMMENT '仓库网络类型，http、https类型',
  `REGISTRY_MONITOR_INFO` varchar(4000) DEFAULT '' COMMENT '仓库监控异常信息',
  PRIMARY KEY (`REGISTRY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of runtime_registry
-- ----------------------------

-- ----------------------------
-- Table structure for runtime_storage_detail
-- ----------------------------
DROP TABLE IF EXISTS `runtime_storage_detail`;
CREATE TABLE `runtime_storage_detail` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `HOST_ID` int(11) DEFAULT NULL COMMENT 'HostID',
  `STORAGE_STATUS` tinyint(4) DEFAULT NULL COMMENT '挂载状态 1已挂载 0未卸载',
  `STORAGE_MESSAGE` varchar(100) DEFAULT NULL COMMENT '挂载失败信息',
  `STORAGE_ID` int(11) DEFAULT NULL COMMENT '挂载Id',
  `STORAGE_PATH` varchar(128) DEFAULT NULL COMMENT '挂载目录(单个)',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of runtime_storage_detail
-- ----------------------------

-- ----------------------------
-- Table structure for runtime_storage_monitor
-- ----------------------------
DROP TABLE IF EXISTS `runtime_storage_monitor`;
CREATE TABLE `runtime_storage_monitor` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `OBJECT_NAME` varchar(50) DEFAULT NULL COMMENT '监控对象名称：hostname',
  `PATH` varchar(100) DEFAULT NULL COMMENT '指定监测的文件系统（挂载）路径',
  `MODE` varchar(20) DEFAULT NULL COMMENT 'total (缺省，总空间字节数) free （空闲空间字节数）used （使用空间字节数）pfree (空闲空间占总空间百分比), pused (使用空间占总空间百分比)',
  `STORAGE_ID` int(11) DEFAULT NULL COMMENT '存储Id',
  `HOST_ID` int(11) DEFAULT NULL COMMENT '主机HostId',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of runtime_storage_monitor
-- ----------------------------

-- ----------------------------
-- Table structure for runtime_storage_mount
-- ----------------------------
DROP TABLE IF EXISTS `runtime_storage_mount`;
CREATE TABLE `runtime_storage_mount` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `STORAGE_NAME` varchar(64) DEFAULT NULL COMMENT '挂载存储名称',
  `STORAGE_TYPE` tinyint(4) DEFAULT NULL COMMENT '挂载存储方式 0 是nfs 1 是gfs',
  `STORAGE_PATH` varchar(128) DEFAULT NULL COMMENT '挂载目录',
  `DATA_TYPE` tinyint(4) DEFAULT NULL COMMENT '数据类型 0基础平台存储 1应用数据存储',
  `STORAGE_SERVER_PATH` varchar(128) DEFAULT NULL COMMENT '挂载Server路径',
  `STORAGE_STATUS` tinyint(4) DEFAULT NULL COMMENT '挂载状态 1已挂载 0未卸载',
  `STATUS` tinyint(4) DEFAULT NULL COMMENT '状态 1正常 0删除',
  `USER_ID` int(11) DEFAULT NULL COMMENT '创建者Id',
  `ENV_ID` int(11) DEFAULT NULL COMMENT '环境ID',
  `CLUSTER_ID` int(11) DEFAULT NULL COMMENT '集群ID',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of runtime_storage_mount
-- ----------------------------

-- HOST_MONITOR_STATUS defualt=1
update runtime_host set HOST_MONITOR_STATUS=1 where HOST_MONITOR_STATUS=null;
alter table runtime_host modify `HOST_MONITOR_STATUS` tinyint(4) NOT NULL DEFAULT 1 COMMENT '主机监控状态 0异常 1正常';

-- ----------------------------
-- Table structure for runtime_image_scanner
-- ----------------------------
DROP TABLE IF EXISTS `runtime_image_scanner`;
CREATE TABLE `runtime_image_scanner` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `IMAGE_UUID` varchar(80) DEFAULT NULL COMMENT '镜像UUID',
  `IMAGE_NAME` varchar(255) NOT NULL DEFAULT '' COMMENT '镜像全名',
  `IMAGE_TAG` varchar(255) DEFAULT '' COMMENT '镜像标签',
  `IMAGE_ID` int(11) NOT NULL COMMENT '镜像表ID',
  `SCANNER_TIMES` int(11) NOT NULL DEFAULT 0 COMMENT '扫描次数',
  `HOST_IP` varchar(255) NOT NULL DEFAULT '' COMMENT '扫描所在主机',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `runtime_env_partition`;
CREATE TABLE `runtime_env_partition` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `partition_id` int(11)   COMMENT '分区编号',
  `env_id` int(11)   COMMENT '租户编号',
  `env_name` varchar(255) DEFAULT NULL COMMENT '租户账户名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `runtime_partition`;
CREATE TABLE `runtime_partition` (
  `partition_id` int(11) NOT NULL AUTO_INCREMENT  COMMENT '主键',
  `partition_name` varchar(255) DEFAULT NULL COMMENT '分区名称',
  `partition_cluster_id` int(11) DEFAULT NULL COMMENT '所属集群',
  `partition_env_id` int(11) DEFAULT NULL COMMENT '所属租户',
  `partition_host_num` int(11) DEFAULT NULL COMMENT '包含主机数',
  `partition_state` int(3) DEFAULT 0 COMMENT '分区状态：0 可用 1 不可用',
  `partition_share` int(3) DEFAULT 0 COMMENT '是否可共享：0 不可共享 1 可共享',
  `partition_cluster_name` varchar(255) DEFAULT NULL COMMENT '所属集群名称',
  `partition_env_name` varchar(255) DEFAULT NULL COMMENT '所属租户名称',
  `create_time` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '创建时间',
  `partition_describe` text DEFAULT NULL COMMENT '备注信息',
  `partition_real_name` varchar(255) DEFAULT NULL COMMENT '分区真实名称，用于k8s标签',
  `partition_kind` int(11) DEFAULT 0 COMMENT '分区类型：0普通分区 1默认分区',
  `default_partition_id` int(11) COMMENT '默认分区id',
  PRIMARY KEY (`partition_id`)
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `runtime_node`;
CREATE TABLE `runtime_node` (
  `NODE_ID` int (11) NOT NULL AUTO_INCREMENT COMMENT '节点的id',
  `HOST_ID` int (11) COMMENT '主机id',
  `HOST_NAME` varchar (250) COMMENT '主机名称',
  `HOST_USER` varchar (250) COMMENT '主机的用户',
  `HOST_PWD` varchar (250) COMMENT '主机的密码',
  `HOST_IP` varchar (250) COMMENT '节点主机ip',
  `NODE_KEY` varchar (100) COMMENT '查询主机状态的key',
  `SERVER_STATUS` varchar (100) COMMENT '最后一次查询状态',
  `NODE_STATUS` tinyint(4) DEFAULT 1 NULL COMMENT '状态 0安装中 1安装成功 2安装失败',
  `NODE_CREATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `SERVICE_IP` varchar (100) COMMENT '节点查询服务ip',
  `PARTITION_ID` int(11) DEFAULT NULL COMMENT '分区id',
  primary key (`NODE_ID`)
) ENGINE = InnoDB charset = utf8 collate = utf8_general_ci ;

-- 2018-12-24 dlj 租户表
DROP TABLE IF EXISTS `runtime_env`;
CREATE TABLE `runtime_env` (
  `env_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `env_name` varchar(500) DEFAULT NULL COMMENT '环境名称',
  `env_status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '环境状态(1正常，0住户默认)',
  `env_desc` varchar(200) DEFAULT NULL COMMENT '环境描述信息',
  `env_createtime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `env_creator` int(11) DEFAULT NULL COMMENT '创建人',
  `area_id` int(11) DEFAULT NULL COMMENT '所属区域ID',
  `cluster_id` int(11) DEFAULT NULL COMMENT '集群id',
  `config_repository` varchar(255) DEFAULT NULL COMMENT '配置仓库地址',
  `config_name` varchar(255) DEFAULT NULL COMMENT '配置仓库用户名',
  `config_password` varchar(255) DEFAULT NULL COMMENT '配置仓库密码',
  PRIMARY KEY (`env_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 2018-12-24 dlj 资源表
DROP TABLE IF EXISTS `runtime_resource`;
CREATE TABLE `runtime_resource` (
  `resource_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '资源id',
  `resource_envid` int(11) DEFAULT NULL COMMENT '环境编号',
  `resource_projectid` int(11) DEFAULT NULL COMMENT '应用编号',
  `resource_cpu` int(10) DEFAULT '0' COMMENT 'cpu限额',
  `resource_memory` int(10) DEFAULT '0' COMMENT '内存限额',
  `resource_instance` int(10) DEFAULT '0' COMMENT '实例个数',
  `resource_hd` int(10) DEFAULT '0' COMMENT '硬盘卷大小G',
  `default_cpu` varchar(50) DEFAULT NULL COMMENT '默认cpu',
  `default_mem` varchar(50) DEFAULT NULL COMMENT '默认mem',
  `resource_partitionid` int(11) DEFAULT NULL COMMENT '分区id',
  PRIMARY KEY (`resource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;

-- 2019-01-21 DZG 创建IngressMgr负载表
DROP TABLE IF EXISTS `runtime_ingress_mgr`;
create table `runtime_ingress_mgr` (
  `ID` int (11) NOT NULL AUTO_INCREMENT  COMMENT '主键',
  `CLUSTER_ID` int (11) NULL COMMENT '集群ID',
  `ENV_ID` int(11) NULL COMMENT '租户ID',
  `INGRESS_TYPE` tinyint (4) COMMENT '负载类型 1是7层负载 0是4层负载',
  `NAMESPACE` varchar(50) NULL COMMENT '负载应用名称',
  `PROJECT_ID` int(11) NULL COMMENT '项目ID',
  `NAME` varchar(50) NULL COMMENT '负载名称',
  `HOSTNAME` varchar (50) COMMENT '负载域名',
  `SSL_KEY` varchar (10000) COMMENT 'SSL密钥内容',
  `SSL_CRT` varchar (10000) COMMENT 'SSL证书内容',
  `SECRET_NAME` varchar (50) COMMENT '生成的SecretName',
  `SSL_ENABLE` tinyint (4) COMMENT '是否开启SSL 1开启 0关闭',
  `STRATEGY` varchar (20) COMMENT '会话保持内容 cookie, ip, round-robin',
  `STRATEGY_ENABLE` tinyint (4) COMMENT '是否开启会话保持 1开启 0关闭',
  `LOG_ENABLE` tinyint (4) COMMENT '是否开启日志输出 1开启 0关闭',
  `PORT` varchar (128) COMMENT '访问端口 用,隔开',
  `PATH` varchar (256) COMMENT '访问路径 用,隔开',
  `SERVICE` varchar (256) COMMENT '集群服务名 用,隔开',
  `SERVICE_IDS` varchar(100) NULL COMMENT '集群服务Id 用,隔开',
  `SERVICES_NAME` varchar (256) COMMENT '目标服务名 用,隔开',
  `SERVICES_PORT` varchar (128) COMMENT '目标端口 用,隔开',
  `CREATE_TIME` timestamp COMMENT '创建时间',
  `STATUS` tinyint(4) DEFAULT 1 NULL COMMENT '状态1可用 0删除',
  primary key (`ID`)
) ENGINE = InnoDB charset = utf8 collate = utf8_general_ci ;

DROP TABLE IF EXISTS `runtime_dashboard`;
CREATE TABLE `runtime_dashboard`  (
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '仪表盘类型',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `env_id` int(11) NULL DEFAULT NULL COMMENT '租户id',
  `cluster_id` int(11) NULL DEFAULT NULL COMMENT '集群id',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序',
  `type_state` tinyint(1) NULL DEFAULT NULL COMMENT '是否删除'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `runtime_dashboard_type`;
CREATE TABLE `runtime_dashboard_type`  (
  `dashboard_type_id` int(11) NOT NULL AUTO_INCREMENT  COMMENT '主键',
  `dashboard_type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '类型名称',
  `dashboard_type_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '请求url',
  `type` int(11) NULL DEFAULT NULL COMMENT '类型',
  PRIMARY KEY (`dashboard_type_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of runtime_dashboard_type
-- ----------------------------
INSERT INTO `runtime_dashboard_type` VALUES (1, 'CPU', 'v1.8/platformCluster/getCpu', 1);
INSERT INTO `runtime_dashboard_type` VALUES (2, 'CPU', 'cluster/clusterPartitionResource', 2);
INSERT INTO `runtime_dashboard_type` VALUES (3, 'MEM', 'v1.8/platformCluster/getMem', 1);
INSERT INTO `runtime_dashboard_type` VALUES (4, 'MEM', 'cluster/clusterPartitionResource', 2);
INSERT INTO `runtime_dashboard_type` VALUES (5, 'STORAGE', 'v1.8/platformCluster/getStorage', 1);
INSERT INTO `runtime_dashboard_type` VALUES (6, 'STORAGE', 'v1.8/platformCluster/getStorage', 2);
INSERT INTO `runtime_dashboard_type` VALUES (7, 'WARNINGS', 'v1.8/platformCluster/getWarnings', 1);
INSERT INTO `runtime_dashboard_type` VALUES (8, 'WARNINGS', 'v1.8/monitor/sumalerts', 2);
INSERT INTO `runtime_dashboard_type` VALUES (9, 'PARTITIONS', 'v1.8/platformCluster/getDashboardPartition', 1);
INSERT INTO `runtime_dashboard_type` VALUES (10, 'PARTITIONS', 'v1.8/platformCluster/getDashboardPartition', 2);
INSERT INTO `runtime_dashboard_type` VALUES (11, 'HOSTS', 'v1.8/platformCluster/getDashboardNodes', 1);
INSERT INTO `runtime_dashboard_type` VALUES (12, 'HOSTS', 'v1.8/platformCluster/getDashboardNodes', 2);
INSERT INTO `runtime_dashboard_type` VALUES (13, 'TENANTS', NULL, 1);
INSERT INTO `runtime_dashboard_type` VALUES (14, 'APPCPU', 'v1.8/queryProjectCpu.do', 2);
INSERT INTO `runtime_dashboard_type` VALUES (15, 'APPMEM', 'v1.8/queryProjectMemory.do', 2);
INSERT INTO `runtime_dashboard_type` VALUES (16, 'APPS', 'v1.8/queryProjectStatus.do', 2);
INSERT INTO `runtime_dashboard_type` VALUES (17, 'PODS', 'v1.8/queryPodStatus.do', 2);
INSERT INTO `runtime_dashboard_type` VALUES (18, 'SERVICES', 'v1.8/queryApplicationStatus.do', 2);
INSERT INTO `runtime_dashboard_type` VALUES (19, 'REGS', 'v1.8/registry/countByClusterIds', 1);
INSERT INTO `runtime_dashboard_type` VALUES (20, 'REGS', 'v1.8/registry/countByClusterIds', 2);
INSERT INTO `runtime_dashboard_type` VALUES (21, 'IMGS', 'v1.8/image/countImageByCondition', 1);
INSERT INTO `runtime_dashboard_type` VALUES (22, 'IMGS', 'v1.8/image/countImageByCondition', 2);

-- ----------------------------
-- Table structure for runtime_custom_panel
-- ----------------------------
DROP TABLE IF EXISTS `runtime_custom_panel`;
CREATE TABLE `runtime_custom_panel`  (
  `panel_id` int(11) NOT NULL AUTO_INCREMENT  COMMENT '主键',
  `panel_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自定义监控面板名称',
  `env_id` int(11) NULL DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`panel_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for runtime_custom_dashboard
-- ----------------------------
DROP TABLE IF EXISTS `runtime_custom_dashboard`;
CREATE TABLE `runtime_custom_dashboard`  (
  `id` int(11) NOT NULL AUTO_INCREMENT  COMMENT '主键',
  `panel_id` int(11) NULL DEFAULT NULL COMMENT '自定义监控面板id',
  `resource_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '资源类型',
  `query_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '查询类型',
  `operator_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作类型',
  `host_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '节点ip',
  `namespace` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '命名空间',
  `pod` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'pod',
  `container` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '容器',
  `target_object` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目标对象名称',
  `table_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图表类型',
  `unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '单位',
  `host_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用来显示每个小图表的名称',
  `diy_dashboard_mode_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `response_query` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '监控返回的查询表达式',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Compact;

-- 2019-05-13 创建制品库表 runtime_artifactory
DROP TABLE IF EXISTS `runtime_artifactory`;
CREATE TABLE `runtime_artifactory` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '制品库ID',
  `name` varchar(255) DEFAULT NULL COMMENT '制品库名',
  `url` varchar(255) DEFAULT NULL COMMENT '制品库url',
  `user_name` varchar(255) DEFAULT NULL COMMENT '用户名',
  `user_password` blob COMMENT '密码',
  `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
  `env_id` int(11) DEFAULT NULL COMMENT '租户ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '制品库创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;


-- 2019-05-13 zpx create runtime_script table
DROP TABLE IF EXISTS `runtime_script`;
CREATE TABLE `runtime_script` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '脚本id',
  `product_path` varchar(255) DEFAULT NULL COMMENT '制品路径',
  `script_path` varchar(255) DEFAULT NULL COMMENT 'worker中脚本路径',
  `script_name` varchar(255) DEFAULT NULL COMMENT '脚本名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述信息',
  `artifactory_id` int(11) DEFAULT NULL COMMENT '制品库id',
  `user_id` int(11) DEFAULT NULL COMMENT '用户id',
  `env_id` int(11) DEFAULT NULL COMMENT '租户id',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `status` int(11) DEFAULT '0' COMMENT '数据的状态，1表示删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8;
SET FOREIGN_KEY_CHECKS=1;

-- 2019-05-13 zpx  create runtime_label table
DROP TABLE IF EXISTS `runtime_label`;
CREATE TABLE `runtime_label` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标签id',
  `label_name` varchar(255) DEFAULT NULL COMMENT '标签名称',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8;
SET FOREIGN_KEY_CHECKS=1;

-- 2019-05-13 zpx create runtime_script_label table
DROP TABLE IF EXISTS `runtime_script_label`;
CREATE TABLE `runtime_script_label` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '脚本标签id',
  `script_id` int(11) DEFAULT NULL COMMENT '脚本id',
  `label_id` int(11) DEFAULT NULL COMMENT '标签id',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8;
SET FOREIGN_KEY_CHECKS=1;


