CREATE database if NOT EXISTS `nacha_appstore` default character set utf8 collate utf8_general_ci;
USE nacha_appstore;

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
--  Table structure for `as_chart_version`
-- ----------------------------
DROP TABLE IF EXISTS `as_chart_version`;
CREATE TABLE `as_chart_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` varchar(128) NOT NULL COMMENT '版本',
  `application_version` varchar(128) DEFAULT NULL COMMENT '应用版本',
  `detail` varchar(256) DEFAULT NULL COMMENT 'chart 详情',
  `value` varchar(1024) NOT NULL COMMENT 'value.yaml(模型)',
  `tgz_path` varchar(128) NOT NULL COMMENT 'tgz包路径',
  `chart_id` int(11) DEFAULT NULL COMMENT '外键(as_chart表的主键)',
  PRIMARY KEY (`id`),
  KEY `fk_as_chart_version_as_chart` (`chart_id`),
  CONSTRAINT `fk_as_chart_version_as_chart` FOREIGN KEY (`chart_id`) REFERENCES `as_chart` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `as_chart_version`
-- ----------------------------
BEGIN;
-- INSERT INTO `nacha_appstore`.`as_chart_version` (`id`, `version`, `application_version`, `detail`, `value`, `tgz_path`, `chart_id`) VALUES ('1', '1.0.1', '1.0.0', '', '', '/helm/fabric-1.0.1.tgz', '1');
INSERT INTO `nacha_appstore`.`as_chart_version` (`id`, `version`, `application_version`, `detail`, `value`, `tgz_path`, `chart_id`) VALUES ('2', '3.0.2', '3.0.2', '', '', '/helm/mongodb-3.0.2.tgz', '2');
INSERT INTO `nacha_appstore`.`as_chart_version` (`id`, `version`, `application_version`, `detail`, `value`, `tgz_path`, `chart_id`) VALUES ('3', '0.3.13', '0.3.13', NULL, '', '/helm/apache-0.3.13.tgz', '3');
INSERT INTO `nacha_appstore`.`as_chart_version` (`id`, `version`, `application_version`, `detail`, `value`, `tgz_path`, `chart_id`) VALUES ('4', '0.0.5', '0.0.5', NULL, '', '/helm/kafka-0.0.5.tgz', '4');
INSERT INTO `nacha_appstore`.`as_chart_version` (`id`, `version`, `application_version`, `detail`, `value`, `tgz_path`, `chart_id`) VALUES ('5', '0.6.21', '0.6.21', NULL, '', '/helm/rabbitmq-0.6.21.tgz', '5');


COMMIT;

-- ----------------------------
--  Table structure for `app_release`
-- ----------------------------
DROP TABLE IF EXISTS `app_release`;
CREATE TABLE `app_release` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL COMMENT '名称',
  `release_name` varchar(225) DEFAULT NULL,
  `status` varchar(32) NOT NULL COMMENT '状态',
  `VALUE` text NOT NULL,
  `chart_version_id` int(11) DEFAULT NULL COMMENT '外键(as_chart_version表主键)',
  `project_id` int(11) NOT NULL COMMENT '项目表ID',
  `env_id` int(11) DEFAULT NULL,
  `project_name`  varchar(225) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '项目名称/命名空间',
  PRIMARY KEY (`id`),
  KEY `fk_app_release_version_as_chart` (`chart_version_id`),
  CONSTRAINT `fk_app_release_version_as_chart` FOREIGN KEY (`chart_version_id`) REFERENCES `as_chart_version` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `as_chart`
