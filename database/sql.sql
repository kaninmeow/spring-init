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