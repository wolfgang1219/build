CREATE database if NOT EXISTS `paas_basic_license` default character set utf8 collate utf8_general_ci;

USE paas_basic_license;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for license_info
-- ----------------------------
DROP TABLE IF EXISTS `license_info`;
CREATE TABLE `license_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `issued_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `expiry_time` datetime(0) NOT NULL,
  `node_count` int(11) NOT NULL,
  `type` int(11) NULL DEFAULT NULL,
  `create_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `node_exceed_time` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for server_info
-- ----------------------------
DROP TABLE IF EXISTS `server_info`;
CREATE TABLE `server_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hardware_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '硬件信息',
  `type` int(11) NULL DEFAULT NULL COMMENT '类型(1:IP地址,2:Mac地址,3:CPU序列号,4:主板序列号)',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for help_document
-- ----------------------------
DROP TABLE IF EXISTS `help_document`;
CREATE TABLE `help_document`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- 帮助文档sql初始化 wubin 20190319
INSERT INTO `help_document` VALUES (1, '使用流程图', '/static/help/guide/快速指南 - 使用流程图.html', NULL);
INSERT INTO `help_document` VALUES (2, 'calico网路配置', '/static/help/guide/快速指南 - calico网络配置.html', NULL);
INSERT INTO `help_document` VALUES (3, '分区管理', '/static/help/guide/快速指南 - 分区管理.html', NULL);
INSERT INTO `help_document` VALUES (4, '如何发布服务', '/static/help/guide/快速指南 - 如何发布服务.html', NULL);
INSERT INTO `help_document` VALUES (5, '如何获取平台接管集群的token', '/static/help/guide/快速指南 - 如何获取平台接管集群的token.html', NULL);
INSERT INTO `help_document` VALUES (6, '如何新建流水线', '/static/help/guide/快速指南 - 如何新建流水线.html', NULL);
INSERT INTO `help_document` VALUES (7, '如何创建存储', '/static/help/guide/快速指南 - 如何创建存储.html', NULL);
INSERT INTO `help_document` VALUES (8, '版本说明（待更新）', '/static/help/document/平台 -  版本说明（待更新）.html', NULL);
INSERT INTO `help_document` VALUES (9, '产品概述', '/static/help/document/平台 - 产品概述.html', NULL);
INSERT INTO `help_document` VALUES (10, '产品功能', '/static/help/document/平台 - 产品功能.html', NULL);
INSERT INTO `help_document` VALUES (11, '产品优势', '/static/help/document/平台 - 产品优势.html', NULL);
INSERT INTO `help_document` VALUES (12, '如何换Logo', '/static/help/document/平台 - 如何更换LOGO.html', NULL);
INSERT INTO `help_document` VALUES (13, '使用流程图', '/static/help/document/平台 - 使用流程图.html', NULL);
INSERT INTO `help_document` VALUES (14, '镜像安全扫描', '/static/help/document/持续集成 -  镜像安全扫描.html', NULL);
INSERT INTO `help_document` VALUES (15, '仓库管理', '/static/help/document/持续集成 - 仓库管理.html', NULL);
INSERT INTO `help_document` VALUES (16, '代码管理', '/static/help/document/持续集成 - 代码管理.html', NULL);
INSERT INTO `help_document` VALUES (17, '镜像管理', '/static/help/document/持续集成 - 镜像管理.html', NULL);
INSERT INTO `help_document` VALUES (18, '流水线概述', '/static/help/document/持续集成 - 流水线概述.html', NULL);
INSERT INTO `help_document` VALUES (19, '如何新建流水线', '/static/help/document/持续集成 - 如何新建流水线.html', NULL);
INSERT INTO `help_document` VALUES (20, '应用场景', '/static/help/document/持续集成 - 应用场景.html', NULL);
INSERT INTO `help_document` VALUES (21, '分区管理', '/static/help/document/基础功能 - 分区管理.html', NULL);
INSERT INTO `help_document` VALUES (22, '平台管理员总览', '/static/help/document/基础功能 - 平台管理员总览.html', NULL);
INSERT INTO `help_document` VALUES (23, '平台监控', '/static/help/document/基础功能 - 平台监控.html', NULL);
INSERT INTO `help_document` VALUES (24, '日志监控', '/static/help/document/基础功能 - 日志监控.html', NULL);
INSERT INTO `help_document` VALUES (25, '如何创建存储', '/static/help/document/基础功能 - 如何创建存储.html', NULL);
INSERT INTO `help_document` VALUES (26, '什么是集群分区', '/static/help/document/基础功能 - 什么是集群分区.html', NULL);
INSERT INTO `help_document` VALUES (27, '租户管理员总览', '/static/help/document/基础功能 - 租户管理员总览.html', NULL);
INSERT INTO `help_document` VALUES (28, '组织管理', '/static/help/document/基础功能 - 组织管理.html', NULL);
INSERT INTO `help_document` VALUES (29, 'docker容器基本概念', '/static/help/document/容器引擎 - docker容器基本概念.html', NULL);
INSERT INTO `help_document` VALUES (30, 'kubernetes基本概念', '/static/help/document/容器引擎 - kubernetes基本概念.html', NULL);
INSERT INTO `help_document` VALUES (31, 'kubernetes优势', '/static/help/document/容器引擎 - kubernetes优势.html', NULL);
INSERT INTO `help_document` VALUES (32, '如何部署kubernetes集群', '/static/help/document/容器引擎 - 如何部署kubernetes集群.html', NULL);
INSERT INTO `help_document` VALUES (33, '如何管理集群分区', '/static/help/document/容器引擎 - 如何管理集群分区.html', NULL);
INSERT INTO `help_document` VALUES (34, '如何纳管kubernetes集群', '/static/help/document/容器引擎 - 如何纳管kubernetes集群.html', NULL);
INSERT INTO `help_document` VALUES (35, '什么是docker', '/static/help/document/容器引擎 - 什么是docker.html', NULL);
INSERT INTO `help_document` VALUES (36, '什么是kubernetes', '/static/help/document/容器引擎 - 什么是kubernetes.html', NULL);
INSERT INTO `help_document` VALUES (37, 'Spring Cloud框架概述', '/static/help/document/微服务治理 - Spring Cloud框架概述.html', NULL);
INSERT INTO `help_document` VALUES (38, '服务治理功能介绍', '/static/help/document/微服务治理 - 服务治理功能介绍.html', NULL);
INSERT INTO `help_document` VALUES (39, '网关管理', '/static/help/document/微服务治理 - 网关管理.html', NULL);
INSERT INTO `help_document` VALUES (40, '为何需要服务治理', '/static/help/document/微服务治理 - 为何需要服务治理.html', NULL);
INSERT INTO `help_document` VALUES (41, '灰度发布', '/static/help/document/应用服务 -  灰度发布.html', NULL);
INSERT INTO `help_document` VALUES (42, '模板管理', '/static/help/document/应用服务 - 模板管理.html', NULL);
INSERT INTO `help_document` VALUES (43, '配置管理', '/static/help/document/应用服务 - 配置管理.html', NULL);
INSERT INTO `help_document` VALUES (44, '如何发布服务', '/static/help/document/应用服务 - 如何发布服务.html', NULL);
INSERT INTO `help_document` VALUES (45, '应用管理', '/static/help/document/应用服务 - 应用管理.html', NULL);
INSERT INTO `help_document` VALUES (46, '组件管理', '/static/help/document/应用服务 - 组件管理.html', NULL);
INSERT INTO `help_document` VALUES (47, '组件商店', '/static/help/document/应用服务 - 组件商店.html', NULL);
INSERT INTO `help_document` VALUES (48, 'portal如何升级', '/static/help/question/常见问题 -  portal如何升级.html', NULL);
INSERT INTO `help_document` VALUES (49, 'scanner第一次扫描失败；再次执行一次成功', '/static/help/question/常见问题 -  scanner第一次扫描失败；再次执行一次成功.html', NULL);
INSERT INTO `help_document` VALUES (50, '配置client的使用 --   Spring集成样例', '/static/help/question/常见问题 -  配置client的使用 --   Spring集成样例.html', NULL);
INSERT INTO `help_document` VALUES (51, '某些场景可能导致deployer的wtach不工作', '/static/help/question/常见问题 -  某些场景可能导致deployer的wtach不工作.html', NULL);
INSERT INTO `help_document` VALUES (52, '部署中断如何继续', '/static/help/question/常见问题 -  部署中断如何继续.html', NULL);
INSERT INTO `help_document` VALUES (53, '配置client的使用 --  客户端获取配置（Java API样例）', '/static/help/question/常见问题 -  配置client的使用 --  客户端获取配置（Java API样例）.html', NULL);
INSERT INTO `help_document` VALUES (54, 'calico网络配置', '/static/help/question/常见问题 - calico网络配置.html', NULL);
INSERT INTO `help_document` VALUES (55, '如何获取平台接管集群的token', '/static/help/question/常见问题 - 如何获取平台接管集群的token.html', NULL);
INSERT INTO `help_document` VALUES (56, '配置client的使用 --  客户端监听配置变化（Java API样例）', '/static/help/question/常见问题 -  配置client的使用 --  客户端监听配置变化（Java API样例）.html', NULL);
INSERT INTO `help_document` VALUES (57, 'ES持久化存储配置', '/static/help/question/常见问题 - ES持久化存储配置.html', NULL);
INSERT INTO `help_document` VALUES (58, '安装deploy部署包时，rpm依赖问题', '/static/help/question/常见问题 - 安装deploy部署包时，rpm依赖问题.html', NULL);
INSERT INTO `help_document` VALUES (59, '配置client的使用 -- 添加引用新增配置文件', '/static/help/question/常见问题 -  配置client的使用 -- 添加引用新增配置文件.html', NULL);
INSERT INTO `help_document` VALUES (60, '使用不同类型的pv', '/static/help/question/常见问题 - 使用不同类型的pv.html', NULL);
INSERT INTO `help_document` VALUES (61, '运行环境部分应用无法外网访问', '/static/help/question/常见问题 - 运行环境部分应用无法外网访问.html', NULL);