-- ----------------------------
DROP TABLE IF EXISTS `as_chart`;
CREATE TABLE `as_chart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL COMMENT '名称',
  `display_name` varchar(128) DEFAULT NULL COMMENT '显示名称',
  `icon` varchar(256) DEFAULT NULL COMMENT '图标',
  `status` varchar(32) NOT NULL COMMENT '状态,默认AVAILABLE',
  `type` varchar(32) NOT NULL COMMENT '业务类型(暂时页面没用到，初始化可以为空)',
  `label` varchar(256) DEFAULT NULL COMMENT '标签(暂时页面没用到，初始化可以为空)',
  `link` varchar(256) DEFAULT NULL COMMENT '链接(暂时页面没用到，初始化可以为空)',
  `home_page` varchar(256) DEFAULT NULL COMMENT '主页(暂时页面没用到，初始化可以为空)',
  `introduction` varchar(256) DEFAULT NULL COMMENT '简介(暂时页面没用到，初始化可以为空)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `as_chart`
-- ----------------------------
BEGIN;
-- INSERT INTO `nacha_appstore`.`as_chart` (`id`, `name`, `display_name`, `icon`, `status`, `type`, `label`, `link`, `home_page`, `introduction`) VALUES ('1', 'Fabric', 'Fabric', '/paas-web/platform/loadLogo/fabric.png', 'AVAILABLE', '区块链', 'stable', '', '', 'A Helm chart for Fabric');
INSERT INTO `nacha_appstore`.`as_chart` (`id`, `name`, `display_name`, `icon`, `status`, `type`, `label`, `link`, `home_page`, `introduction`) VALUES ('2', 'MongoDB-Cluster', 'MongoDB-Cluster', '/paas-web/platform/loadLogo/helm.png', 'AVAILABLE', 'mongodb集群', 'stable', '', '', 'A Helm chart for MongoDB-Cluster');
INSERT INTO `nacha_appstore`.`as_chart` (`id`, `name`, `display_name`, `icon`, `status`, `type`, `label`, `link`, `home_page`, `introduction`) VALUES ('3', 'Apache', 'Apache', '/paas-web/platform/loadLogo/apache.jpg', 'AVAILABLE', 'Apache', 'stable', NULL, NULL, 'A Helm chart for Apache');
INSERT INTO `nacha_appstore`.`as_chart` (`id`, `name`, `display_name`, `icon`, `status`, `type`, `label`, `link`, `home_page`, `introduction`) VALUES ('4', 'Kafka', 'Kafka', '/paas-web/platform/loadLogo/kafka.jpg', 'AVAILABLE', 'Kafka', 'stable', NULL, NULL, 'A Helm chart for Kafka');
INSERT INTO `nacha_appstore`.`as_chart` (`id`, `name`, `display_name`, `icon`, `status`, `type`, `label`, `link`, `home_page`, `introduction`) VALUES ('5', 'Rabbitmq', 'Rabbitmq', '/paas-web/platform/loadLogo/rabbitmq.jpg', 'AVAILABLE', 'Rabbitmq', 'stable', NULL, NULL, 'A Helm chart for Rabbitmq');

COMMIT;


-- ----------------------------
--  Table structure for `component_core`
-- ----------------------------
DROP TABLE IF EXISTS `component_core`;
CREATE TABLE `component_core` (
  `component_core_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `component_core_name` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '组件名称',
  `component_assort` int(11) DEFAULT NULL COMMENT '组件归类（0，容器化组件，1非容器化组件）',
  `component_type_id` int(11) DEFAULT NULL COMMENT '组件类型',
  `project_core_id` int(11) DEFAULT NULL COMMENT '项目ID',
  `application_core_id` int(11) DEFAULT NULL COMMENT '应用ID',
  `component_core_param` mediumblob,
  `component_type_name` varchar(300) COLLATE utf8_bin DEFAULT NULL,
  `component_version_id` int(11) DEFAULT NULL,
  `env_id` int(11) DEFAULT NULL,
  `component_core_create_datetime` timestamp NULL DEFAULT NULL,
  `component_core_update_datetime` timestamp NULL DEFAULT NULL,
  `component_core_is_cluster` int(11) DEFAULT NULL,
  `component_core_replicas` int(11) DEFAULT NULL,
  `component_core_status` int(11) DEFAULT NULL,
  `project_core_name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `application_core_name` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `storage_id` int(11) DEFAULT NULL,
  `deploy_request_cpu` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `deploy_request_memory` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `deploy_limit_cpu` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `deploy_limit_memory` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `network_id` int(11) DEFAULT NULL,
  `network_name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `project_core_namespace` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`component_core_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
DROP TABLE IF EXISTS `component_ha_app`;
CREATE TABLE `component_ha_app` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `COMPONENT_CORE_ID` int(11) DEFAULT NULL COMMENT '高可用组件ID',
  `APP_NAME` varchar(255) DEFAULT NULL COMMENT '应用的pod名称',
  `APP_PORT` varchar(255) DEFAULT NULL COMMENT 'nginx对外暴露的端口',
  `URL_PATH` varchar(255) DEFAULT NULL COMMENT '应用访问的根路径名称',
  `READY_STATUS` tinyint(4) NOT NULL DEFAULT '1' COMMENT '加入到负载中的状态（0未加入，1准备加入，2已加入）',
  `RUNTIME_MASTER` varchar(200) DEFAULT NULL COMMENT '运行环境',
  `APP_ID` int(11) DEFAULT NULL COMMENT '应用主键）',
  `IP_HASH` varchar(255) NOT NULL DEFAULT '0' COMMENT '是否启用IP_HASH(0否，1是)',
  `HA_LISTEN_PORT` varchar(10) DEFAULT NULL COMMENT '负载高可用端口',
  `DNS_NAME` varchar(255) NOT NULL DEFAULT 'default_server' COMMENT 'nginx server域名',
  `SSL_ENABLE` varchar(10) NOT NULL DEFAULT '0' COMMENT '是否启用SSL(0否，1是)',
  `CRT_FILE_PATH` varchar(1000) DEFAULT NULL COMMENT '证书文件存放路径',
  `KEY_FILE_PATH` varchar(1000) DEFAULT NULL COMMENT '证书文件存放路径',
  `PROJECT_ID` int(11) DEFAULT NULL COMMENT '项目ID',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for component_type
-- ----------------------------
DROP TABLE IF EXISTS `component_type`;
CREATE TABLE `component_type` (
  `component_type_id` int(11) NOT NULL,
  `component_type_name` varchar(300) COLLATE utf8_bin DEFAULT NULL,
  `component_path` varchar(300) COLLATE utf8_bin DEFAULT NULL,
  `component_assort` int(11) DEFAULT NULL,
  PRIMARY KEY (`component_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records of component_type
