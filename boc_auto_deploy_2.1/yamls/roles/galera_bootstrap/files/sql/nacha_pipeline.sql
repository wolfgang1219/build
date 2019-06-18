/*
Navicat MySQL Data Transfer

Source Server         : 192.168.2.172
Source Server Version : 50505
Source Host           : 192.168.2.172:3316
Source Database       : nacha_pipeline

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2019-02-21 14:23:13
*/
CREATE database if NOT EXISTS `nacha_pipeline` default character set utf8 collate utf8_general_ci;
use `nacha_pipeline`;

SET FOREIGN_KEY_CHECKS=0;


-- ----------------------------
-- Table structure for pipeline_credentials
-- ----------------------------
DROP TABLE IF EXISTS `pipeline_credentials`;
CREATE TABLE `pipeline_credentials` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `CREDENTIALS_SCOPE` varchar(255) NOT NULL COMMENT '使用范围',
  `CREDENTIALS_ID` varchar(255) NOT NULL COMMENT '认证ID',
  `CREDENTIALS_USER` varchar(255) NOT NULL COMMENT '认证用户名称',
  `CREDENTIALS_PWD` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL COMMENT '认证用户密码',
  `CREDENTIALS_DESC` varchar(255) DEFAULT NULL COMMENT '认证描述信息',
  `JENKINS_URL` varchar(255) NOT NULL COMMENT 'jenkins API地址',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for pipeline_task
