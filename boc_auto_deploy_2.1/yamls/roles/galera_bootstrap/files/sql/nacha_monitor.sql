CREATE database if NOT EXISTS `nacha_monitor` default character set utf8 collate utf8_general_ci;

USE nacha_monitor;

SET FOREIGN_KEY_CHECKS=0;

/** 创建告警表 **/
DROP TABLE IF EXISTS `monitor_alert_rule`;
CREATE TABLE `monitor_alert_rule`(
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '告警ID',
  `ALERT` varchar(50) COMMENT '告警名称',
  `MONITOR_TYPE` tinyint(4) COMMENT '监控类型 0主机 1容器',
  `METRIC` varchar(50) COMMENT '监控指标 CPU MEM DISK NETWORK',
  `SEVERITY` varchar(20) COMMENT '告警级别  warning警告 critical严重 error致命',
  `OPERATOR` varchar(10) COMMENT '操作符 < = >',
  `VALUE` varchar(10) COMMENT '阈值',
  `DURATION` varchar(10) COMMENT '持续时间',
  `FOR_TIME` varchar(10) NULL COMMENT '抑制时间',
  `FOR_UNIT` varchar(10) NULL COMMENT '抑制时间单位 m分钟 h小时 d天',
  `UNIT` varchar(10) COMMENT '时间单位 m分钟 h小时 d天',
  `EXPR` varchar(200) COMMENT '最终生成的监控表达式',
  `DESCRIPTION` varchar(200) COMMENT '描述',
  `STATUS` tinyint(4) DEFAULT 1 COMMENT '状态 1正常 0删除',
  `STATE` tinyint(4) DEFAULT 1 COMMENT '可用状态 1可用 0禁用',
  `NOTICE_WAY` tinyint(4) DEFAULT 1 COMMENT '通知方式 1邮件',
  `GROUP_ID` int(11) COMMENT '告警联系人组ID',
  `CLUSTER_ID` int(11) COMMENT '集群Id',
  `USER_ID` int(11) COMMENT '创建者Id',
  `CREATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  primary key (`ID`)
) ENGINE=InnoDB charset=utf8 collate=utf8_general_ci;

/** 创建联系人表 **/
DROP TABLE IF EXISTS `monitor_alert_contact`;
CREATE TABLE `monitor_alert_contact`(
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `NAME` varchar(32) COMMENT '联系人名称',
  `PHONE` varchar(20) COMMENT '联系人电话',
  `EMAIL` varchar(50) COMMENT '联系人邮件地址',
  `GROUP_ID` int(11) COMMENT '联系人组ID',
  `STATUS` tinyint(4) DEFAULT 1 COMMENT '状态 1可用 0删除',
  `CREATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP COMMENT '创建/更新时间',
  primary key (`ID`)
) ENGINE=InnoDB charset=utf8 collate=utf8_general_ci;

/** 创建联系组表 **/
DROP TABLE IF EXISTS `monitor_alert_contact_group`;
CREATE TABLE `monitor_alert_contact_group`(
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `NAME` varchar(32) COMMENT '联系组名称',
  `CONTACT_ID` varchar(50) COMMENT '联系人ID，多人用,隔开',
  `STATUS` tinyint(4) DEFAULT 1 COMMENT '状态 1可用 0删除',
  `CREATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP COMMENT '创建/更新时间',
  primary key (`ID`)
) ENGINE=InnoDB charset=utf8 collate=utf8_general_ci;

/** 创建告警历史表 **/
DROP TABLE IF EXISTS `monitor_alert_history`;
CREATE TABLE `monitor_alert_history`(
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `CLUSTER_ID` int(11) COMMENT '集群ID',
  `ALERT_ID` int(11) COMMENT '告警ID',
  `ALERT_OBJECT` varchar(128) COMMENT '告警目标',
  `STATUS` tinyint(4) DEFAULT 1 COMMENT '状态 1可用 0删除',
  `ALERT_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP() COMMENT '告警时间',
  `VALUE` varchar(10) NULL COMMENT '告警值',
  primary key (`ID`)
) ENGINE=InnoDB charset=utf8 collate=utf8_general_ci;

/** 创建ES告警历史表 **/
DROP TABLE IF EXISTS `monitor_elast_alert_history`;
CREATE TABLE `monitor_elast_alert_history` (
  `ID` bigint(20) NOT NULL COMMENT '主键ID',
  `RULE_ID` bigint(20) DEFAULT NULL COMMENT '规则ID',
  `STATUS` tinyint(4) DEFAULT NULL COMMENT '状态',
  `ALERT_TIME` timestamp NULL DEFAULT NULL COMMENT '告警时间',
  `CREATE_TIME` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `ALERT_OBJECT` varchar(255) DEFAULT NULL COMMENT '告警内容',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/** 创建ES告警规则 **/
DROP TABLE IF EXISTS `monitor_elast_alert_rule`;
CREATE TABLE `monitor_elast_alert_rule` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志告警规则表',
  `ES_HOST` varchar(255) DEFAULT NULL COMMENT 'es地址',
  `ES_PORT` int(11) DEFAULT NULL COMMENT 'es端口',
  `USE_SSL` tinyint(4) DEFAULT NULL COMMENT '是否使用ssl连接',
  `ES_USERNAME` varchar(255) DEFAULT NULL COMMENT 'es账号',
  `ES_PASSWORD` varchar(255) DEFAULT NULL COMMENT 'es密码',
  `NAME` varchar(255) DEFAULT NULL COMMENT '规则名称',
  `TYPE` varchar(100) DEFAULT NULL COMMENT '规则类型',
  `INDEX` varchar(255) DEFAULT NULL COMMENT '索引',
  `NUM_EVENTS` int(11) DEFAULT NULL COMMENT '触发的次数',
  `TIMEFRAME` varchar(255) DEFAULT NULL COMMENT '时间单位',
  `TIME` int(11) DEFAULT NULL COMMENT '时间',
  `FILTER` varchar(1000) DEFAULT NULL COMMENT '过滤条件',
  `ALERT` varchar(1000) DEFAULT NULL COMMENT '告警方式',
  `ALERT_TEXT` varchar(1000) DEFAULT NULL COMMENT '告警内容',
  `CLUSTER_ID` int(11) DEFAULT NULL COMMENT '集群ID',
  `ENV_ID` int(11) DEFAULT NULL COMMENT '租户ID',
  `GROUP_ID` int(11) DEFAULT NULL COMMENT '告警联系人组ID',
  `USER_ID` int(11) DEFAULT NULL COMMENT '创建者ID',
  `CREATE_TIME` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;