-- ----------------------------
INSERT INTO `component_type` VALUES ('1', 'mysql', '/images/mysql.png', '0');
INSERT INTO `component_type` VALUES ('2', 'redis', '/images/redis.png', '0');
INSERT INTO `component_type` VALUES ('3', 'zookeeper', '/images/zk.png', '0');
INSERT INTO `component_type` VALUES ('4', 'nginx', '/images/nginx_G.png', '1');
-- ----------------------------
-- Table structure for component_version
-- ----------------------------
DROP TABLE IF EXISTS `component_version`;
CREATE TABLE `component_version` (
  `component_version_id` int(11) NOT NULL AUTO_INCREMENT,
  `component_version_code` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `component_version_desc` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `component_type_id` int(11) DEFAULT NULL,
  `component_template_name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`component_version_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records of component_version
-- ----------------------------
INSERT INTO `component_version` VALUES ('2', '5.7.20-1debian8', null, '1', 'mysql_standalone.yaml');
INSERT INTO `component_version` VALUES ('3', '4.0.2', null, '2', 'redis_standalone.yaml');
INSERT INTO `component_version` VALUES ('4', '1.0', null, '3', 'zookeeper_cluster.yaml');
INSERT INTO `component_version` VALUES ('7', '1.10.1', null, '4', 'nginx');


DROP FUNCTION IF EXISTS `parserCPU`;
DELIMITER ;;
CREATE DEFINER=`bocloud`@`%` FUNCTION `parserCPU`(cpu VARCHAR(20)) RETURNS float(10,2)
BEGIN

IF cpu is NULL
	THEN
		RETURN 0;
END IF;

IF cpu REGEXP '[0-9]m$'
  THEN
    RETURN CONVERT(LEFT(cpu,LENGTH(cpu)-1),SIGNED)/1000;
END IF;

IF cpu REGEXP '^[1-9]([0-9]?)$'
		THEN
			RETURN CONVERT(cpu,SIGNED);
END IF;

RETURN 0;
END
;;
DELIMITER ;


DROP FUNCTION IF EXISTS `parserMEM`;
DELIMITER ;;
CREATE DEFINER=`bocloud`@`%` FUNCTION `parserMEM`(mem VARCHAR(20)) RETURNS float(10,2)
BEGIN

IF mem is NULL
	THEN
		RETURN 0;
END IF;

IF mem REGEXP '^[1-9]([0-9]+)$'
  THEN
    RETURN CONVERT(mem,SIGNED);
END IF;

IF mem REGEXP '[0-9](Mi)$'
  THEN
    RETURN CONVERT(LEFT(mem,LENGTH(mem)-2),SIGNED);
END IF;

IF mem REGEXP '[0-9](Gi)$'
  THEN
    RETURN CONVERT(LEFT(mem,LENGTH(mem)-2),SIGNED)*1024;
END IF;

RETURN 0;

END
;;
DELIMITER ;