-- ----------------------------
DROP TABLE IF EXISTS `pipeline_task`;
CREATE TABLE `pipeline_task` (
  `TASK_ID` int(11) NOT NULL AUTO_INCREMENT,
  `TASK_NAME` varchar(255) DEFAULT NULL,
  `REPOSITORY_URL` varchar(255) DEFAULT NULL COMMENT '源码地址',
  `REPOSITORY_USER` varchar(255) DEFAULT NULL COMMENT '私有源码仓库登录用户名',
  `REPOSITORY_PWD` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL COMMENT '私有源码仓库登录用户密码',
  `BRANCH_SPECIFIER` varchar(255) DEFAULT NULL COMMENT '分支',
  `REPOSITORY_TYPE` varchar(255) DEFAULT NULL COMMENT '仓库类型git,svn,gitLab',
  `JENKINS_URL` varchar(255) DEFAULT NULL COMMENT 'jenkins接口服务地址',
  `JENKINS_USER` varchar(255) DEFAULT NULL COMMENT 'jenkins用户',
  `JENKINS_PWD` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL COMMENT 'jenkins用户密码',
  `JENKINS_JOB_NAME` varchar(255) DEFAULT NULL COMMENT 'jenkins的job',
  `JENKINS_BUILD_PATH` varchar(255) DEFAULT NULL COMMENT '应用部署目录，dockerFile也将上传到这里',
  `TASK_STATUS` tinyint(4) DEFAULT NULL COMMENT '状态（1，正常，0，删除）',
  `BUILD_TIMES` int(11) NOT NULL DEFAULT '0' COMMENT '构建次数',
  `CLAIR_ENABLE` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否启用安全扫描(1是，0否）',
  `SONAR_ENABLE` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否启用sonar(1是，0否)',
  `TASK_STAGE` tinyint(255) DEFAULT NULL COMMENT '创建的任务开始阶段（1，源码阶段，2，质量检查，3，应用包构建，4、应用包上传，5，镜像制作阶段，6、镜像上传，7，安全检查，8，镜像推送到仓库）',
  `PROJECT_ID` int(11) DEFAULT NULL COMMENT '项目ID',
  `PROJECT_NAME` varchar(255) DEFAULT NULL COMMENT '项目名称',
  `APP_ID` int(11) DEFAULT NULL COMMENT '应用ID',
  `APP_NAME` varchar(255) DEFAULT NULL COMMENT '应用名称',
  `DOCKERFILE` mediumblob,
  `BUID_IMAGE_IN_JENKINS` tinyint(4) DEFAULT NULL COMMENT '是否在jenkins中进行镜像编译',
  `PUSH_IMAGE_IN_JENKINS` tinyint(4) DEFAULT NULL COMMENT '是否在JENKINS中推送镜像到仓库',
  `REGISTRY_URL` varchar(255) DEFAULT NULL COMMENT '镜像仓库地址',
  `REGISTRY_ID` int(11) DEFAULT NULL COMMENT '仓库主键',
  `LAST_BUILD_TIME` datetime DEFAULT NULL,
  `TASK_CREATETIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `TASK_CREATOR` int(11) DEFAULT NULL COMMENT '创建人',
  `ENV_ID` int(11) DEFAULT NULL,
  `APP_FILE_PATH` varchar(255) DEFAULT NULL COMMENT '上传文件路径',
  `IMAGE_FILE_PATH` varchar(255) DEFAULT NULL COMMENT '镜像文件上传路径',
  `UNIT_TEST` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否执行单元测试0否，1是；默认0',
  `LAST_BUILD_STATUS` tinyint(4) NOT NULL DEFAULT '3' COMMENT '最后构建结果（0正在执行，1成功，2，执行失败，3未执行）',
  `JENKINS_CONFIG` mediumtext COMMENT 'jenkins配置项',
  `TIME_DEPLOY_SWITCH` varchar(10) NOT NULL DEFAULT 'off' COMMENT '部署定时执行开关（on/off）',
  `DEPLOY_CONFIG` mediumtext COMMENT '自动部署配置',
  `AUTO_DEPLOY_ENABLE` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否自动部署,0否1是',
  `LAST_DEPLOY_VERSION` varchar(100) DEFAULT NULL COMMENT 'CD最新部署版本',
  `ENV_NAME` varchar(255) DEFAULT NULL COMMENT '租户名称',
  `TASK_TYPE` varchar(100) DEFAULT NULL COMMENT '类型（pipeline/maven/freedom）',
  PRIMARY KEY (`TASK_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for pipeline_task_event
-- ----------------------------
DROP TABLE IF EXISTS `pipeline_task_event`;
CREATE TABLE `pipeline_task_event` (
  `EVENT_ID` int(11) NOT NULL AUTO_INCREMENT,
  `TASK_ID` int(11) DEFAULT NULL,
  `EVENT_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '事件时间',
  `EVENT_NAME` varchar(255) DEFAULT NULL,
  `EVENT_STEP` tinyint(4) DEFAULT NULL COMMENT '所属阶段(1，源码阶段，2，质量检查，3，应用包构建，4,应用包上传，5，镜像制作阶段，6，镜像上传，7，安全检查，8，镜像推送到仓库）',
  `EXCUTE_TIMES` int(11) DEFAULT NULL COMMENT '此任务此步骤执行的次数',
  `EVENT_RESULT` varchar(100) DEFAULT NULL COMMENT '执行结果',
  `EVENT_TIME_USED` int(11) DEFAULT NULL COMMENT '耗时，单位秒',
  `MESSAGE_INFO` blob COMMENT '执行的输出内容',
  `EVENT_CREATOR` int(11) DEFAULT NULL COMMENT '事件执行人',
  `LAST_BUILD_TASK_TIMES` int(11) NOT NULL DEFAULT '1' COMMENT '构建任务总共执行的次数',
  `LOG_TYPE` int(11) DEFAULT NULL COMMENT '日志类型0文本日志，2日志文件',
  `EVENT_MODE` int(11) NOT NULL DEFAULT '0' COMMENT '触发方式（0，前台触发，1触发器触发）',
  PRIMARY KEY (`EVENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for pipeline_trash_clean
-- ----------------------------
DROP TABLE IF EXISTS `pipeline_trash_clean`;
CREATE TABLE `pipeline_trash_clean` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `TRASH_TYPE` varchar(10) NOT NULL DEFAULT '' COMMENT '垃圾清理类型（0,文件）',
  `TRASH_OBJECT` varchar(255) DEFAULT '' COMMENT '处理对象，如果是文件提供文件路径',
  `TRASH_STATUS` varchar(10) NOT NULL DEFAULT '0' COMMENT '清除状态（0未处理，1已处理）',
  `TRASH_CREATETIME` timestamp NULL DEFAULT NULL COMMENT '垃圾创建时间',
  `TRASH_CLEANTIME` datetime DEFAULT NULL COMMENT '垃圾清理时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;


