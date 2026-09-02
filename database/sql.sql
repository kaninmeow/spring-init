DROP TABLE IF EXISTS `admin_user`;
CREATE TABLE `admin_user`
(
    `id`              BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键 用户ID',
    `username`        VARCHAR(64)  NOT NULL COMMENT '用户名',
    `password`        VARCHAR(128)  NOT NULL COMMENT '密码（MD5）',
    `avatar`          VARCHAR(512) DEFAULT NULL COMMENT '头像URL',
    `email`           VARCHAR(128) DEFAULT NULL COMMENT '邮箱',
    `phone`           VARCHAR(20)  DEFAULT NULL COMMENT '电话',
    `name`            VARCHAR(20)  DEFAULT NULL COMMENT '姓名',
    `role`            VARCHAR(32)  NOT NULL DEFAULT 'USER' COMMENT '权限角色，逻辑外键关联角色表',
    `status`          TINYINT      NOT NULL DEFAULT 1 COMMENT '状态 0：禁用 1：正常',
    `last_login_time` DATETIME     DEFAULT NULL COMMENT '最后登录时间',
    `last_login_ip`   VARCHAR(64)  DEFAULT NULL COMMENT '最后登录IP',
    `create_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`         TINYINT      NOT NULL DEFAULT 0 COMMENT '逻辑删除 0：未删除 1：已删除',

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    KEY `idx_email` (`email`),
    KEY `idx_phone` (`phone`),
    KEY `idx_role` (`role`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '用户表';


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
