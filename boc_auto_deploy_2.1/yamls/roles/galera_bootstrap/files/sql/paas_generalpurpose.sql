CREATE database if NOT EXISTS `paas_generalpurpose` default character set utf8 collate utf8_general_ci;
use `paas_generalpurpose`;

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for consul_config
-- ----------------------------
DROP TABLE IF EXISTS `consul_config`;
CREATE TABLE `consul_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `config_name` varchar(100) NOT NULL COMMENT '配置文件名',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `version` int(11) DEFAULT NULL COMMENT '版本',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `config_content` longtext NOT NULL COMMENT '配置文件',
  `dc` varchar(50) NOT NULL COMMENT '数据中心',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for access_log
-- ----------------------------
DROP TABLE IF EXISTS `access_log`;
CREATE TABLE `access_log` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `action` varchar(60) DEFAULT '' COMMENT '操作',
  `cost` bigint(20) DEFAULT NULL COMMENT '耗时',
  `detail` varchar(500) DEFAULT NULL COMMENT '请求参数',
  `gmt_create` datetime DEFAULT NULL COMMENT '操作日期',
  `module` varchar(20) DEFAULT NULL COMMENT '模块名',
  `object` varchar(50) DEFAULT NULL,
  `request_url` varchar(100) DEFAULT NULL COMMENT '请求URL',
  `request_ip` varchar(500) DEFAULT NULL COMMENT '请求IP',
  `response_ip` varchar(500) DEFAULT NULL COMMENT '响应IP',
  `result` varchar(255) DEFAULT NULL,
  `interface_type` int(2) DEFAULT NULL COMMENT '接口类型 1新增类接口 2删除类接口 3修改类接口 4查询类接口',
  `is_risk` int(2) DEFAULT NULL COMMENT '是否高危操作 0不是 1是',
  `tenant_id` varchar(50) DEFAULT NULL COMMENT '租户ID',
  `tenant_name` varchar(100) DEFAULT NULL COMMENT '租户名称',
  `user_id` varchar(50) DEFAULT NULL COMMENT '用户ID',
  `user_name` varchar(50) DEFAULT NULL COMMENT '用户名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35612 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for access_log_report
-- ----------------------------
DROP TABLE IF EXISTS `access_log_report`;
CREATE TABLE `access_log_report` (
  `report_date` date DEFAULT NULL COMMENT '统计日期',
  `tenant_id` varchar(50) DEFAULT NULL COMMENT '租户ID',
  `user_id` varchar(50) DEFAULT NULL COMMENT '用户ID',
  `module` varchar(20) DEFAULT NULL COMMENT '模块',
  `access_count` int(11) unsigned zerofill DEFAULT NULL COMMENT '总次数',
  `risk_count` int(11) unsigned zerofill DEFAULT NULL COMMENT '高危操作总次数',
  `cost_count` int(11) unsigned zerofill DEFAULT NULL COMMENT '耗时长总次数'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='审计日志报表';

-- ----------------------------
-- Table structure for platform_allocation
-- ----------------------------
DROP TABLE IF EXISTS `platform_allocation`;
CREATE TABLE `platform_allocation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `platform_code` varchar(10) NOT NULL DEFAULT '' COMMENT '唯一CODE ',
  `allocation_type` int(2) NOT NULL COMMENT '类型 0 平台配置 1数据字典',
  `platform_name` varchar(20) NOT NULL COMMENT '名称',
  `platform_value` varchar(500) DEFAULT NULL COMMENT '值',
  `platform_explain` varchar(50) DEFAULT NULL COMMENT '中文说明',
  `is_available` int(2) NOT NULL DEFAULT '1' COMMENT '是否可用 0不可用 1可用',
  `order_by` int(2) NOT NULL COMMENT '排序',
  `parent_code` varchar(10) NOT NULL COMMENT '父code 0表示最初节点',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `update_by` varchar(20) DEFAULT NULL COMMENT '修改人',
  `create_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(20) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `paas_logger_alert_history`
-- ----------------------------
DROP TABLE IF EXISTS `paas_logger_alert_history`;
CREATE TABLE `paas_logger_alert_history` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `ENV_ID` int(11) DEFAULT NULL COMMENT '租户ID',
  `NAMESPPACE` varchar(255) DEFAULT NULL COMMENT '应用名',
  `APPLICATION_NAME` varchar(255) DEFAULT NULL COMMENT '服务名',
  `POD_NAME` varchar(255) DEFAULT NULL COMMENT '服务名',
  `MESSAGE` varchar(1000) DEFAULT NULL COMMENT '告警信息',
  `ALERT_TIME` timestamp NULL DEFAULT NULL COMMENT '告警时间',
  `CREATE_TIME` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `NUM_HITS` int(11) DEFAULT NULL COMMENT '出现次数',
  `NUM_MATCHES` int(11) DEFAULT NULL COMMENT '匹配次数',
  `SOURCE` varchar(1000) DEFAULT NULL COMMENT '日志路径',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `paas_logger_alert_rule`
-- ----------------------------
DROP TABLE IF EXISTS `paas_logger_alert_rule`;
CREATE TABLE `paas_logger_alert_rule` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志告警规则表',
  `ES_HOST` varchar(255) DEFAULT NULL COMMENT 'es地址',
  `ES_PORT` int(11) DEFAULT NULL COMMENT 'es端口',
  `USE_SSL` tinyint(4) DEFAULT NULL COMMENT '是否使用ssl连接',
  `ES_USERNAME` varchar(255) DEFAULT NULL COMMENT 'es账号',
  `ES_PASSWORD` varchar(255) DEFAULT NULL COMMENT 'es密码',
  `NAME` varchar(255) DEFAULT NULL COMMENT '规则名称',
  `TYPE` varchar(100) DEFAULT NULL COMMENT '规则类型',
  `INDEXS` varchar(255) DEFAULT NULL COMMENT '索引',
  `NUM_EVENTS` int(11) DEFAULT NULL COMMENT '触发的次数',
  `TIMEFRAME` varchar(255) DEFAULT NULL COMMENT '时间单位',
  `TIME` int(11) DEFAULT NULL COMMENT '时间',
  `FILTER` varchar(1000) DEFAULT NULL COMMENT '过滤条件',
  `ALERT` varchar(1000) DEFAULT NULL COMMENT '告警方式',
  `ALERT_TEXT` varchar(1000) DEFAULT NULL COMMENT '告警内容',
  `CLUSTER_ID` int(11) DEFAULT NULL COMMENT '集群ID',
  `ENV_ID` int(11) DEFAULT NULL COMMENT '租户ID',
  `USER_IDS` varchar(1000) DEFAULT NULL COMMENT '创建者ID组',
  `CREATE_TIME` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `NAMESPPACE_ID` int(11) DEFAULT NULL COMMENT '应用ID',
  `NAMESPPACE` varchar(255) DEFAULT NULL COMMENT '应用名',
  `APPLICATION_ID` int(11) DEFAULT NULL COMMENT '服务ID',
  `APPLICATION_NAME` varchar(255) DEFAULT NULL COMMENT '服务名',
  `POD_ID` int(11) DEFAULT NULL COMMENT 'PODID',
  `POD_NAME` varchar(255) DEFAULT NULL COMMENT 'pod名',
  `CALLBACK_URL` varchar(255) DEFAULT NULL COMMENT '回调地址',
  `ELASTALERT_URL` varchar(255) DEFAULT NULL COMMENT 'elastalert地址',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
