CREATE database if NOT EXISTS `nacha_report` default character set utf8 collate utf8_general_ci;

USE nacha_report;

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for report_cluster
-- ----------------------------
DROP TABLE IF EXISTS `report_cluster`;
CREATE TABLE `report_cluster` (
  `REPORT_CLUSTER_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '集群报表id',
  `RECORD_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '报表创建时间',
  `REPORT_STATUS` int(11) NOT NULL DEFAULT '0' COMMENT '报表状态 0统计报表 1虚拟报表 ',
  `REPORT_PAGE_ID` int(11) NOT NULL COMMENT '报表单 id',

  `CLUSTER_ID` int(11) NOT NULL COMMENT '集群id',
   `CLUSTER_NAME` varchar(80) NOT NULL COMMENT '集群名称',

  REPORT_CLUSTER_STATUS varchar(80) DEFAULT '' COMMENT '集群状态',
  `PARTITION_NUMS` int(11) NOT NULL COMMENT '分区数量',
  `MASTER_NUMS` int(11) NOT NULL COMMENT 'master节点数量',
  `NODE_NUMS` int(11) NOT NULL COMMENT '节点数量',
  `EX_NODES` int(11) NOT NULL COMMENT '异常节点数量',
  `CPU_TOTAL` int(11) NOT NULL COMMENT 'cpu总数',
  `MEM_TOTAL` int(11) NOT NULL COMMENT '内存总量',
  `PLATFORM_TYPE` varchar(255) DEFAULT 'kubernetes' COMMENT '平台类型',
  `VERSION` varchar(255) DEFAULT '' COMMENT '集群版本',
  `PROMETHEUS_ADDR` varchar(255) DEFAULT '' COMMENT  'prometheus addr',

  PRIMARY KEY (`REPORT_CLUSTER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for report_page
-- ----------------------------
DROP TABLE IF EXISTS `report_page`;
CREATE TABLE `report_page` (
  `PAGE_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '报表单id',
  `PAGE_NAME` varchar(100) NOT NULL COMMENT '报表单名称',
  `REPORT_KIND` int(11) NOT NULL COMMENT '报表类型 集群-分区-节点-租户-告警-审计',
  `REPORT_TYPE` int(11) NOT NULL COMMENT '报表类型 日报-月报-年报',
  `CREATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '报表单创建时间',
  `TIME_RANGE_LEFT` time NOT NULL COMMENT '报表单时间范围',
  `TIME_RANGE_RIGHT` time NOT NULL COMMENT '报表单时间范围',
  PRIMARY KEY (`PAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for report_rule
-- ----------------------------
DROP TABLE IF EXISTS `report_rule`;
CREATE TABLE `report_rule` (
  `RULE_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '报表单规则id',
  `REPORT_KIND` int(11) NOT NULL COMMENT '报表类型 集群-分区-节点-租户-告警-审计',
  `REPORT_NAME` varchar(50) NOT NULL COMMENT '报表名称',
  `REPORT_USE` TINYINT NOT NULL default 1 COMMENT '是否生效',
  `REPORT_DATE` time COMMENT '生成报表时间',
  `TIME_RANGE_LEFT` time NOT NULL COMMENT '报表单时间范围',
  `TIME_RANGE_RIGHT` time NOT NULL COMMENT '报表单时间范围',
  CONTENT_ID varchar(50) not null comment '定时任务id',
  `default_rule` TINYINT NOT NULL default 0 COMMENT '0否 1是 是否默认规则',
  PRIMARY KEY (`RULE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `report_rule` VALUES (1, 1, '集群报表规则', 1, '08:00:00', '08:00:00', '17:00:00', '1', 0);
INSERT INTO `report_rule` VALUES (2, 2, '分区报表规则', 1, '08:00:00', '08:00:00', '17:00:00', '2', 0);
INSERT INTO `report_rule` VALUES (3, 3, '节点报表规则', 1, '08:00:00', '08:00:00', '17:00:00', '3', 0);
INSERT INTO `report_rule` VALUES (4, 4, '租户报表规则', 1, '08:00:00', '08:00:00', '17:00:00', '4', 0);
INSERT INTO `report_rule` VALUES (5, 5, '告警历史报表规则', 1, '08:00:00', '08:00:00', '17:00:00', '5', 0);
INSERT INTO `report_rule` VALUES (6, 6, '操作审计报表规则', 1, '08:00:00', '08:00:00', '17:00:00', '6', 0);
INSERT INTO `report_rule` VALUES (7, 7, '应用报表规则', 1, '08:00:00', '08:00:00', '17:00:00', '7', 0);

-- ----------------------------
-- Table structure for report_host
-- ----------------------------
DROP TABLE IF EXISTS `report_host`;
CREATE TABLE `report_host` (
  `REPORT_HOST_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '主机报表id',
  `RECORD_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '报表创建时间',
  `REPORT_STATUS` int(11) NOT NULL DEFAULT '0' COMMENT '报表状态 0统计报表 1虚拟报表 ',
  `REPORT_PAGE_ID` int(11) NOT NULL COMMENT '报表单 id',
  `CLUSTER_NAME` varchar(80) NOT NULL default '' COMMENT '集群名称',

  `HOST_ID` int(11) COMMENT '主机报表id',
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
  `HOST_STATUS` tinyint(4) NOT NULL DEFAULT '1' COMMENT '主机状态(0,删除，1正常，2.关机，3，异常，4，维护)',
  `HOST_DESC` varchar(200) DEFAULT NULL COMMENT '描述信息',
  `HOST_KERNEL_VERSION` varchar(80) DEFAULT NULL COMMENT 'kernel版本信息',
  `DOCKER_VERSION` varchar(100) DEFAULT NULL COMMENT 'docker的版本',
  `HOST_CREATETIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `CLUSTER_ID` int(11) DEFAULT NULL COMMENT '所属集群',
  `KUBE_VERSION` varchar(100) DEFAULT NULL COMMENT 'kubernetes版本',
  `KUBE_TYPE` varchar(10) DEFAULT NULL COMMENT '集群类型（https支持dns）',
  `REGISTRY_VERSION` varchar(100) DEFAULT NULL COMMENT '私有仓库版本',
  `HOST_OS` varchar(255) DEFAULT NULL COMMENT '系统信息',
  `HOST_BOOT` timestamp NULL DEFAULT NULL COMMENT '启动时间',
  `REGISTRY_ID` int(11) DEFAULT NULL COMMENT '仓库',
  `NETWORK` varchar(4000) DEFAULT NULL COMMENT '网络',
  `NGINX_VERSION` varchar(100) DEFAULT NULL COMMENT 'nginx服务版本',
  `HOST_MONITOR_STATUS` tinyint(4) DEFAULT NULL COMMENT '主机监控状态 0异常 1正常',
  `ENV_ID` int(11) DEFAULT NULL COMMENT '所属租户',
  `ENV_NAME` varchar(255) COMMENT '租户名称',
  `PLATFORM_TYPE` varchar(255) DEFAULT 'kubernetes' COMMENT '平台类型',
  `SCHEDULING_STATUS` tinyint (4) DEFAULT 1 NOT NULL COMMENT '调度状态 0不可调度 1可调度',
  PARTITION_ID INTEGER(11) default null COMMENT '主机所属分区',
  `PARTITION_NAME` varchar(80) DEFAULT NULL COMMENT '分区名称',
  INSTALL_STATUS INTEGER(4) DEFAULT NULL COMMENT '主机安装状态(5安装中,6删除中,7安装成功,8安装失败,9删除成功，10删除失败)',

  `AVG_CPU` varchar(50) COMMENT '平均CPU',
  `AVG_MEM` varchar(50) COMMENT '平均内存',
  `MAX_CPU` varchar(50) COMMENT '最大CPU',
  `MAX_MEM` varchar(50) COMMENT '最大内存',
  `MIN_CPU` varchar(50) COMMENT '最小CPU',
  `MIN_MEM` varchar(50) COMMENT '最小内存',

  `MAX_INS` double(9,2) unsigned NOT NULL DEFAULT '0' COMMENT '最大实例利用率',
  `MIN_INS` double(9,2) unsigned NOT NULL DEFAULT '0' COMMENT '最小实例利用率',
  `AVG_INS` double(9,2) unsigned NOT NULL DEFAULT '0' COMMENT '平均实例利用率',

  `AVG_IN_NET` varchar(50) COMMENT '平均in流量',
  `MIN_IN_NET` varchar(50) COMMENT '最小in流量',
  `MAX_IN_NET` varchar(50) COMMENT '最大in流量',

  `AVG_OUT_NET` varchar(50) COMMENT '平均out流量',
  `MIN_OUT_NET` varchar(50) COMMENT '最小out流量',
  `MAX_OUT_NET` varchar(50) COMMENT '最大out流量',

  `INSTANCE_NUMS` int(11) NOT NULL DEFAULT 0 COMMENT '实例数量',
  `CONTAINER_NUMS` int(11) NOT NULL DEFAULT 0 COMMENT '容器数量',
  `WARNING_NUMS` int(11) NOT NULL DEFAULT 0 COMMENT '告警数量',

  `DEAD_SEVERITY` int(11) DEFAULT 0 COMMENT '致命告警数量',
  `SERIOUS_SEVERITY` int(11) DEFAULT 0 COMMENT '严重告警数量',
  `WARN_SEVERITY` int(11) DEFAULT 0 COMMENT '警告告警数量',
  `UNKNOWN_NUMS` int(11) DEFAULT 0 COMMENT '未知告警数量',
  `USER_ID` int(11) COMMENT '用户id',
  `PROMETHEUS_ADDR` varchar(50) comment 'prometheusAddr',
  PRIMARY KEY (`REPORT_HOST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `report_partition`;
CREATE TABLE `report_partition` (
  `REPORT_PARTITION_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '主机报表id',
  `RECORD_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '报表创建时间',
  `REPORT_STATUS` int(11) NOT NULL DEFAULT '0' COMMENT '报表状态 0统计报表 1虚拟报表 ',
  `REPORT_PAGE_ID` int(11) NOT NULL COMMENT '报表单 id',
  `PARTITION_ID` int(11),
  `PARTITION_NAME` varchar(255) DEFAULT NULL COMMENT '分区名称',
  `PARTITION_CLUSTER_ID` int(11) DEFAULT NULL COMMENT '所属集群',
  `PARTITION_HOST_NUM` int(11) DEFAULT NULL COMMENT '包含主机数',
  `PARTITION_STATE` int(3) DEFAULT 0 COMMENT '分区状态：0 可用 1 不可用',
  `PARTITION_SHARE` int(3) DEFAULT 0 COMMENT '是否可共享：0 不可共享 1 可共享',
  `PARTITION_CLUSTER_NAME` varchar(255) DEFAULT NULL COMMENT '所属集群名称',
  `PARTITION_ENV_NAME` varchar(255) DEFAULT NULL COMMENT '所属租户名称',
  `PARTITION_DESCRIBE` text DEFAULT NULL,
  `PARTITION_REAL_NAME` varchar(255) DEFAULT NULL,
  `PARTITION_KIND` int(11) DEFAULT 0 COMMENT '分区类型：0普通分区 1默认分区',
  `DEFAULT_PARTITION_ID` int(11) COMMENT '默认分区id',
  `HOST_NUMS` int(11) not null default 0 comment '正常节点数',
  `EX_HOST_NUMS` int(11) not null default 0 comment '异常节点数量',
  `PARTITION_STATUS` varchar(255) DEFAULT NULL COMMENT '分区状态 正常 异常',
  `PROMETHEUS_ADDR` varchar(255) DEFAULT NULL COMMENT '监控地址',
  PRIMARY KEY (`REPORT_PARTITION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `report_env_agg`;
CREATE TABLE `report_env_agg` (
  `ENV_AGG_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '租户汇总表',
  `RECORD_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '报表创建时间',
  `REPORT_STATUS` int(11) NOT NULL DEFAULT '0' COMMENT '报表状态 0统计报表 1虚拟报表 ',
  `REPORT_PAGE_ID` int(11) NOT NULL COMMENT '报表单 id',

  `ENV_ID` int(11) COMMENT '租户id',
  `ENV_NAME` varchar(255) COMMENT '租户名称',
  `CLUSTER_ID` int(11) comment '集群id',
  `CLUSTER_NAME` varchar(255) COMMENT '集群名称',

  `PARTITION_IDS` varchar(255) COMMENT '分区id',
  `PARTITION_NAME` varchar(255) COMMENT '分区名称',

  `RESOURCE_CPU` int(11) comment '资源限额cpu',
  `RESOURCE_MEM` int(11) comment '资源限额mem',
  `RESOURCE_INSTANCE` int(11) comment '资源限额instance',
  `RESOURCE_HD` int(11) comment '资源限额hd',

  `ENV_STATUS` varchar(255) COMMENT '租户状态',
  `ENV_MANAGER` varchar(255) COMMENT '租户管理员',

  `INSTANCE_NUMS` int(11) comment '实例数量',
  `SERVICE_NUMS` int(11) comment '服务数量',
  `NAMESPACE_NUMS` int(11) comment 'namespace数量',
  `CONTAINER_NUMS` int(11) comment '容器数量',
  env_Create_Time timestamp comment '租户创建时间',
  PRIMARY KEY (`ENV_AGG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `report_action_audit`;
CREATE TABLE `report_action_audit`(
  `AUDIT_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '租户汇总表',
  `RECORD_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '报表创建时间',
  `REPORT_STATUS` int(11) NOT NULL DEFAULT '0' COMMENT '报表状态 0统计报表 1虚拟报表 ',
  `REPORT_PAGE_ID` int(11) NOT NULL COMMENT '报表单 id',

  `TENANT_NAME` varchar(255) COMMENT '租户名称',
  `USERNAME` varchar(255) COMMENT '用户名称',
  `MODULE` varchar(255) COMMENT '模块名称',
  `REQUEST_IP` varchar(255) COMMENT '请求ip',
  `RESPONSE_IP` varchar(255) COMMENT '响应ip',
  `OBJECT` varchar(255) COMMENT '对象',
  `ACTION` varchar(255) COMMENT '操作',
  `COST` varchar(255) COMMENT '用户名称',
  `GMT_CREATE` timestamp comment '请求时间',

  `RISK_ACTION` int(11) DEFAULT 0 COMMENT '是否高危操作 0不是 1是',
  PRIMARY KEY (`AUDIT_ID`)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `report_action_audit_egg`;
CREATE TABLE `report_action_audit_egg`(
  `AUDIT_AGG_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '操作审计汇总表',
  `RECORD_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '报表创建时间',
  `REPORT_STATUS` int(11) NOT NULL DEFAULT '0' COMMENT '报表状态 0统计报表 1虚拟报表 ',
  `REPORT_PAGE_ID` int(11) NOT NULL COMMENT '报表单 id',

  `USER_COUNT` int(11) COMMENT '操作用户数',
  `ACCESS_COUNT` INT(11) COMMENT '综合操作数',
  `SELECT_COUNT` INT(11) COMMENT '查询操作数',
  `CHANGE_COUNT` int(11) COMMENT '变更操作数',
  `RISK_COUNT` int(11) COMMENT '高危操作数',
  PRIMARY KEY (`audit_agg_id`)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `report_action_audit_user`;
CREATE TABLE `report_action_audit_user`(
  `AUDIT_USER_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'user操作审计表',
  `RECORD_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '报表创建时间',
  `REPORT_STATUS` int(11) NOT NULL DEFAULT '0' COMMENT '报表状态 0统计报表 1虚拟报表 ',
  `REPORT_PAGE_ID` int(11) NOT NULL COMMENT '报表单 id',

  `USER_ID` varchar(255) COMMENT '租户名称',
  `USER_NAME` varchar(255) COMMENT '用户名称',
  `ACCESS_COUNT` INT(11) COMMENT '综合操作数',
  `SELECT_COUNT` INT(11) COMMENT '查询操作数',
  `CHANGE_COUNT` int(11) COMMENT '变更操作数',
  `RISK_COUNT` int(11) COMMENT '高危操作数',

  PRIMARY KEY (`AUDIT_USER_ID`)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `report_action_audit_obj`;
CREATE TABLE `report_action_audit_obj`(
  `audit_obj_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'object操作审计表',
  `RECORD_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '报表创建时间',
  `REPORT_STATUS` int(11) NOT NULL DEFAULT '0' COMMENT '报表状态 0统计报表 1虚拟报表 ',
  `REPORT_PAGE_ID` int(11) NOT NULL COMMENT '报表单 id',

  `t_object` varchar(255) COMMENT '租户名称',
  `t_action` varchar(255) COMMENT '用户名称',
  `INTERFACETYPE` INT(11) COMMENT '综合操作数',
  `INTERFACE_TYPE` INT(11) COMMENT '接口类型 1新增类接口 2删除类接口 3修改类接口 4查询类接口',
  `ACCESS_COUNT` int(11) COMMENT '变更操作数',
  `IS_RISK` varchar(255) COMMENT '是否高危 0不是 1是',

  PRIMARY KEY (`audit_obj_id`)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `report_bill_account`;
CREATE TABLE `report_bill_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(11) DEFAULT NULL COMMENT '用户编号',
  `user_name` varchar(100) DEFAULT NULL COMMENT '用户名称',
  `env_id` int(11) DEFAULT NULL COMMENT '环境编号',
  `env_name` varchar(200) DEFAULT NULL COMMENT '环境名称',
  `account_total` decimal(10,2) DEFAULT '0.00' COMMENT '费用合计',
  `account_day` int(10) DEFAULT NULL COMMENT '使用总天数',
  `account_begin` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
  `account_end` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '结束时间',
  `account_state` int(4) DEFAULT '1' COMMENT '账单当前使用状态：0=未使用 1=正在使用',
  `payment_state` int(4) DEFAULT '0' COMMENT '是否付款：0=未付款、1=已付款',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of report_bill_account
-- ----------------------------

-- ----------------------------
-- Table structure for report_bill_pool
-- ----------------------------
DROP TABLE IF EXISTS `report_bill_pool`;
CREATE TABLE `report_bill_pool` (
  `id` varchar(36) NOT NULL COMMENT '套餐单价',
  `user_id` int(11) NOT NULL COMMENT '用户编号',
  `env_id` int(11) NOT NULL COMMENT '环境编号',
  `cpu_num` int(8) DEFAULT '0' COMMENT 'cpu的核数',
  `mem_num` int(8) DEFAULT '0' COMMENT '内存g',
  `hd_num` int(10) DEFAULT '0' COMMENT '硬盘卷g',
  `instance_num` int(8) DEFAULT '0' COMMENT '实例的个数',
  `cpu_sum` double(10,4) DEFAULT '0.0000' COMMENT 'cpu 总量（天数*单位）',
  `mem_sum` double(10,4) DEFAULT '0.0000' COMMENT '内存 总量（天数*单位）',
  `instance_sum` double(10,4) DEFAULT '0.0000' COMMENT '实例 总量（天数*单位）',
  `hd_sum` double(16,4) DEFAULT '0.0000' COMMENT '硬盘 总量（天数*单位）',
  `net_num` int(8) DEFAULT '0' COMMENT '网络带宽m',
  `io_num` int(8) DEFAULT '0' COMMENT '网络流量g',
  `time_type` tinyint(4) DEFAULT '1' COMMENT '时间类型0时,1日,2月,3年',
  `record_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
  `pool_univalent` decimal(12,4) DEFAULT '0.0000' COMMENT '套餐单价',
  `pool_new_univalent` decimal(12,4) DEFAULT '0.0000' COMMENT '新套餐单价',
  `pool_total` decimal(12,4) DEFAULT '0.0000' COMMENT '合计（资源池已使用价格和+当前计算的价格）',
  `bill_state` tinyint(4) DEFAULT '1' COMMENT '账单状态，0：无效 1有效 2撤销记录 ',
  `cpu_price` decimal(12,4) DEFAULT '0.0000' COMMENT 'cpu单价',
  `mem_price` decimal(12,4) DEFAULT '0.0000' COMMENT '内存单价',
  `instance_price` decimal(12,4) DEFAULT '0.0000' COMMENT '实例单价',
  `hd_price` decimal(12,4) DEFAULT '0.0000' COMMENT '硬盘单价',
  `cpu_ac_ex` decimal(12,4) DEFAULT '0.0000' COMMENT 'cpu 总量累计费用（天数*单位）',
  `mem_ac_ex` decimal(12,4) DEFAULT '0.0000' COMMENT '内存 总量累计费用（天数*单位）',
  `instance_ac_ex` decimal(12,4) DEFAULT '0.0000' COMMENT '实例 总量累计费用（天数*单位）',
  `hd_ac_ex` decimal(12,4) DEFAULT '0.0000' COMMENT '硬盘 总量累计费用（天数*单位）',
  `account_id` int(11) NOT NULL COMMENT '账单编号',
  `cpu_interval` decimal(12,4) DEFAULT '0.0000' COMMENT 'cpu日间隔价格',
  `mem_interval` decimal(12,4) DEFAULT '0.0000' COMMENT '内存日间隔价格',
  `instance_interval` decimal(12,4) DEFAULT '0.0000' COMMENT '实例日间隔价格',
  `hd_interval` decimal(12,4) DEFAULT '0.0000' COMMENT '硬盘日间隔价格',
  `pool_interval` decimal(12,4) DEFAULT '0.0000' COMMENT '该笔账单日间隔价格',
  `time_interval` double(8,2) DEFAULT '0.00' COMMENT '计费步长间隔',
  PRIMARY KEY (`id`),
  KEY `index_record_time` (`record_time`),
  KEY `index_time_type` (`time_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of report_bill_pool
-- ----------------------------

-- ----------------------------
-- Table structure for report_combo
-- ----------------------------
DROP TABLE IF EXISTS `report_combo`;
CREATE TABLE `report_combo` (
  `id` int(12) NOT NULL AUTO_INCREMENT COMMENT '套餐编号',
  `combo_name` varchar(50) NOT NULL COMMENT '套餐名称',
  `cpu_num` int(8) DEFAULT '0' COMMENT 'cpu的核数',
  `mem_num` int(8) DEFAULT '0' COMMENT '内存g',
  `instance_num` int(8) DEFAULT '0' COMMENT '实例的个数',
  `hd_num` int(8) DEFAULT '0' COMMENT '申请硬盘卷g',
  `net_num` int(8) DEFAULT '0' COMMENT '申请网络带宽m',
  `io_num` int(8) DEFAULT '0' COMMENT '申请网络流量g',
  `time_type` tinyint(4) DEFAULT '1' COMMENT '套餐的时间类型0：时,1：日,2：月,3：年',
  `combo_price` decimal(12,4) DEFAULT '0.0000' COMMENT '套餐费用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for report_price
-- ----------------------------
DROP TABLE IF EXISTS `report_price`;
CREATE TABLE `report_price` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `product_mark` varchar(20) NOT NULL COMMENT '产品标识',
  `product_name` varchar(50) NOT NULL COMMENT '产品名称',
  `time_type` tinyint(4) DEFAULT '0' COMMENT '时间类型0时,1日,2月,3年',
  `product_univalent` decimal(10,4) NOT NULL COMMENT '产品单价',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of report_price
-- ----------------------------
INSERT INTO `report_price` VALUES ('1', 'CPU', 'CPU', '0', '0.1000');
INSERT INTO `report_price` VALUES ('2', 'MEM', '内存', '0', '1.0000');
INSERT INTO `report_price` VALUES ('3', 'HD', '硬盘', '0', '0.0100');
INSERT INTO `report_price` VALUES ('4', 'NET', 'net', '0', '2.0000');
INSERT INTO `report_price` VALUES ('5', 'INSTANCE', 'instance', '0', '0.1000');

-- ----------------------------
-- Table structure for report_alert_history
-- ----------------------------
DROP TABLE IF EXISTS `report_alert_history`;
CREATE TABLE `report_alert_history` (
  `report_alert_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `RECORD_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '报表创建时间',
  `REPORT_STATUS` int(11) NOT NULL DEFAULT '0' COMMENT '报表状态 0统计报表 1虚拟报表 ',
  `REPORT_PAGE_ID` int(11) NOT NULL COMMENT '报表单 id',
  `HOST_NAME` varchar(80) DEFAULT NULL COMMENT '主机名称',
  `HOST_IP` varchar(30) DEFAULT NULL COMMENT '主机ip',
  `HOST_TYPE` tinyint(4) DEFAULT NULL COMMENT '主机类型(0,master,1,node,2,registry,3,lb,4,只作为监控对象)',
  `HOST_STATUS` tinyint(4) DEFAULT NULL COMMENT '主机状态(0,删除，1正常，2.关机，3，异常，4，维护,5,安装中,6移除中,7安装成功,8安装失败)',
  `ALERT_TARGET` varchar(30) COMMENT '告警类型 主机 0 /容器 1',
  `ALERT_OBJECT` varchar(100) COMMENT '告警目标',
  `ALERT_TIME` varchar(100) COMMENT '告警时间',
  `ALERT_DURATION` varchar(100) COMMENT '告警触发持续时间',
  `ALERT_UNIT` varchar(100) COMMENT '告警触发持续时间单位',
  `ALERT_RULE_NAME` varchar(255) COMMENT '告警规则名称',
  `ALERT_NOTICE_WAY` varchar(255) COMMENT '告警通知方式',
  `ALERT_SEVERITY` varchar(255) COMMENT '告警级别 warning警告 critical严重 error致命',
  `ALERT_NOTICE_RECEIVER` varchar(255) COMMENT '告警通知对象组',
  `ALERT_STATE` varchar(255) COMMENT '可用状态 1可用 0禁用',
  `ALERT_METRIC` varchar(255) COMMENT '监控指标 cpu mem disk',
  `ALERT_OPERATOR` varchar(255) COMMENT '操作符 < = >',
  `ALERT_VALUE` varchar(255) COMMENT '阈值 0-100的整数',
  `CLUSTER_ID` int(11) COMMENT '集群id',
  `ALERT_HISTORY_ID` int(11) COMMENT '告警历史id',
  `HOST_ID` int(11) COMMENT '主机id',
  `HOST_MONITOR_STATUS` tinyint(4) DEFAULT NULL COMMENT '主机监控状态 0异常 1正常',
  `ALERT_MESSAGE` varchar(255) COMMENT '告警内容',
  `SCHEDULING_STATUS` tinyint (4) DEFAULT 1 NOT NULL COMMENT '调度状态 0不可调度 1可调度',
  PRIMARY KEY (`report_alert_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for report_project_core
-- ----------------------------
DROP TABLE IF EXISTS `report_project_core`;
CREATE TABLE `report_project_core` (
  `report_project_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `RECORD_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '报表创建时间',
  `REPORT_STATUS` int(11) NOT NULL DEFAULT '0' COMMENT '报表状态 0统计报表 1虚拟报表 ',
  `REPORT_PAGE_ID` int(11) NOT NULL COMMENT '报表单 id',

  `PROJECT_NAME` varchar(80) DEFAULT NULL COMMENT '应用名称',
  `PROJECT_STATE` varchar(80) DEFAULT NULL COMMENT '应用状态',
  `PROJECT_RES` varchar(80) DEFAULT NULL COMMENT '资源配额',
  `CLUSTER_NAME` varchar(80) DEFAULT NULL COMMENT '集群名称',
  `ENV_NAME` varchar(80) DEFAULT NULL COMMENT '租户名称',
  `PARTITION_NAME` varchar(80) DEFAULT NULL COMMENT '分区名称',
  `CLUSTER_ID` int(11) DEFAULT NULL COMMENT '集群id',
  `ENV_ID` int(11) DEFAULT NULL COMMENT '租户id',
  `PARTITION_ID` int(11) DEFAULT NULL COMMENT '分区id',
  `SERVICE_NUMS` int(11) DEFAULT NULL COMMENT '服务数量',
  `INSTANCE_NUMS` int(11) DEFAULT NULL COMMENT '实例数量',
  `CREATE_TIME` timestamp COMMENT '创建时间',

  PRIMARY KEY (`report_project_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for report_application_info
-- ----------------------------
DROP TABLE IF EXISTS `report_application_info`;
CREATE TABLE `report_application_info` (
  `REPORT_APPLICATION_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `RECORD_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '报表创建时间',
  `REPORT_STATUS` INT(11) NOT NULL DEFAULT '0' COMMENT '报表状态 0统计报表 1虚拟报表 ',
  `REPORT_PAGE_ID` INT(11) NOT NULL COMMENT '报表单 ID',
  `PROJECT_ID` INT(11) DEFAULT NULL COMMENT '应用ID',
  `PROJECT_DESCRIPTION` VARCHAR(80) DEFAULT NULL ,
  `PROJECT_DESCRIBE` VARCHAR(80) DEFAULT NULL ,
  `PROJECT_RUNTIME_ID` INT(11) DEFAULT NULL COMMENT '所属租户ID',
  `PROJECT_COMMENTS`  VARCHAR(80) DEFAULT NULL ,
  `PROJECT_CREATE_DATETIME` TIMESTAMP ,
  `PROJECT_DELETE_DATETIME` TIMESTAMP ,
  `PROJECT_CURRENT_STATUS` VARCHAR(80) DEFAULT NULL ,
  `PROJECT_NAME` VARCHAR(80) DEFAULT NULL COMMENT '应用名称',
  `CLUSTER_ID`  INT(11) DEFAULT 0 COMMENT '集群ID',
  `APPLICATION_NORMAL_COUNT`  INT(11) DEFAULT 0 COMMENT '服务正常数量',
  `APPLICATION_AB_NORMAL_COUNT`  INT(11) DEFAULT 0 COMMENT '服务异常数量',
  `POD_NORMAL_COUNT`  INT(11) DEFAULT 0 COMMENT '实例正常数量',
  `POD_AB_NORMAL_COUNT`  INT(11) DEFAULT 0 COMMENT '实例异常数量',
  `T_STATUS` INT(11) NOT NULL DEFAULT 0 COMMENT '状态（-1 未部署， 0 异常，1 正常）',
  `APPLICATION_COUNT` INT(11) DEFAULT 0 COMMENT '服务数量',
  `POD_COUNT` INT(11) DEFAULT 0 COMMENT '实例数量',

  `AVG_CPU` varchar(50) COMMENT '平均CPU',
  `AVG_MEM` varchar(50) COMMENT '平均内存',
  `MAX_CPU` varchar(50) COMMENT '最大CPU',
  `MAX_MEM` varchar(50) COMMENT '最大内存',
  `MIN_CPU` varchar(50) COMMENT '最小CPU',
  `MIN_MEM` varchar(50) COMMENT '最小内存',

  `AVG_IN_NET` varchar(50) COMMENT '平均in流量',
  `MIN_IN_NET` varchar(50) COMMENT '最小in流量',
  `MAX_IN_NET` varchar(50) COMMENT '最大in流量',

  `AVG_OUT_NET` varchar(50) COMMENT '平均out流量',
  `MIN_OUT_NET` varchar(50) COMMENT '最小out流量',
  `MAX_OUT_NET` varchar(50) COMMENT '最大out流量',

  `resource_cpu` int(11) default 0 comment '资源限额cpu',
  `resource_memory` int(11) default 0 comment '资源限额memory',
  `resource_gpu` int(11) default 0 comment '资源限额gpu',
  `resource_instance` int(11) default 0 comment '资源限额instance',

  `CLUSTER_NAME` varchar(250) COMMENT '集群名称',
  `ENV_NAME` varchar(250) COMMENT '租户名称',
  PRIMARY KEY (`REPORT_APPLICATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `report_env_page`;
create table report_env_page(
  `RECORD_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `ENV_ID` int(11) DEFAULT NULL COMMENT '租户id',
  `REPORT_PAGE_ID` int(11) DEFAULT NULL COMMENT '报表id',
  PRIMARY KEY (`RECORD_ID`)
)ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;