-- ============================================================
-- 植物病虫害识别系统数据库设计
-- 符合阿里巴巴 Java 开发规范
-- 数据库: MySQL 8.0+
-- 字符集: utf8mb4
-- 排序规则: utf8mb4_general_ci
-- ============================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `plant_disease` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE `plant_disease`;

-- ============================================================
-- 1. 用户模块
-- ============================================================

-- -----------------------------------------------------------
-- 1.1 微信小程序用户表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `wx_user`;
CREATE TABLE `wx_user` (
    `id`                    BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '用户ID',
    `openid`                VARCHAR(64)         NOT NULL DEFAULT ''      COMMENT '微信用户唯一标识',
    `union_id`              VARCHAR(64)         NOT NULL DEFAULT ''      COMMENT '微信开放平台唯一标识',
    `session_key`           VARCHAR(128)        NOT NULL DEFAULT ''      COMMENT '微信会话密钥',
    `nickname`              VARCHAR(64)         NOT NULL DEFAULT ''      COMMENT '用户昵称',
    `avatar`                VARCHAR(512)        NOT NULL DEFAULT ''      COMMENT '头像文件key',
    `avatar_url`            VARCHAR(512)        NOT NULL DEFAULT ''      COMMENT '头像URL',
    `gender`                TINYINT UNSIGNED    NOT NULL DEFAULT 0       COMMENT '性别: 0-未知, 1-男, 2-女',
    `country`               VARCHAR(32)         NOT NULL DEFAULT ''      COMMENT '国家',
    `province`              VARCHAR(32)         NOT NULL DEFAULT ''      COMMENT '省份',
    `city`                  VARCHAR(32)         NOT NULL DEFAULT ''      COMMENT '城市',
    `district`              VARCHAR(32)         NOT NULL DEFAULT ''      COMMENT '区/县',
    `language`              VARCHAR(16)         NOT NULL DEFAULT ''      COMMENT '语言',
    `phone`                 VARCHAR(20)         NOT NULL DEFAULT ''      COMMENT '手机号',
    `signature`             VARCHAR(255)        NOT NULL DEFAULT ''      COMMENT '个性签名',
    `role`                  VARCHAR(20)         NOT NULL DEFAULT 'user'  COMMENT '用户角色: user-普通用户, admin-管理员',
    `status`                TINYINT UNSIGNED    NOT NULL DEFAULT 1       COMMENT '用户状态: 0-禁用, 1-正常',
    `total_recognitions`    INT UNSIGNED        NOT NULL DEFAULT 0       COMMENT '总识别次数',
    `recognition_days`      INT UNSIGNED        NOT NULL DEFAULT 0       COMMENT '识别天数',
    `post_count`            INT UNSIGNED        NOT NULL DEFAULT 0       COMMENT '发帖数',
    `comment_count`         INT UNSIGNED        NOT NULL DEFAULT 0       COMMENT '评论数',
    `like_count`            INT UNSIGNED        NOT NULL DEFAULT 0       COMMENT '获赞数',
    `last_recognition_date` DATE                NULL                     COMMENT '最后识别日期',
    `last_login_time`       DATETIME            NULL                     COMMENT '最后登录时间',
    `create_time`           DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`           DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`               TINYINT(1)          NOT NULL DEFAULT 0       COMMENT '逻辑删除: 0-未删除, 1-已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_openid` (`openid`),
    KEY `idx_union_id` (`union_id`),
    KEY `idx_phone` (`phone`),
    KEY `idx_status` (`status`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='微信小程序用户表';

-- -----------------------------------------------------------
-- 1.2 系统管理员表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `sys_admin`;
CREATE TABLE `sys_admin` (
    `id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '管理员ID',
    `username`      VARCHAR(64)         NOT NULL                 COMMENT '用户名',
    `password`      VARCHAR(128)        NOT NULL                 COMMENT '密码(加密)',
    `name`          VARCHAR(64)         NOT NULL DEFAULT ''      COMMENT '姓名',
    `email`         VARCHAR(128)        NOT NULL DEFAULT ''      COMMENT '邮箱',
    `phone`         VARCHAR(20)         NOT NULL DEFAULT ''      COMMENT '手机号',
    `avatar`        VARCHAR(512)        NOT NULL DEFAULT ''      COMMENT '头像URL',
    `role`          VARCHAR(20)         NOT NULL DEFAULT 'admin' COMMENT '角色: admin-管理员, super_admin-超级管理员',
    `status`        TINYINT UNSIGNED    NOT NULL DEFAULT 1       COMMENT '状态: 0-禁用, 1-正常',
    `last_login_time` DATETIME          NULL                     COMMENT '最后登录时间',
    `last_login_ip` VARCHAR(50)         NOT NULL DEFAULT ''      COMMENT '最后登录IP',
    `create_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`       TINYINT(1)          NOT NULL DEFAULT 0       COMMENT '逻辑删除: 0-未删除, 1-已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    KEY `idx_phone` (`phone`),
    KEY `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统管理员表';

-- -----------------------------------------------------------
-- 1.3 用户权限表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission` (
    `id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '权限ID',
    `parent_id`     BIGINT UNSIGNED     NOT NULL DEFAULT 0       COMMENT '父权限ID',
    `name`          VARCHAR(64)         NOT NULL                 COMMENT '权限名称',
    `code`          VARCHAR(64)         NOT NULL                 COMMENT '权限编码',
    `type`          TINYINT UNSIGNED    NOT NULL DEFAULT 1       COMMENT '类型: 1-菜单, 2-按钮, 3-接口',
    `path`          VARCHAR(255)        NOT NULL DEFAULT ''      COMMENT '路由路径',
    `icon`          VARCHAR(64)         NOT NULL DEFAULT ''      COMMENT '图标',
    `sort_order`    INT                 NOT NULL DEFAULT 0       COMMENT '排序',
    `status`        TINYINT UNSIGNED    NOT NULL DEFAULT 1       COMMENT '状态: 0-禁用, 1-正常',
    `create_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_code` (`code`),
    KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户权限表';

-- -----------------------------------------------------------
-- 1.4 管理员权限关联表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `sys_admin_permission`;
CREATE TABLE `sys_admin_permission` (
    `id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '主键ID',
    `admin_id`      BIGINT UNSIGNED     NOT NULL                 COMMENT '管理员ID',
    `permission_id` BIGINT UNSIGNED     NOT NULL                 COMMENT '权限ID',
    `create_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_admin_permission` (`admin_id`, `permission_id`),
    KEY `idx_admin_id` (`admin_id`),
    KEY `idx_permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='管理员权限关联表';

-- ============================================================
-- 2. 病虫害知识库模块
-- ============================================================

-- -----------------------------------------------------------
-- 2.1 作物分类表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `crop_category`;
CREATE TABLE `crop_category` (
    `id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '分类ID',
    `name`          VARCHAR(64)         NOT NULL                 COMMENT '分类名称',
    `description`   VARCHAR(512)        NOT NULL DEFAULT ''      COMMENT '分类描述',
    `image_url`     VARCHAR(512)        NOT NULL DEFAULT ''      COMMENT '分类图片URL',
    `sort_order`    INT                 NOT NULL DEFAULT 0       COMMENT '排序',
    `status`        TINYINT UNSIGNED    NOT NULL DEFAULT 1       COMMENT '状态: 0-禁用, 1-正常',
    `create_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`       TINYINT(1)          NOT NULL DEFAULT 0       COMMENT '逻辑删除: 0-未删除, 1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='作物分类表';

-- -----------------------------------------------------------
-- 2.2 病虫害信息表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `disease`;
CREATE TABLE `disease` (
    `id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '病虫害ID',
    `category_id`   BIGINT UNSIGNED     NOT NULL                 COMMENT '作物分类ID',
    `name`          VARCHAR(128)        NOT NULL                 COMMENT '病虫害名称(学名)',
    `common_name`   VARCHAR(128)        NOT NULL DEFAULT ''      COMMENT '俗名',
    `type`          VARCHAR(20)         NOT NULL DEFAULT 'disease' COMMENT '类型: disease-病害, pest-虫害',
    `symptoms`      TEXT                                     COMMENT '症状描述(JSON数组)',
    `basic_desc`    VARCHAR(1024)       NOT NULL DEFAULT ''      COMMENT '基本描述',
    `detail_desc`   TEXT                                     COMMENT '详细描述',
    `score`         VARCHAR(20)         NOT NULL DEFAULT ''      COMMENT '危害程度: low-低, medium-中, high-高',
    `treatment`     TEXT                                     COMMENT '防治方法(JSON数组)',
    `images`        TEXT                                     COMMENT '图片URL(JSON数组)',
    `status`        TINYINT UNSIGNED    NOT NULL DEFAULT 1       COMMENT '状态: 0-禁用, 1-正常',
    `create_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`       TINYINT(1)          NOT NULL DEFAULT 0       COMMENT '逻辑删除: 0-未删除, 1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_category_id` (`category_id`),
    KEY `idx_type` (`type`),
    KEY `idx_name` (`name`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='病虫害信息表';

-- -----------------------------------------------------------
-- 2.3 作物信息表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `crop`;
CREATE TABLE `crop` (
    `id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '作物ID',
    `category_id`   BIGINT UNSIGNED     NOT NULL                 COMMENT '分类ID',
    `name`          VARCHAR(128)        NOT NULL                 COMMENT '作物名称',
    `common_name`   VARCHAR(128)        NOT NULL DEFAULT ''      COMMENT '俗名',
    `type`          VARCHAR(20)         NOT NULL DEFAULT ''      COMMENT '作物类型',
    `basic_desc`    VARCHAR(1024)       NOT NULL DEFAULT ''      COMMENT '基本描述',
    `detail_desc`   TEXT                                     COMMENT '详细描述',
    `images`        TEXT                                     COMMENT '图片URL(JSON数组)',
    `status`        TINYINT UNSIGNED    NOT NULL DEFAULT 1       COMMENT '状态: 0-禁用, 1-正常',
    `create_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`       TINYINT(1)          NOT NULL DEFAULT 0       COMMENT '逻辑删除: 0-未删除, 1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_category_id` (`category_id`),
    KEY `idx_type` (`type`),
    KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='作物信息表';

-- ============================================================
-- 3. 识别记录模块
-- ============================================================

-- -----------------------------------------------------------
-- 3.1 识别记录表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `recognition_record`;
CREATE TABLE `recognition_record` (
    `id`                BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '记录ID',
    `user_id`           BIGINT UNSIGNED     NOT NULL                 COMMENT '用户ID',
    `image_url`         VARCHAR(512)        NOT NULL                 COMMENT '上传图片URL',
    `result_type`       VARCHAR(20)         NOT NULL DEFAULT ''      COMMENT '识别结果类型: disease-病害, pest-虫害',
    `result_id`         BIGINT UNSIGNED     NULL                     COMMENT '识别结果ID(关联disease表)',
    `result_name`       VARCHAR(128)        NOT NULL DEFAULT ''      COMMENT '识别结果名称',
    `result_description` VARCHAR(1024)      NOT NULL DEFAULT ''      COMMENT '识别结果描述',
    `probability`       DECIMAL(5,2)        NOT NULL DEFAULT 0.00    COMMENT '识别概率(0-100)',
    `model_version`     VARCHAR(64)         NOT NULL DEFAULT ''      COMMENT '模型版本',
    `create_time`       DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`       DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`           TINYINT(1)          NOT NULL DEFAULT 0       COMMENT '逻辑删除: 0-未删除, 1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_result_type` (`result_type`),
    KEY `idx_result_id` (`result_id`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='识别记录表';

-- -----------------------------------------------------------
-- 3.2 诊断记录表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `diagnosis_record`;
CREATE TABLE `diagnosis_record` (
    `id`                BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '诊断ID',
    `user_id`           BIGINT UNSIGNED     NOT NULL                 COMMENT '用户ID',
    `image_url`         VARCHAR(512)        NOT NULL                 COMMENT '上传图片URL',
    `diagnosis_result`  VARCHAR(255)        NOT NULL DEFAULT ''      COMMENT '诊断结果',
    `confidence`        DECIMAL(5,2)        NOT NULL DEFAULT 0.00    COMMENT '置信度(0-100)',
    `suggestions`       TEXT                                     COMMENT '建议(JSON数组)',
    `model_version`     VARCHAR(64)         NOT NULL DEFAULT ''      COMMENT '模型版本',
    `create_time`       DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`       DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`           TINYINT(1)          NOT NULL DEFAULT 0       COMMENT '逻辑删除: 0-未删除, 1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='诊断记录表';

-- ============================================================
-- 4. 社区论坛模块
-- ============================================================

-- -----------------------------------------------------------
-- 4.1 帖子表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `forum_post`;
CREATE TABLE `forum_post` (
    `id`                BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '帖子ID',
    `user_id`           BIGINT UNSIGNED     NOT NULL                 COMMENT '用户ID',
    `title`             VARCHAR(255)        NOT NULL                 COMMENT '帖子标题',
    `content`           TEXT                NOT NULL                 COMMENT '帖子内容',
    `images`            TEXT                                     COMMENT '图片URL(JSON数组)',
    `recognized_crop`   VARCHAR(128)        NOT NULL DEFAULT ''      COMMENT '识别出的作物名称',
    `likes_count`       INT UNSIGNED        NOT NULL DEFAULT 0       COMMENT '点赞数',
    `comments_count`    INT UNSIGNED        NOT NULL DEFAULT 0       COMMENT '评论数',
    `views_count`       INT UNSIGNED        NOT NULL DEFAULT 0       COMMENT '浏览数',
    `is_top`            TINYINT(1)          NOT NULL DEFAULT 0       COMMENT '是否置顶: 0-否, 1-是',
    `is_essence`        TINYINT(1)          NOT NULL DEFAULT 0       COMMENT '是否精华: 0-否, 1-是',
    `status`            TINYINT UNSIGNED    NOT NULL DEFAULT 1       COMMENT '状态: 0-删除, 1-正常, 2-审核中',
    `create_time`       DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`       DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`           TINYINT(1)          NOT NULL DEFAULT 0       COMMENT '逻辑删除: 0-未删除, 1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_status` (`status`),
    KEY `idx_create_time` (`create_time`),
    FULLTEXT KEY `ft_title_content` (`title`, `content`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='论坛帖子表';

-- -----------------------------------------------------------
-- 4.2 评论表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `forum_comment`;
CREATE TABLE `forum_comment` (
    `id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '评论ID',
    `post_id`       BIGINT UNSIGNED     NOT NULL                 COMMENT '帖子ID',
    `user_id`       BIGINT UNSIGNED     NOT NULL                 COMMENT '用户ID',
    `parent_id`     BIGINT UNSIGNED     NOT NULL DEFAULT 0       COMMENT '父评论ID(0为一级评论)',
    `reply_user_id` BIGINT UNSIGNED     NULL                     COMMENT '回复用户ID',
    `content`       VARCHAR(1024)       NOT NULL                 COMMENT '评论内容',
    `likes_count`   INT UNSIGNED        NOT NULL DEFAULT 0       COMMENT '点赞数',
    `status`        TINYINT UNSIGNED    NOT NULL DEFAULT 1       COMMENT '状态: 0-删除, 1-正常',
    `create_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`       TINYINT(1)          NOT NULL DEFAULT 0       COMMENT '逻辑删除: 0-未删除, 1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_post_id` (`post_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_parent_id` (`parent_id`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='论坛评论表';

-- -----------------------------------------------------------
-- 4.3 点赞表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `forum_like`;
CREATE TABLE `forum_like` (
    `id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '点赞ID',
    `user_id`       BIGINT UNSIGNED     NOT NULL                 COMMENT '用户ID',
    `target_id`     BIGINT UNSIGNED     NOT NULL                 COMMENT '目标ID(帖子ID或评论ID)',
    `target_type`   VARCHAR(20)         NOT NULL DEFAULT 'post'  COMMENT '目标类型: post-帖子, comment-评论',
    `create_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_target` (`user_id`, `target_id`, `target_type`),
    KEY `idx_target` (`target_id`, `target_type`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='点赞表';

-- ============================================================
-- 5. 反馈模块
-- ============================================================

-- -----------------------------------------------------------
-- 5.1 用户反馈表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `user_feedback`;
CREATE TABLE `user_feedback` (
    `id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '反馈ID',
    `user_id`       BIGINT UNSIGNED     NOT NULL                 COMMENT '用户ID',
    `type`          VARCHAR(20)         NOT NULL DEFAULT 'other' COMMENT '反馈类型: bug-BUG, suggestion-建议, question-咨询, other-其他',
    `title`         VARCHAR(255)        NOT NULL DEFAULT ''      COMMENT '反馈标题',
    `content`       TEXT                NOT NULL                 COMMENT '反馈内容',
    `images`        TEXT                                     COMMENT '图片URL(JSON数组)',
    `contact`       VARCHAR(128)        NOT NULL DEFAULT ''      COMMENT '联系方式',
    `status`        TINYINT UNSIGNED    NOT NULL DEFAULT 0       COMMENT '状态: 0-待处理, 1-处理中, 2-已处理, 3-已关闭',
    `reply_content` TEXT                                     COMMENT '回复内容',
    `reply_user_id` BIGINT UNSIGNED     NULL                     COMMENT '回复人ID',
    `reply_time`    DATETIME            NULL                     COMMENT '回复时间',
    `create_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`       TINYINT(1)          NOT NULL DEFAULT 0       COMMENT '逻辑删除: 0-未删除, 1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_type` (`type`),
    KEY `idx_status` (`status`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户反馈表';

-- ============================================================
-- 6. 文件上传模块
-- ============================================================

-- -----------------------------------------------------------
-- 6.1 文件上传记录表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `file_upload`;
CREATE TABLE `file_upload` (
    `id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '文件ID',
    `user_id`       BIGINT UNSIGNED     NULL                     COMMENT '上传用户ID',
    `original_name` VARCHAR(255)        NOT NULL                 COMMENT '原始文件名',
    `file_name`     VARCHAR(255)        NOT NULL                 COMMENT '存储文件名',
    `file_path`     VARCHAR(512)        NOT NULL                 COMMENT '文件路径',
    `file_url`      VARCHAR(512)        NOT NULL                 COMMENT '访问URL',
    `file_size`     BIGINT UNSIGNED     NOT NULL DEFAULT 0       COMMENT '文件大小(字节)',
    `file_type`     VARCHAR(64)         NOT NULL                 COMMENT '文件MIME类型',
    `file_ext`      VARCHAR(20)         NOT NULL                 COMMENT '文件扩展名',
    `storage_type`  VARCHAR(20)         NOT NULL DEFAULT 'local' COMMENT '存储类型: local-本地, oss-对象存储',
    `biz_type`      VARCHAR(32)         NOT NULL DEFAULT ''      COMMENT '业务类型: avatar-头像, post-帖子, recognition-识别',
    `status`        TINYINT UNSIGNED    NOT NULL DEFAULT 1       COMMENT '状态: 0-禁用, 1-正常',
    `create_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`       TINYINT(1)          NOT NULL DEFAULT 0       COMMENT '逻辑删除: 0-未删除, 1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_biz_type` (`biz_type`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='文件上传记录表';

-- ============================================================
-- 7. 系统配置模块
-- ============================================================

-- -----------------------------------------------------------
-- 7.1 系统配置表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
    `id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '配置ID',
    `config_key`    VARCHAR(128)        NOT NULL                 COMMENT '配置键',
    `config_value`  TEXT                NOT NULL                 COMMENT '配置值',
    `config_type`   VARCHAR(20)         NOT NULL DEFAULT 'string' COMMENT '配置类型: string-字符串, number-数字, json-JSON, boolean-布尔',
    `remark`        VARCHAR(512)        NOT NULL DEFAULT ''      COMMENT '备注',
    `create_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统配置表';

-- -----------------------------------------------------------
-- 7.2 操作日志表
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `sys_operation_log`;
CREATE TABLE `sys_operation_log` (
    `id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT  COMMENT '日志ID',
    `user_id`       BIGINT UNSIGNED     NULL                     COMMENT '操作用户ID',
    `user_type`     VARCHAR(20)         NOT NULL DEFAULT 'admin' COMMENT '用户类型: admin-管理员, wx_user-小程序用户',
    `module`        VARCHAR(64)         NOT NULL                 COMMENT '操作模块',
    `operation`     VARCHAR(128)        NOT NULL                 COMMENT '操作内容',
    `method`        VARCHAR(255)        NOT NULL                 COMMENT '请求方法',
    `request_url`   VARCHAR(512)        NOT NULL                 COMMENT '请求URL',
    `request_params` TEXT                                    COMMENT '请求参数',
    `response_data` TEXT                                    COMMENT '响应数据',
    `ip`            VARCHAR(50)         NOT NULL DEFAULT ''      COMMENT '操作IP',
    `status`        TINYINT UNSIGNED    NOT NULL DEFAULT 1       COMMENT '状态: 0-失败, 1-成功',
    `error_msg`     TEXT                                     COMMENT '错误信息',
    `cost_time`     INT UNSIGNED        NOT NULL DEFAULT 0       COMMENT '耗时(毫秒)',
    `create_time`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_module` (`module`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='操作日志表';

-- ============================================================
-- 8. 初始数据
-- ============================================================

-- -----------------------------------------------------------
-- 8.1 插入默认管理员(密码: admin123, 需要BCrypt加密)
-- -----------------------------------------------------------
INSERT INTO `sys_admin` (`username`, `password`, `name`, `email`, `role`, `status`)
VALUES ('admin', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', '超级管理员', 'admin@plantdisease.com', 'super_admin', 1);

-- -----------------------------------------------------------
-- 8.2 插入作物分类初始数据
-- -----------------------------------------------------------
INSERT INTO `crop_category` (`name`, `description`, `sort_order`) VALUES
('粮食作物', '包括水稻、小麦、玉米等主要粮食作物', 1),
('蔬菜', '包括叶菜类、根茎类、茄果类等蔬菜', 2),
('水果', '包括苹果、柑橘、葡萄等水果', 3),
('经济作物', '包括棉花、油料、茶叶等经济作物', 4),
('花卉', '包括观赏花卉和绿化植物', 5);

-- -----------------------------------------------------------
-- 8.3 插入系统配置初始数据
-- -----------------------------------------------------------
INSERT INTO `sys_config` (`config_key`, `config_value`, `config_type`, `remark`) VALUES
('site_name', '植物病虫害识别系统', 'string', '系统名称'),
('site_logo', '', 'string', '系统Logo'),
('upload_max_size', '10485760', 'number', '上传文件最大大小(字节)'),
('upload_allowed_types', '["jpg","jpeg","png","gif","bmp"]', 'json', '允许上传的文件类型'),
('recognition_model_url', 'http://localhost:5000/predict', 'string', '识别模型服务地址'),
('wx_app_id', '', 'string', '微信小程序AppID'),
('wx_app_secret', '', 'string', '微信小程序AppSecret');

-- ============================================================
-- 9. 创建视图(便于查询)
-- ============================================================

-- -----------------------------------------------------------
-- 9.1 用户统计视图
-- -----------------------------------------------------------
CREATE OR REPLACE VIEW `v_user_stats` AS
SELECT
    u.id AS user_id,
    u.nickname,
    u.avatar_url,
    u.total_recognitions,
    u.recognition_days,
    u.post_count,
    u.comment_count,
    u.like_count,
    u.last_recognition_date,
    u.create_time
FROM `wx_user` u
WHERE u.deleted = 0;

-- -----------------------------------------------------------
-- 9.2 帖子详情视图
-- -----------------------------------------------------------
CREATE OR REPLACE VIEW `v_post_detail` AS
SELECT
    p.id,
    p.user_id,
    p.title,
    p.content,
    p.images,
    p.recognized_crop,
    p.likes_count,
    p.comments_count,
    p.views_count,
    p.status,
    p.create_time,
    p.update_time,
    u.nickname AS user_nickname,
    u.avatar_url AS user_avatar
FROM `forum_post` p
LEFT JOIN `wx_user` u ON p.user_id = u.id
WHERE p.deleted = 0;

-- -----------------------------------------------------------
-- 9.3 病虫害统计视图
-- -----------------------------------------------------------
CREATE OR REPLACE VIEW `v_disease_stats` AS
SELECT
    d.id,
    d.name,
    d.common_name,
    d.type,
    c.name AS category_name,
    (SELECT COUNT(*) FROM recognition_record r WHERE r.result_id = d.id AND r.deleted = 0) AS recognition_count
FROM `disease` d
LEFT JOIN `crop_category` c ON d.category_id = c.id
WHERE d.deleted = 0;

-- ============================================================
-- 10. 存储过程(常用操作)
-- ============================================================

-- -----------------------------------------------------------
-- 10.1 更新用户识别统计
-- -----------------------------------------------------------
DELIMITER //
CREATE PROCEDURE `sp_update_user_recognition_stats`(IN p_user_id BIGINT)
BEGIN
    DECLARE v_total INT DEFAULT 0;
    DECLARE v_days INT DEFAULT 0;

    -- 计算总识别次数
    SELECT COUNT(*) INTO v_total
    FROM recognition_record
    WHERE user_id = p_user_id AND deleted = 0;

    -- 计算识别天数(去重)
    SELECT COUNT(DISTINCT DATE(create_time)) INTO v_days
    FROM recognition_record
    WHERE user_id = p_user_id AND deleted = 0;

    -- 更新用户表
    UPDATE wx_user
    SET total_recognitions = v_total,
        recognition_days = v_days,
        last_recognition_date = CURDATE()
    WHERE id = p_user_id;
END //
DELIMITER ;

-- -----------------------------------------------------------
-- 10.2 更新帖子统计
-- -----------------------------------------------------------
DELIMITER //
CREATE PROCEDURE `sp_update_post_stats`(IN p_post_id BIGINT)
BEGIN
    DECLARE v_likes INT DEFAULT 0;
    DECLARE v_comments INT DEFAULT 0;

    -- 计算点赞数
    SELECT COUNT(*) INTO v_likes
    FROM forum_like
    WHERE target_id = p_post_id AND target_type = 'post';

    -- 计算评论数
    SELECT COUNT(*) INTO v_comments
    FROM forum_comment
    WHERE post_id = p_post_id AND deleted = 0;

    -- 更新帖子表
    UPDATE forum_post
    SET likes_count = v_likes,
        comments_count = v_comments
    WHERE id = p_post_id;
END //
DELIMITER ;

-- ============================================================
-- SQL文件结束
-- ============================================================
