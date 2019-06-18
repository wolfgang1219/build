CREATE database if NOT EXISTS `paas_basic_upms` default character set utf8 collate utf8_general_ci;

USE paas_basic_upms;

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for authority
-- ----------------------------
DROP TABLE IF EXISTS `authority`;
CREATE TABLE `authority`  (
  `authority_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '权限id',
  `authority_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限名称',
  `authority_remarks` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单唯一标识',
  `authority_desc` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `authority_relative_url` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '访问url（前端页面跳转）',
  `authority_type` tinyint(11) NULL DEFAULT NULL COMMENT '1：一级菜单  2：二级菜单  3：按钮',
  `authority_parent_id` int(11) UNSIGNED NULL DEFAULT NULL COMMENT '上级节点id',
  `create_date` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `authority_icon` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '菜单图标',
  `authority_creator` int(11) UNSIGNED NULL DEFAULT NULL COMMENT '创建者',
  `authority_sort` int(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '菜单排序',
  `system_type` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '菜单类型（0:自定义，1:系统默认）',
  PRIMARY KEY (`authority_id`) USING BTREE,
  INDEX `authority_parent_id`(`authority_parent_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 156 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of authority
-- ----------------------------
INSERT INTO `authority` VALUES (1, '仪表盘', 'menus.boc.dashboard', '仪表盘', '/app/boc-dashboard', 2, 0, '2019-05-23 20:15:26', 'b-dashboard', NULL, 1, 1);
INSERT INTO `authority` VALUES (2, '基础设施', 'menus.boc.resourceMgmt', '基础设施', '/app/boc-resourceMgmt', 1, 0, '2019-05-23 20:15:26', 'b-ApplicationManageme1', NULL, 7, 1);
INSERT INTO `authority` VALUES (3, '租户管理', 'menus.common.tenantAccount', '租户管理', '/app/common-tenantAccount', 2, 0, '2019-05-23 20:15:26', 'b-Tenantmanagement', NULL, 11, 1);
INSERT INTO `authority` VALUES (4, '权限中心', 'menus.boc.userCenter', '权限中心', '/app/common-authCenter', 1, 0, '2019-05-23 20:15:26', 'b-authority-center', NULL, 12, 1);
INSERT INTO `authority` VALUES (5, '制品仓库', 'menus.boc.artiRegistry', '制品仓库', '/app/boc-artiRegistry', 1, 0, '2019-05-23 20:15:26', 'b-report-management', NULL, 8, 1);
INSERT INTO `authority` VALUES (6, '统计报表', 'menus.common.reportForm', '', '/app/common-reportForm', 1, 0, '2019-05-23 20:15:26', 'b-report-management', NULL, 13, 1);
INSERT INTO `authority` VALUES (7, '告警中心', 'menus.boc.monitorCenter', '监控告警', '/app/boc-monitorCenter', 1, 0, '2019-05-23 20:15:26', 'b-Monitorlargescreen', NULL, 9, 1);
INSERT INTO `authority` VALUES (8, '平台设置', 'menus.common.paltformSet', '平台设置', '/app/common-platformSet', 1, 0, '2019-05-23 20:15:26', 'b-systemsettings', NULL, 14, 1);
INSERT INTO `authority` VALUES (9, '日志中心', 'menus.common.logcenter', '', '/app/common-logcenters', 1, 0, '2019-05-23 20:15:26', 'b-Logs', NULL, 10, 1);
INSERT INTO `authority` VALUES (10, '组件商店', 'menus.boc.helmStore', '组件商店', '/app/boc-helm', 2, 0, '2019-05-23 20:15:26', 'b-component-store', NULL, 6, 1);
INSERT INTO `authority` VALUES (11, '应用中心', 'menus.boc.appMgmt', '应用中心', '/app/boc-appMgmt', 1, 0, '2019-05-23 20:15:26', 'b-applicationManageme', NULL, 2, 1);
INSERT INTO `authority` VALUES (12, '持续集成', 'menus.boc.cicd', '持续集成', '/app/boc-cicd', 2, 0, '2019-05-23 20:15:26', 'b-continuous-integrati', NULL, 5, 1);
INSERT INTO `authority` VALUES (13, '模板管理', 'menus.boc.templateMgmtTenant', '模板管理', '/app/boc-templateMgmtTenant', 1, 0, '2019-05-23 20:15:26', 'b-Templateconfigurati', NULL, 4, 1);
INSERT INTO `authority` VALUES (14, '配置中心', 'menus.boc.appServerMgmt', '配置中心', '/app/boc-appServerMgmt', 1, 0, '2019-05-23 20:15:26', 'b-configuration-center', NULL, 3, 1);
-- INSERT INTO `authority` VALUES (15, '交付中心', 'menus.boc.deliveryCenter', NULL, '/app/boc-deliveryCenter', 1, 0, '2019-05-23 20:15:26', NULL, NULL, 15, 1);
INSERT INTO `authority` VALUES (101, '删除仪表盘', 'menus.boc.deleteDashboard', '删除仪表盘', '', 3, 1, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (102, '添加仪表盘', 'menus.boc.createDashboard', '添加仪表盘', '', 3, 1, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (103, '添加仪表盘面板', 'menus.boc.createDashboardPanel', '添加仪表盘面板', '', 3, 1, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (201, '集群管理', 'menus.boc.cluster', '集群管理', '/app/boc-cluster', 2, 2, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (202, '节点管理', 'menus.boc.host', '节点管理', '/app/boc-host', 2, 2, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (203, '存储管理', 'menus.boc.hardDisk', '存储管理', '/app/boc-hardDisk', 2, 2, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (204, '分区管理', 'menus.boc.partitions', '分区管理', '/app/boc-partitions', 2, 2, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (205, '标签管理', 'menus.boc.labels', '标签管理', '/app/boc-labels', 2, 2, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (206, '网络管理', 'menus.boc.netMgmt', '网络管理', '/app/boc-net', 2, 2, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (207, '租户存储管理', 'menus.boc.storagePvc', '租户存储管理', '/app/boc-storagePvc', 2, 2, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (301, '新增租户', 'menus.common.addEnv', '新增租户', '', 3, 3, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (302, '编辑租户', 'menus.common.updateEnv', '编辑租户', '', 3, 3, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (303, '删除租户', 'menus.common.deleteEnv', '删除租户', '', 3, 3, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (304, '资源配额', 'menus.boc.tenantQuota', '资源配额', '', 3, 3, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (305, '指定管理员', 'menus.common.assignAdministrator', '指定管理员', NULL, 3, 3, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (401, '个人信息', 'menus.common.myAccount', '个人信息', '/app/common-myAccount', 2, 4, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (402, '角色管理', 'menus.common.roleMgmt', '角色管理', '/app/common-roleMgmt', 2, 4, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (403, '用户管理', 'menus.common.userMgmt', '用户管理', '/app/common-userMgmt', 2, 4, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (404, '组织管理', 'menus.common.groupMgmt', '组织管理', '/app/common-groupMgmt', 2, 4, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (405, '菜单管理', 'menus.boc.menu', '菜单管理', '/app/boc-menu', 2, 4, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (501, '仓库管理', 'menus.boc.imageR', '仓库管理', '/app/boc-imageR', 2, 5, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (502, '镜像管理', 'menus.boc.imagesM', '镜像管理', '/app/boc-imagesM', 2, 5, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (503, '脚本管理', 'menus.boc.artiScripts', '脚本管理', '/app/boc-artiScripts', 2, 5, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (601, '集群报表', 'menus.common.clusterReport', NULL, '/app/common-clusterReport', 2, 6, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (602, '分区报表', 'menus.common.partitionReport', NULL, '/app/common-partitionReport', 2, 6, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (603, '节点报表', 'menus.common.hostsReport', NULL, '/app/common-hostsReport', 2, 6, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (604, '租户报表', 'menus.common.tenantsReport', NULL, '/app/common-tenantsReport', 2, 6, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (605, '告警报表', 'menus.common.monitorReport', NULL, '/app/common-monitorReport', 2, 6, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (606, '审计报表', 'menus.common.billingReport', NULL, '/app/common-billingReport', 2, 6, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (607, '应用报表', 'menus.common.applicationReport', NULL, '/app/common-applicationReport', 2, 6, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (608, '套餐设置', 'menus.common.packMgmt', NULL, '/app/common-packMgmt', 2, 6, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (609, '计量计费', 'menus.common.billing', NULL, '/app/common-billing', 2, 6, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (701, '告警规则', 'menus.boc.monitorRule', '告警规则', '/app/boc-monitorList', 2, 7, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (702, '告警历史', 'menus.boc.monitorHistory', '告警历史', '/app/boc-monitorHistory', 2, 7, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (703, '告警联系人', 'menus.boc.monitorContacts', '告警联系人', '/app/boc-monitorContacts', 2, 7, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (801, '系统配置', 'menus.common.systemPoc', '系统配置', '/app/common-systemPoc', 2, 8, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (802, '平台配置', 'menus.common.config', '平台配置', '/app/common-config', 2, 8, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (901, '操作审计', 'menus.common.audit', '操作审计', '/app/boc-audit', 2, 9, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (902, '平台日志', 'menus.common.platformLog', '平台日志', '/app/common-logcenter', 2, 9, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (903, '应用日志', 'menus.common.applicationLog', '应用日志', '/app/common-logcenter', 2, 9, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (904, '日志告警', 'menus.common.logAlarmList', NULL, '/app/common-logAlarm', 2, 9, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (905, '告警历史', 'menus.common.logAlarmHistory', NULL, '/app/boc-logAlarmHistory', 2, 9, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1001, '组件商店', 'menus.boc.helm', '组件商店', '/app/boc-helm', 2, 10, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1002, '组件管理', 'menus.boc.helmlst', '组件管理', '/app/boc-helmlst', 2, 10, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1101, '应用', 'menus.boc.projMgmt', '应用', '/app/boc-projMgmt', 2, 11, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1102, '服务', 'menus.boc.appRep', '服务', '/app/boc-appRep', 2, 11, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1103, '负载', 'menus.boc.appService', '负载', '/app/boc-service', 2, 11, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1104, '实例', 'menus.boc.appPods', '实例', '/app/boc-appPods', 2, 11, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1105, '任务管理', 'menus.boc.taskMgmt', '任务管理', '/app/boc-task', 2, 11, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1201, '新增持续集成', 'menus.boc.addCicd', '新增持续集成', NULL, 3, 12, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1202, '编辑持续集成', 'menus.boc.updateCicd', '编辑持续集成', NULL, 3, 12, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1203, '删除持续集成', 'menus.boc.deleteCicd', '删除持续集成', NULL, 3, 12, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1204, '持续集成详情页操作', 'menus.cicdOperate', '持续集成详情页操作', NULL, 3, 12, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1301, '文件管理', 'menus.boc.templateMgmt', '文件管理', '/app/boc-templateMgmt', 2, 13, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1302, '导入yaml', 'menus.boc.importYaml', '导入yaml', '/app/boc-importYaml', 2, 13, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1401, '配置库', 'menus.boc.serverConf', NULL, '/app/boc-appServerConf', 2, 14, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (1402, 'configMap', 'menus.boc.appConf', 'configMap', '/app/boc-appConf', 2, 14, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
-- INSERT INTO `authority` VALUES (1501, 'pipeline', 'menus.boc.pipeline', NULL, '/app/boc-pipeline', 2, 15, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
-- INSERT INTO `authority` VALUES (1502, '应用模板管理', 'menus.boc.appTemplate', NULL, '/app/boc-Template', 2, 15, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
-- INSERT INTO `authority` VALUES (1503, '包管理', 'menus.boc.packageManager', NULL, '/app/boc-packageManager', 2, 15, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
-- INSERT INTO `authority` VALUES (1504, '流程模板', 'menus.boc.flowType', NULL, '/app/boc-flowType', 2, 15, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
-- INSERT INTO `authority` VALUES (1505, '审批', 'menus.boc.approvalManager', NULL, '/app/boc-approvalManager', 2, 15, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
-- INSERT INTO `authority` VALUES (1506, '凭证管理', 'menus.boc.credentialsManager', NULL, '/app/boc-credentialsManager', 2, 15, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
-- INSERT INTO `authority` VALUES (1507, '代码库管理', 'menus.boc.codeLibrary', NULL, '/app/boc-codeLibrary', 2, 15, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20101, '新增集群', 'menus.common.createCluste', '新增集群', NULL, 3, 201, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20102, '删除集群', 'menus.common.deleteCluste', '删除集群', NULL, 3, 201, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20103, '更新集群', 'menus.common.updateCluste', '更新集群', NULL, 3, 201, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20104, '同步集群', 'menus.common.syncCluste', '同步集群', NULL, 3, 201, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20105, '新增节点', 'menus.common.addNode', '新增节点', NULL, 3, 201, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20201, '禁用/启用调度', 'menus.boc.disableScheduling', '禁用/启用调度', '', 3, 202, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20202, '新增资源组', 'menus.boc.addResourceGroup', '新增资源组', '', 3, 202, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20203, '删除资源组', 'menus.boc.deleteResourceGroup', '删除资源组', '', 3, 202, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20204, '增加主机', 'menus.boc.addHost', '增加主机', '', 3, 202, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20205, '导入主机列表', 'menus.boc.importHostsList', '导入主机列表', '', 3, 202, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20206, '移除', 'menus.boc.removeHost', '移除', '', 3, 202, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20301, '新增存储', 'menus.boc.createDisk', '新增存储', NULL, 3, 203, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20302, '删除存储', 'menus.boc.deleteDisk', '新增存储', NULL, 3, 203, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20401, '新增分区', 'menus.boc.createPartitions', '新增分区', '', 3, 204, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20402, '编辑分区', 'menus.boc.updatePartitions', '编辑分区', '', 3, 204, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20403, '删除分区', 'menus.boc.deletePartitions', '删除分区', '', 3, 204, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20404, '导入节点', 'menus.boc.moveInPartitions', '导入节点', '', 3, 204, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20405, '导出节点', 'menus.boc.moveOutPartitions', '导出节点', '', 3, 204, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20501, '新增标签', 'menus.boc.createLabels', '新增标签', '', 3, 205, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20502, '编辑标签', 'menus.boc.updateLabels', '编辑标签', '', 3, 205, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20503, '删除标签', 'menus.boc.deleteLabels', '删除标签', '', 3, 205, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20601, '新增网络', 'menus.common.createNet', '新增网络', NULL, 3, 206, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20602, '删除网络', 'menus.common.deleteNet', '删除网络', NULL, 3, 206, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20603, '更新网络', 'menus.common.updateNet', '更新网络', NULL, 3, 206, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20701, '新增租户存储管理', 'menus.boc.createStoragePvc', '新增租户存储管理', NULL, 3, 207, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20702, '删除租户存储管理', 'menus.boc.deleteStoragePvc', '删除租户存储管理', NULL, 3, 207, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (20703, '租户存储管理事件', 'menus.boc.storagePvcEvent', '租户存储管理事件', NULL, 3, 207, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40101, '个人信息更新', 'menus.common.updateInfo', '个人信息更新', '', 3, 401, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40102, '修改个人密码', 'menus.common.changePwd', '修改个人密码', '', 3, 401, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40201, '新增角色', 'menus.common.addRole', '新增角色', NULL, 3, 402, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40202, '删除角色', 'menus.common.deleteRole', '删除角色', NULL, 3, 402, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40203, '更新角色', 'menus.common.updateRole', '更新角色', NULL, 3, 402, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40204, '角色详情', 'menus.common.roleDetails', '角色详情', NULL, 3, 402, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40205, '批量删除', 'menus.common.deleteRoleList', '批量删除', NULL, 3, 402, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40206, '搜索角色', 'menus.common.searchRole', '搜索角色', NULL, 3, 402, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40301, '新增用户', 'menus.common.createUser', '新增用户', NULL, 3, 403, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40302, '删除用户', 'menus.common.deleteUser', '删除用户', NULL, 3, 403, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40303, '更新用户', 'menus.common.updateUser', '更新用户', NULL, 3, 403, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40304, '冻结/解冻用户', 'menus.common.freezeUser', '冻结/解冻用户', NULL, 3, 403, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40305, '重置密码', 'menus.common.resetPwd', '重置密码', NULL, 3, 403, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40306, '分配角色', 'menus.common.assignRole', '分配角色', NULL, 3, 403, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40307, '批量删除', 'menus.common.deleteUserList', '批量删除', NULL, 3, 403, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40308, '导入用户', 'menus.common.importPlatformUsers', '导入用户', NULL, 3, 403, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40401, '新增组织', 'menus.common.addOrg', '新增组织', NULL, 3, 404, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40402, '删除组织', 'menus.common.deleteOrg', '删除组织', NULL, 3, 404, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40403, '更新组织', 'menus.common.updateOrg', '更新组织', NULL, 3, 404, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40404, '分配角色', 'menus.common.assignRole', '分配角色', NULL, 3, 404, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40405, '添加用户', 'menus.common.addUser', '添加用户', NULL, 3, 404, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40406, '移除用户', 'menus.common.deleteUser', '移除用户', NULL, 3, 404, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40407, '添加子机构', 'menus.common.addSubOrg', '添加子机构', NULL, 3, 404, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40408, '导入组织', 'menus.common.groupMgmtImport', '导入组织', NULL, 3, 404, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40501, '新增菜单', 'menus.boc.menu_add', '', NULL, 3, 405, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40502, '编辑菜单', 'menus.boc.menu_edit', '', NULL, 3, 405, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (40503, '删除菜单', 'menus.boc.menu_delete', '', NULL, 3, 405, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (50101, '新增仓库', 'menus.boc.addReg', '新增仓库', NULL, 3, 501, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (50102, '编辑仓库', 'menus.boc.updateReg', '编辑仓库', NULL, 3, 501, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (50103, '导入', 'menus.boc.importReg', '导入', NULL, 3, 501, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (50104, '同步', 'menus.boc.syncReg', '同步', NULL, 3, 501, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (50105, '删除', 'menus.boc.deleteReg', '删除', NULL, 3, 501, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (50106, '操作历史', 'menus.boc.regHistory', '操作历史', NULL, 3, 501, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (50201, '编辑镜像', 'menus.boc.updateImage', '编辑镜像', NULL, 3, 502, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (50202, '扫描镜像', 'menus.boc.scannerImage', '扫描镜像', NULL, 3, 502, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (50203, '扫描结果', 'menus.boc.scannerImageResult', '扫描结果', NULL, 3, 502, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (50204, '删除', 'menus.boc.deleteImage', '删除', NULL, 3, 502, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (50205, '下载镜像', 'menus.boc.downloadImage', '下载镜像', NULL, 3, 502, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (50301, '新增脚本', 'menus.boc.createScripts', '新增脚本', NULL, 3, 503, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (50302, '删除脚本', 'menus.boc.deleteScripts', '删除脚本', NULL, 3, 503, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (50303, '批量删除', 'menus.boc.deleteScriptsList', '批量删除', NULL, 3, 503, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60101, '集群报表规则', 'menus.common.setRuleClusterReport', '集群报表规则', NULL, 3, 601, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60102, '删除集群报表', 'menus.common.deleteClusterReport', '删除集群报表', NULL, 3, 601, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60103, '下载集群报表', 'menus.common.downloadClusterReport', '下载集群报表', NULL, 3, 601, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60201, '分区报表规则', 'menus.common.setRulePartitionReport', '分区报表规则', NULL, 3, 602, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60202, '删除分区报表', 'menus.common.deletePartitionReport', '删除分区报表', NULL, 3, 602, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60203, '下载分区报表', 'menus.common.downloadPartitionReport', '下载分区报表', NULL, 3, 602, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60301, '节点报表规则', 'menus.common.setRuleHostsReport ', '节点报表规则', NULL, 3, 603, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60302, '删除节点报表', 'menus.common.deleteHostsReport', '删除节点报表', NULL, 3, 603, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60303, '下载节点报表', 'menus.common.downloadHostsReport', '下载节点报表', NULL, 3, 603, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60401, '租户报表规则', 'menus.common.setRuleTenantsReport ', '租户报表规则', NULL, 3, 604, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60402, '删除租户报表', 'menus.common.deleteTenantsReport', '删除租户报表', NULL, 3, 604, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60403, '下载租户报表', 'menus.common.downloadTenantsReport', '下载租户报表', NULL, 3, 604, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60501, '规则设置', 'menus.common.monitorReportSet', '告警报表规则设置', NULL, 2, 605, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60502, '删除', 'menus.common.monitorReportDelete', '告警报表删除', NULL, 2, 605, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60503, '下载', 'menus.common.monitorReportDownload', '告警报表下载', NULL, 2, 605, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60601, '审计报表规则', 'menus.common.setRuleBillingReport ', '审计报表规则', NULL, 3, 606, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60602, '删除审计报表', 'menus.common.deleteBillingReport', '删除审计报表', NULL, 3, 606, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60603, '下载审计报表', 'menus.common.downloadBillingReport', '下载审计报表', NULL, 3, 606, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60701, '应用报表规则', 'menus.common.setRuleApplicationReport ', '应用报表规则', NULL, 3, 607, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60702, '删除应用报表', 'menus.common.deleteApplicationReport', '删除应用报表', NULL, 3, 607, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60703, '下载应用报表', 'menus.common.downloadApplicationReport', '下载应用报表', NULL, 3, 607, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60801, '套餐管理新增', 'menus.boc.packMgmtAdd', '套餐管理新增', NULL, 3, 608, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60802, '套餐管理配置单价', 'menus.boc.packMgmtConfig', '套餐管理配置单价', NULL, 3, 608, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60803, '套餐管理删除', 'menus.boc.packMgmtDel', '套餐管理删除', NULL, 3, 608, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (60804, '套餐管理的编辑', 'menus.common.packMgmtEdit', '套餐管理的编辑', NULL, 3, 608, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70101, '新增告警', 'menus.boc.createMonitorRule', '新增告警', NULL, 3, 701, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70102, '编辑告警', 'menus.boc.updateMonitorRule', '编辑告警', NULL, 3, 701, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70103, '删除告警', 'menus.boc.deleteMonitorRule', '删除告警', NULL, 3, 701, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70104, '禁用告警', 'menus.boc.forbiddenMonitorRule', '禁用告警', NULL, 3, 701, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70105, '立即同步', 'menus.boc.syncMonitorRule', '立即同步', NULL, 3, 701, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70106, '告警报表规则', 'menus.common.setRuleMonitorReport', '告警报表规则', NULL, 3, 701, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70107, '删除告警报表', 'menus.common.deleteMonitorReport', '删除告警报表', NULL, 3, 701, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70108, '下载告警报表', 'menus.common.downloadMonitorReport', '下载告警报表', NULL, 3, 701, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70201, '清理历史数据', 'menus.boc.deleteMonitorHistory', '清理历史数据', NULL, 3, 702, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70301, '新增联系人', 'menus.boc.createContactPerson', '新增联系人', NULL, 3, 703, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70302, '编辑联系人', 'menus.boc.updateContactPerson', '编辑联系人', NULL, 3, 703, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70303, '删除联系人', 'menus.boc.deleteContactPerson', '删除联系人', NULL, 3, 703, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70304, '批量删除', 'menus.boc.deleteContactPersonsList', '批量删除', NULL, 3, 703, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70305, '批量添加到组', 'menus.boc.addContactGroupsList', '批量添加到组', NULL, 3, 703, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70306, '更改联系组', 'menus.boc.editContactGroups', '更改联系组', NULL, 3, 703, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70307, '退出联系组', 'menus.boc.quitContactGroups', '退出联系组', NULL, 3, 703, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70308, '加入联系组', 'menus.boc.addContactGroups', '加入联系组', NULL, 3, 703, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70309, '新增联系组', 'menus.boc.createContactGroups', '新增联系组', NULL, 3, 703, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70310, '编辑联系组', 'menus.boc.updateContactGroups', '编辑联系组', NULL, 3, 703, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (70311, '删除联系组', 'menus.boc.deleteContactGroups', '删除联系组', NULL, 3, 703, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (80101, '顶部选择', 'menus.common.topLogoChoice', '顶部logo选择', NULL, 3, 801, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (80102, '顶部上传', 'menus.common.topLogoUpload', '顶部logo上传', NULL, 3, 801, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (80103, '菜单选择', 'menus.common.menuLogoChoice', '菜单logo选择', NULL, 3, 801, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (80104, '菜单上传', 'menus.common.menuLogoUpload', '菜单logo上传', NULL, 3, 801, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (80201, '组件配置编辑', 'menus.common.configEdit', '组件配置编辑', NULL, 3, 802, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (90101, '清除历史数据', 'menus.common.deleteHistoryData', '清除历史数据', NULL, 3, 901, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (90401, '日志告警新增', 'menus.boc.logAlarmListAdd', '日志告警新增', NULL, 3, 904, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (90402, '日志告警编辑', 'menus.boc.logAlarmListEdit', '日志告警编辑', NULL, 3, 904, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (90403, '日志告警删除', 'menus.boc.logAlarmListDel', '日志告警删除', NULL, 3, 904, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (100101, '导入', 'menus.boc.helmImport', '导入', NULL, 3, 1001, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (100102, '组件服务', 'menus.boc.helmlstView', '组件服务', NULL, 3, 1001, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (100103, '删除', 'menus.boc.helmDel', '删除', NULL, 3, 1001, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (100201, '应用目录', 'menus.boc.helmView', '应用目录', NULL, 3, 1002, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (100202, '删除', 'menus.boc.helmlstDel', '删除', NULL, 3, 1002, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110101, '新增应用', 'menus.boc.addProject', '新增应用', NULL, 3, 1101, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110102, '编辑应用', 'menus.boc.updateProject', '编辑应用', NULL, 3, 1101, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110103, '发布服务', 'menus.boc.publishService', '发布服务', NULL, 3, 1101, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110104, '创建任务', 'menus.boc.createTask', '创建任务', NULL, 3, 1101, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110105, '资源配额', 'menus.boc.projectQuota', '资源配额', NULL, 3, 1101, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110106, '删除', 'menus.boc.deleteProject', '删除', NULL, 3, 1101, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110107, '指定成员', 'menus.boc.designatedMember', '指定成员', NULL, 3, 1101, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110201, '物理部署新增服务', 'menus.boc.addPhysicService', '物理部署新增服务', NULL, 3, 1102, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110202, '物理部署删除', 'menus.boc.deletePhysicService', '物理部署删除', NULL, 3, 1102, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110203, '容器化新增服务', 'menus.boc.addContainerService', '容器化新增服务', NULL, 3, 1102, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110204, '容器化删除', 'menus.boc.deleteContainerService', '容器化删除', NULL, 3, 1102, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110301, '内部负载新增', 'menus.boc.addInternalLoad', '内部负载新增', NULL, 3, 1103, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110302, '内部负载编辑', 'menus.boc.updateInternalLoad', '内部负载编辑', NULL, 3, 1103, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110303, '内部负载删除', 'menus.boc.deleteInternalLoad', '内部负载删除', NULL, 3, 1103, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110304, '外部负载新增', 'menus.boc.addExternalLoad', '外部负载新增', NULL, 3, 1103, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110305, '外部负载编辑', 'menus.boc.updateExternalLoad', '外部负载编辑', NULL, 3, 1103, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110306, '外部负载删除', 'menus.boc.deleteExternalLoad', '外部负载删除', NULL, 3, 1103, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110501, '新增任务', 'menus.boc.addTask', '新增任务', NULL, 3, 1105, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110502, '编辑任务', 'menus.boc.updateTask', '编辑任务', NULL, 3, 1105, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (110503, '删除任务', 'menus.boc.deleteTask', '删除任务', NULL, 3, 1105, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (130101, '新增文件', 'menus.boc.addTemplateMgmt', '新增文件', NULL, 3, 1301, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (130102, '编辑文件', 'menus.boc.updateTemplateMgmt', '编辑文件', NULL, 3, 1301, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (130103, '删除文件', 'menus.boc.deleteTemplateMgmt', '删除文件', NULL, 3, 1301, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (130104, '共享', 'menus.boc.shareTemplateMgmt', '共享', NULL, 3, 1301, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (130105, '批量删除', 'menus.boc.deleteTemplateMgmtsList', '批量删除', NULL, 3, 1301, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (130201, '添加本地文件', 'menus.boc.addLocalFiles', '添加本地文件', NULL, 3, 1302, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (130202, '导入', 'menus.boc.importYamlFile', '导入', NULL, 3, 1302, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (140101, '下载', 'menus.boc.downloadServerConf', '下载', NULL, 3, 1401, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (140102, '发布', 'menus.boc.publishServerConf', '发布', NULL, 3, 1401, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (140201, '配置中心新增', 'menus.boc.createAppConf', '配置中心新增', NULL, 3, 1402, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (140202, '配置中心编辑', 'menus.boc.editAppConf', '配置中心编辑', NULL, 3, 1402, '2019-05-23 20:15:26', NULL, NULL, 0, 1);
INSERT INTO `authority` VALUES (140203, '配置中心删除', 'menus.boc.deleteAppConf', '配置中心删除', NULL, 3, 1402, '2019-05-23 20:15:26', NULL, NULL, 0, 1);

-- ----------------------------
-- Table structure for organization
-- ----------------------------
DROP TABLE IF EXISTS `organization`;
CREATE TABLE `organization`  (
  `org_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '组织机构ID',
  `org_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '机构名称',
  `org_all_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '机构全称',
  `org_update_date` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '机构更新时间',
  `org_desc` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组织机构描述信息',
  `org_creator` int(11) UNSIGNED NULL DEFAULT NULL COMMENT '组织创建者',
  `org_create_date` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '机构创建时间',
  `org_type` tinyint(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT '组织机构类型  0:自定义  1:系统同步',
  `org_parent_id` int(11) UNSIGNED NOT NULL COMMENT '组织机构父id',
  `org_guid` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'LDAP组织唯一标识',
  `org_distinguished_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'LDAP组织DN',
  `env_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '组织机构所属租户ID',
  PRIMARY KEY (`org_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 60 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for organization_user
-- ----------------------------
DROP TABLE IF EXISTS `organization_user`;
CREATE TABLE `organization_user`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `org_id` int(11) NULL DEFAULT NULL COMMENT '所属组织ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 141 CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Compact;



-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `role_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '角色id',
  `role_name` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色名称',
  `role_desc` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色描述信息',
  `role_type` tinyint(2) NULL DEFAULT 0 COMMENT '0：自定义 1：超级管理员 2：租户管理员',
  `role_creator` int(11) NULL DEFAULT NULL COMMENT '创建者',
  `role_createdate` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `env_id` int(11) NOT NULL DEFAULT 0 COMMENT '角色所属租户ID',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES (1, '平台管理员', '平台管理员', 1, 1, '2018-12-20 15:49:39', 0);
INSERT INTO `role` VALUES (2, '租户管理员', '租户管理员', 2, 1, '2018-12-20 15:49:39', 0);


-- ----------------------------
-- Table structure for role_authority
-- ----------------------------
DROP TABLE IF EXISTS `role_authority`;
CREATE TABLE `role_authority`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_id` int(11) NULL DEFAULT NULL COMMENT '角色ID',
  `authority_id` int(11) NULL DEFAULT NULL COMMENT '权限ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 305 CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Compact;

-- ----------------------------
-- Records of role_authority
-- ----------------------------

INSERT INTO `role_authority` VALUES (1, 1, 1);
INSERT INTO `role_authority` VALUES (2, 1, 2);
INSERT INTO `role_authority` VALUES (3, 1, 3);
INSERT INTO `role_authority` VALUES (4, 1, 4);
INSERT INTO `role_authority` VALUES (5, 1, 5);
INSERT INTO `role_authority` VALUES (6, 1, 6);
INSERT INTO `role_authority` VALUES (7, 1, 7);
INSERT INTO `role_authority` VALUES (8, 1, 8);
INSERT INTO `role_authority` VALUES (9, 1, 9);
INSERT INTO `role_authority` VALUES (10, 1, 201);
INSERT INTO `role_authority` VALUES (11, 1, 202);
INSERT INTO `role_authority` VALUES (12, 1, 203);
INSERT INTO `role_authority` VALUES (14, 1, 204);
INSERT INTO `role_authority` VALUES (16, 1, 206);
INSERT INTO `role_authority` VALUES (17, 1, 301);
INSERT INTO `role_authority` VALUES (18, 1, 302);
INSERT INTO `role_authority` VALUES (19, 1, 303);
INSERT INTO `role_authority` VALUES (20, 1, 304);
INSERT INTO `role_authority` VALUES (21, 1, 305);
INSERT INTO `role_authority` VALUES (22, 1, 401);
INSERT INTO `role_authority` VALUES (23, 1, 402);
INSERT INTO `role_authority` VALUES (24, 1, 403);
INSERT INTO `role_authority` VALUES (25, 1, 404);
INSERT INTO `role_authority` VALUES (26, 1, 501);
INSERT INTO `role_authority` VALUES (27, 1, 502);
INSERT INTO `role_authority` VALUES (29, 1, 601);
INSERT INTO `role_authority` VALUES (30, 1, 602);
INSERT INTO `role_authority` VALUES (31, 1, 603);
INSERT INTO `role_authority` VALUES (32, 1, 604);
INSERT INTO `role_authority` VALUES (33, 1, 605);
INSERT INTO `role_authority` VALUES (34, 1, 606);
INSERT INTO `role_authority` VALUES (35, 1, 607);
INSERT INTO `role_authority` VALUES (36, 1, 608);
INSERT INTO `role_authority` VALUES (37, 1, 609);
INSERT INTO `role_authority` VALUES (38, 1, 701);
INSERT INTO `role_authority` VALUES (39, 1, 702);
INSERT INTO `role_authority` VALUES (40, 1, 703);
INSERT INTO `role_authority` VALUES (41, 1, 801);
INSERT INTO `role_authority` VALUES (42, 1, 802);
INSERT INTO `role_authority` VALUES (43, 1, 901);
INSERT INTO `role_authority` VALUES (44, 1, 902);
INSERT INTO `role_authority` VALUES (45, 1, 20101);
INSERT INTO `role_authority` VALUES (46, 1, 20102);
INSERT INTO `role_authority` VALUES (47, 1, 20103);
INSERT INTO `role_authority` VALUES (48, 1, 20104);
INSERT INTO `role_authority` VALUES (49, 1, 20105);
INSERT INTO `role_authority` VALUES (50, 1, 20201);
INSERT INTO `role_authority` VALUES (51, 1, 20202);
INSERT INTO `role_authority` VALUES (52, 1, 20203);
INSERT INTO `role_authority` VALUES (53, 1, 20204);
INSERT INTO `role_authority` VALUES (54, 1, 20205);
INSERT INTO `role_authority` VALUES (55, 1, 20206);
INSERT INTO `role_authority` VALUES (56, 1, 20301);
INSERT INTO `role_authority` VALUES (57, 1, 20302);
INSERT INTO `role_authority` VALUES (58, 1, 20401);
INSERT INTO `role_authority` VALUES (59, 1, 20402);
INSERT INTO `role_authority` VALUES (60, 1, 20403);
INSERT INTO `role_authority` VALUES (64, 1, 20601);
INSERT INTO `role_authority` VALUES (65, 1, 20602);
INSERT INTO `role_authority` VALUES (66, 1, 20603);
INSERT INTO `role_authority` VALUES (67, 1, 40101);
INSERT INTO `role_authority` VALUES (68, 1, 40102);
INSERT INTO `role_authority` VALUES (69, 1, 40201);
INSERT INTO `role_authority` VALUES (70, 1, 40202);
INSERT INTO `role_authority` VALUES (71, 1, 40203);
INSERT INTO `role_authority` VALUES (72, 1, 40204);
INSERT INTO `role_authority` VALUES (73, 1, 40205);
INSERT INTO `role_authority` VALUES (74, 1, 40206);
INSERT INTO `role_authority` VALUES (75, 1, 40301);
INSERT INTO `role_authority` VALUES (76, 1, 40302);
INSERT INTO `role_authority` VALUES (77, 1, 40303);
INSERT INTO `role_authority` VALUES (78, 1, 40304);
INSERT INTO `role_authority` VALUES (79, 1, 40305);
INSERT INTO `role_authority` VALUES (80, 1, 40306);
INSERT INTO `role_authority` VALUES (81, 1, 40307);
INSERT INTO `role_authority` VALUES (82, 1, 40401);
INSERT INTO `role_authority` VALUES (83, 1, 40402);
INSERT INTO `role_authority` VALUES (84, 1, 40403);
INSERT INTO `role_authority` VALUES (85, 1, 40404);
INSERT INTO `role_authority` VALUES (86, 1, 40405);
INSERT INTO `role_authority` VALUES (87, 1, 40406);
INSERT INTO `role_authority` VALUES (88, 1, 40407);
INSERT INTO `role_authority` VALUES (89, 1, 40408);
INSERT INTO `role_authority` VALUES (90, 1, 50101);
INSERT INTO `role_authority` VALUES (91, 1, 50102);
INSERT INTO `role_authority` VALUES (92, 1, 50103);
INSERT INTO `role_authority` VALUES (93, 1, 50104);
INSERT INTO `role_authority` VALUES (94, 1, 50105);
INSERT INTO `role_authority` VALUES (95, 1, 50106);
INSERT INTO `role_authority` VALUES (96, 1, 50201);
INSERT INTO `role_authority` VALUES (97, 1, 50202);
INSERT INTO `role_authority` VALUES (98, 1, 50203);
INSERT INTO `role_authority` VALUES (99, 1, 50204);
INSERT INTO `role_authority` VALUES (100, 1, 50205);
INSERT INTO `role_authority` VALUES (104, 1, 70101);
INSERT INTO `role_authority` VALUES (105, 1, 70102);
INSERT INTO `role_authority` VALUES (106, 1, 70103);
INSERT INTO `role_authority` VALUES (107, 1, 70104);
INSERT INTO `role_authority` VALUES (108, 1, 70105);
INSERT INTO `role_authority` VALUES (109, 1, 70201);
INSERT INTO `role_authority` VALUES (110, 1, 70301);
INSERT INTO `role_authority` VALUES (111, 1, 70302);
INSERT INTO `role_authority` VALUES (112, 1, 70303);
INSERT INTO `role_authority` VALUES (113, 1, 70304);
INSERT INTO `role_authority` VALUES (114, 1, 70305);
INSERT INTO `role_authority` VALUES (115, 1, 70306);
INSERT INTO `role_authority` VALUES (116, 1, 70307);
INSERT INTO `role_authority` VALUES (117, 1, 70308);
INSERT INTO `role_authority` VALUES (118, 1, 70309);
INSERT INTO `role_authority` VALUES (119, 1, 70310);
INSERT INTO `role_authority` VALUES (120, 1, 70311);
INSERT INTO `role_authority` VALUES (121, 1, 80101);
INSERT INTO `role_authority` VALUES (122, 1, 80102);
INSERT INTO `role_authority` VALUES (123, 1, 80103);
INSERT INTO `role_authority` VALUES (124, 1, 80104);
INSERT INTO `role_authority` VALUES (125, 1, 80201);
INSERT INTO `role_authority` VALUES (126, 1, 90101);
INSERT INTO `role_authority` VALUES (127, 1, 60801);
INSERT INTO `role_authority` VALUES (128, 1, 60802);
INSERT INTO `role_authority` VALUES (129, 1, 60803);
INSERT INTO `role_authority` VALUES (130, 1, 70106);
INSERT INTO `role_authority` VALUES (131, 1, 70107);
INSERT INTO `role_authority` VALUES (132, 1, 70108);
INSERT INTO `role_authority` VALUES (133, 1, 60201);
INSERT INTO `role_authority` VALUES (134, 1, 60202);
INSERT INTO `role_authority` VALUES (135, 1, 60203);
INSERT INTO `role_authority` VALUES (136, 1, 60101);
INSERT INTO `role_authority` VALUES (137, 1, 60102);
INSERT INTO `role_authority` VALUES (138, 1, 60103);
INSERT INTO `role_authority` VALUES (139, 1, 60601);
INSERT INTO `role_authority` VALUES (140, 1, 60602);
INSERT INTO `role_authority` VALUES (141, 1, 60603);
INSERT INTO `role_authority` VALUES (142, 1, 60401);
INSERT INTO `role_authority` VALUES (143, 1, 60402);
INSERT INTO `role_authority` VALUES (144, 1, 60403);
INSERT INTO `role_authority` VALUES (145, 1, 60701);
INSERT INTO `role_authority` VALUES (146, 1, 60702);
INSERT INTO `role_authority` VALUES (147, 1, 60703);
INSERT INTO `role_authority` VALUES (148, 1, 60301);
INSERT INTO `role_authority` VALUES (149, 1, 60302);
INSERT INTO `role_authority` VALUES (150, 1, 60303);
INSERT INTO `role_authority` VALUES (151, 1, 101);
INSERT INTO `role_authority` VALUES (152, 1, 102);
INSERT INTO `role_authority` VALUES (153, 1, 20404);
INSERT INTO `role_authority` VALUES (154, 1, 20405);
INSERT INTO `role_authority` VALUES (155, 1, 60804);
INSERT INTO `role_authority` VALUES (156, 1, 60501);
INSERT INTO `role_authority` VALUES (157, 1, 60502);
INSERT INTO `role_authority` VALUES (158, 1, 60503);
INSERT INTO `role_authority` VALUES (201, 2, 1);
INSERT INTO `role_authority` VALUES (202, 2, 2);
INSERT INTO `role_authority` VALUES (203, 2, 4);
INSERT INTO `role_authority` VALUES (204, 2, 5);
INSERT INTO `role_authority` VALUES (205, 2, 6);
INSERT INTO `role_authority` VALUES (206, 2, 9);
INSERT INTO `role_authority` VALUES (207, 2, 10);
INSERT INTO `role_authority` VALUES (208, 2, 11);
INSERT INTO `role_authority` VALUES (209, 2, 12);
INSERT INTO `role_authority` VALUES (210, 2, 13);
INSERT INTO `role_authority` VALUES (211, 2, 14);
INSERT INTO `role_authority` VALUES (213, 2, 202);
INSERT INTO `role_authority` VALUES (214, 2, 207);
INSERT INTO `role_authority` VALUES (215, 2, 204);
INSERT INTO `role_authority` VALUES (217, 2, 205);
INSERT INTO `role_authority` VALUES (218, 2, 206);
INSERT INTO `role_authority` VALUES (223, 2, 401);
INSERT INTO `role_authority` VALUES (224, 2, 402);
INSERT INTO `role_authority` VALUES (225, 2, 403);
INSERT INTO `role_authority` VALUES (226, 2, 404);
INSERT INTO `role_authority` VALUES (227, 2, 501);
INSERT INTO `role_authority` VALUES (228, 2, 502);
INSERT INTO `role_authority` VALUES (229, 2, 503);
INSERT INTO `role_authority` VALUES (231, 2, 602);
INSERT INTO `role_authority` VALUES (234, 2, 605);
INSERT INTO `role_authority` VALUES (236, 2, 607);
INSERT INTO `role_authority` VALUES (238, 2, 609);
INSERT INTO `role_authority` VALUES (239, 2, 901);
INSERT INTO `role_authority` VALUES (241, 2, 1001);
INSERT INTO `role_authority` VALUES (243, 2, 1002);
INSERT INTO `role_authority` VALUES (244, 2, 1101);
INSERT INTO `role_authority` VALUES (245, 2, 1102);
INSERT INTO `role_authority` VALUES (246, 2, 1103);
INSERT INTO `role_authority` VALUES (247, 2, 1104);
INSERT INTO `role_authority` VALUES (248, 2, 1105);
INSERT INTO `role_authority` VALUES (249, 2, 1201);
INSERT INTO `role_authority` VALUES (250, 2, 1202);
INSERT INTO `role_authority` VALUES (251, 2, 1203);
INSERT INTO `role_authority` VALUES (252, 2, 1301);
INSERT INTO `role_authority` VALUES (253, 2, 1302);
INSERT INTO `role_authority` VALUES (254, 2, 1401);
INSERT INTO `role_authority` VALUES (255, 2, 1402);
INSERT INTO `role_authority` VALUES (263, 2, 20101);
INSERT INTO `role_authority` VALUES (264, 2, 20102);
INSERT INTO `role_authority` VALUES (265, 2, 20103);
INSERT INTO `role_authority` VALUES (266, 2, 20104);
INSERT INTO `role_authority` VALUES (267, 2, 20105);
INSERT INTO `role_authority` VALUES (268, 2, 20201);
INSERT INTO `role_authority` VALUES (269, 2, 20202);
INSERT INTO `role_authority` VALUES (270, 2, 20203);
INSERT INTO `role_authority` VALUES (271, 2, 20204);
INSERT INTO `role_authority` VALUES (272, 2, 20205);
INSERT INTO `role_authority` VALUES (273, 2, 20206);
INSERT INTO `role_authority` VALUES (274, 2, 20701);
INSERT INTO `role_authority` VALUES (275, 2, 20702);
INSERT INTO `role_authority` VALUES (276, 2, 20703);
INSERT INTO `role_authority` VALUES (279, 2, 20501);
INSERT INTO `role_authority` VALUES (280, 2, 20502);
INSERT INTO `role_authority` VALUES (281, 2, 20503);
INSERT INTO `role_authority` VALUES (285, 2, 40101);
INSERT INTO `role_authority` VALUES (286, 2, 40102);
INSERT INTO `role_authority` VALUES (287, 2, 40201);
INSERT INTO `role_authority` VALUES (288, 2, 40202);
INSERT INTO `role_authority` VALUES (289, 2, 40203);
INSERT INTO `role_authority` VALUES (290, 2, 40204);
INSERT INTO `role_authority` VALUES (291, 2, 40205);
INSERT INTO `role_authority` VALUES (292, 2, 40206);
INSERT INTO `role_authority` VALUES (294, 2, 40302);
INSERT INTO `role_authority` VALUES (295, 2, 60502);
INSERT INTO `role_authority` VALUES (296, 2, 60503);
INSERT INTO `role_authority` VALUES (298, 2, 40306);
INSERT INTO `role_authority` VALUES (299, 2, 40307);
INSERT INTO `role_authority` VALUES (300, 2, 40401);
INSERT INTO `role_authority` VALUES (301, 2, 40402);
INSERT INTO `role_authority` VALUES (302, 2, 40403);
INSERT INTO `role_authority` VALUES (303, 2, 40404);
INSERT INTO `role_authority` VALUES (304, 2, 40405);
INSERT INTO `role_authority` VALUES (305, 2, 40406);
INSERT INTO `role_authority` VALUES (306, 2, 40407);
INSERT INTO `role_authority` VALUES (307, 2, 40308);
INSERT INTO `role_authority` VALUES (308, 2, 50101);
INSERT INTO `role_authority` VALUES (309, 2, 50102);
INSERT INTO `role_authority` VALUES (310, 2, 50103);
INSERT INTO `role_authority` VALUES (311, 2, 50104);
INSERT INTO `role_authority` VALUES (312, 2, 50105);
INSERT INTO `role_authority` VALUES (313, 2, 50106);
INSERT INTO `role_authority` VALUES (314, 2, 50201);
INSERT INTO `role_authority` VALUES (315, 2, 50202);
INSERT INTO `role_authority` VALUES (316, 2, 50203);
INSERT INTO `role_authority` VALUES (317, 2, 50204);
INSERT INTO `role_authority` VALUES (318, 2, 50205);
INSERT INTO `role_authority` VALUES (319, 2, 50301);
INSERT INTO `role_authority` VALUES (320, 2, 50302);
INSERT INTO `role_authority` VALUES (321, 2, 50303);
INSERT INTO `role_authority` VALUES (322, 2, 70101);
INSERT INTO `role_authority` VALUES (323, 2, 70102);
INSERT INTO `role_authority` VALUES (324, 2, 70103);
INSERT INTO `role_authority` VALUES (325, 2, 70104);
INSERT INTO `role_authority` VALUES (326, 2, 70105);
INSERT INTO `role_authority` VALUES (327, 2, 70201);
INSERT INTO `role_authority` VALUES (328, 2, 70301);
INSERT INTO `role_authority` VALUES (329, 2, 70302);
INSERT INTO `role_authority` VALUES (330, 2, 70303);
INSERT INTO `role_authority` VALUES (331, 2, 70304);
INSERT INTO `role_authority` VALUES (332, 2, 70305);
INSERT INTO `role_authority` VALUES (333, 2, 70306);
INSERT INTO `role_authority` VALUES (334, 2, 70306);
INSERT INTO `role_authority` VALUES (335, 2, 70307);
INSERT INTO `role_authority` VALUES (336, 2, 70308);
INSERT INTO `role_authority` VALUES (337, 2, 70309);
INSERT INTO `role_authority` VALUES (338, 2, 70310);
INSERT INTO `role_authority` VALUES (339, 2, 70311);
INSERT INTO `role_authority` VALUES (340, 2, 80101);
INSERT INTO `role_authority` VALUES (341, 2, 80102);
INSERT INTO `role_authority` VALUES (342, 2, 80103);
INSERT INTO `role_authority` VALUES (343, 2, 80104);
INSERT INTO `role_authority` VALUES (344, 2, 80201);
INSERT INTO `role_authority` VALUES (345, 2, 90101);
INSERT INTO `role_authority` VALUES (346, 2, 110101);
INSERT INTO `role_authority` VALUES (347, 2, 110102);
INSERT INTO `role_authority` VALUES (348, 2, 110103);
INSERT INTO `role_authority` VALUES (349, 2, 110104);
INSERT INTO `role_authority` VALUES (350, 2, 110105);
INSERT INTO `role_authority` VALUES (351, 2, 110106);
INSERT INTO `role_authority` VALUES (352, 2, 110107);
INSERT INTO `role_authority` VALUES (353, 2, 110201);
INSERT INTO `role_authority` VALUES (354, 2, 110202);
INSERT INTO `role_authority` VALUES (355, 2, 110203);
INSERT INTO `role_authority` VALUES (356, 2, 110204);
INSERT INTO `role_authority` VALUES (357, 2, 110301);
INSERT INTO `role_authority` VALUES (358, 2, 110302);
INSERT INTO `role_authority` VALUES (359, 2, 110303);
INSERT INTO `role_authority` VALUES (360, 2, 110304);
INSERT INTO `role_authority` VALUES (361, 2, 110305);
INSERT INTO `role_authority` VALUES (362, 2, 110306);
INSERT INTO `role_authority` VALUES (363, 2, 110501);
INSERT INTO `role_authority` VALUES (364, 2, 110502);
INSERT INTO `role_authority` VALUES (365, 2, 110503);
INSERT INTO `role_authority` VALUES (366, 2, 130101);
INSERT INTO `role_authority` VALUES (367, 2, 130102);
INSERT INTO `role_authority` VALUES (368, 2, 130103);
INSERT INTO `role_authority` VALUES (369, 2, 130104);
INSERT INTO `role_authority` VALUES (370, 2, 130105);
INSERT INTO `role_authority` VALUES (371, 2, 130201);
INSERT INTO `role_authority` VALUES (372, 2, 130202);
INSERT INTO `role_authority` VALUES (373, 2, 140101);
INSERT INTO `role_authority` VALUES (374, 2, 140102);
INSERT INTO `role_authority` VALUES (375, 2, 903);
INSERT INTO `role_authority` VALUES (376, 2, 904);
INSERT INTO `role_authority` VALUES (377, 2, 905);
INSERT INTO `role_authority` VALUES (378, 2, 100101);
INSERT INTO `role_authority` VALUES (379, 2, 100102);
INSERT INTO `role_authority` VALUES (380, 2, 100103);
INSERT INTO `role_authority` VALUES (381, 2, 100201);
INSERT INTO `role_authority` VALUES (382, 2, 100202);
INSERT INTO `role_authority` VALUES (383, 2, 90401);
INSERT INTO `role_authority` VALUES (384, 2, 90402);
INSERT INTO `role_authority` VALUES (385, 2, 90403);
INSERT INTO `role_authority` VALUES (386, 2, 60801);
INSERT INTO `role_authority` VALUES (387, 2, 60802);
INSERT INTO `role_authority` VALUES (388, 2, 60803);
INSERT INTO `role_authority` VALUES (389, 2, 70106);
INSERT INTO `role_authority` VALUES (390, 2, 70107);
INSERT INTO `role_authority` VALUES (391, 2, 70108);
INSERT INTO `role_authority` VALUES (392, 2, 60201);
INSERT INTO `role_authority` VALUES (393, 2, 60202);
INSERT INTO `role_authority` VALUES (394, 2, 60203);
INSERT INTO `role_authority` VALUES (395, 2, 60101);
INSERT INTO `role_authority` VALUES (396, 2, 60102);
INSERT INTO `role_authority` VALUES (397, 2, 60103);
INSERT INTO `role_authority` VALUES (398, 2, 60601);
INSERT INTO `role_authority` VALUES (399, 2, 60602);
INSERT INTO `role_authority` VALUES (400, 2, 60603);
INSERT INTO `role_authority` VALUES (401, 2, 60401);
INSERT INTO `role_authority` VALUES (402, 2, 60402);
INSERT INTO `role_authority` VALUES (403, 2, 60403);
INSERT INTO `role_authority` VALUES (404, 2, 60701);
INSERT INTO `role_authority` VALUES (405, 2, 60702);
INSERT INTO `role_authority` VALUES (406, 2, 60703);
INSERT INTO `role_authority` VALUES (407, 2, 60301);
INSERT INTO `role_authority` VALUES (408, 2, 60302);
INSERT INTO `role_authority` VALUES (409, 2, 60303);
INSERT INTO `role_authority` VALUES (410, 2, 101);
INSERT INTO `role_authority` VALUES (411, 2, 102);
INSERT INTO `role_authority` VALUES (412, 2, 103);
INSERT INTO `role_authority` VALUES (413, 2, 140201);
INSERT INTO `role_authority` VALUES (414, 2, 140202);
INSERT INTO `role_authority` VALUES (415, 2, 140203);
INSERT INTO `role_authority` VALUES (416, 2, 1204);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `user_name` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名称',
  `user_password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `user_realname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户真实姓名',
  `user_mail` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '电子邮件',
  `user_phone` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '电话',
  `user_company` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户公司名称',
  `user_dept` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户部门名称',
  `user_jobnum` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户工号',
  `user_createdate` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `user_creator` int(11) NULL DEFAULT NULL COMMENT '创建者ID',
  `login_status` tinyint(4) UNSIGNED NULL DEFAULT 0 COMMENT '0:离线  1:在线',
  `user_token` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '用户登录token',
  `user_status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '用户状态（0：冻结，1：正常）',
  `isadmin` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否平台管理员（0否，1是）',
  `last_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上一次登录错误锁定的时间戳',
  `error_count` int(5) NOT NULL DEFAULT 0 COMMENT '登录错误计数',
  `first_login` tinyint(4) NOT NULL DEFAULT 0 COMMENT '是否新创建且未登陆用户（0：是，1：否）',
  `user_type` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户类型（0：自定义，1：LDAP同步）',
  `ldap_guid` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'LDAP用户唯一标识',
  `ldap_org_dn` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'LDAP用户所在组织DN',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 179 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '9A11B5172D0A961BD358F643F661941F', 'admin', 'admin@test.com', '', 'company', 'department', 'jobnum', '2018-12-17 15:19:05', 1, 0, '', 1, 1, '2018-12-17 15:19:05', 0, 1, 0, NULL,NULL);

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `role_id` int(11) NULL DEFAULT NULL COMMENT '角色ID',
  `env_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '租户ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 194 CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Compact;

-- ----------------------------
-- Records of user_role
-- ----------------------------
INSERT INTO `user_role` VALUES (1, 1, 1, 0);


-- ----------------------------
-- Table structure for organization_role
-- ----------------------------
DROP TABLE IF EXISTS `organization_role`;
CREATE TABLE `organization_role`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `org_id` int(11) NULL DEFAULT NULL COMMENT '所属组织ID',
  `role_id` int(11) NULL DEFAULT NULL COMMENT '角色ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for role_app_permission
-- ----------------------------
DROP TABLE IF EXISTS `role_app_permission`;
CREATE TABLE `role_app_permission`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `role_id` int(11) UNSIGNED NULL DEFAULT NULL COMMENT '角色id',
  `project_id` int(11) UNSIGNED NOT NULL COMMENT '应用id',
  `application_id` int(11) UNSIGNED NULL DEFAULT NULL COMMENT '权限id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 186 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for role_permission
-- ----------------------------
DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_id` int(11) UNSIGNED NULL DEFAULT NULL COMMENT '角色ID',
  `type` tinyint(4) UNSIGNED NOT NULL COMMENT '数据权限类型',
  `permission_id` int(11) UNSIGNED NULL DEFAULT NULL COMMENT '数据权限ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;



-- ----------------------------
-- Table structure for env
-- ----------------------------
DROP TABLE IF EXISTS `env`;
CREATE TABLE `env`  (
  `env_id` int(11) NOT NULL AUTO_INCREMENT,
  `env_name` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '租户名称',
  `env_desc` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '租户描述信息',
  `env_createtime` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `env_creator` int(11) NULL DEFAULT NULL COMMENT '创建人',
  `is_del` int(11) NOT NULL DEFAULT 0 COMMENT '删除状态 0：存在 1：已删除',
  `env_status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '环境状态(1正常，0默认租户)',
  PRIMARY KEY (`env_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 156 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;


-- ----------------------------
-- Table structure for user_data_permission
-- ----------------------------
DROP TABLE IF EXISTS `user_data_permission`;
CREATE TABLE `user_data_permission`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `project_id` int(11) UNSIGNED NOT NULL COMMENT '应用id',
  `env_id` int(11) UNSIGNED NULL DEFAULT NULL COMMENT '租户id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 92 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;


-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project`  (
  `project_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_name` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '应用名称',
  `project_desc` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '应用描述信息',
  `project_createtime` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `project_creator` int(11) NULL DEFAULT NULL COMMENT '创建人',
  `is_del` int(11) NOT NULL DEFAULT 0 COMMENT '删除状态 0：存在 1：已删除',
  `env_id` int(11) UNSIGNED NULL DEFAULT NULL COMMENT '租户id',
  `project_type` varchar(200) NULL DEFAULT NULL COMMENT '应用类型(通用、容器、springcloud、grpc、dubbo)',
  PRIMARY KEY (`project_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 156 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;
