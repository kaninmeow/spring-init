package com.plantdisease.plantdiseasejavares.common;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 状态码枚举
 *
 * @author plant-disease
 */
@Getter
@AllArgsConstructor
public enum ResultCode {

    SUCCESS(200, "操作成功"),
    BAD_REQUEST(400, "请求参数错误"),
    UNAUTHORIZED(401, "未登录或token已过期"),
    FORBIDDEN(403, "没有操作权限"),
    NOT_FOUND(404, "资源不存在"),
    ERROR(500, "服务器内部错误"),

    USERNAME_EXISTS(1001, "用户名已存在"),
    USERNAME_OR_PASSWORD_ERROR(1002, "用户名或密码错误"),
    TOKEN_INVALID(1003, "token无效"),
    TOKEN_EXPIRED(1004, "token已过期"),
    ACCOUNT_DISABLED(1005, "账号已被禁用");

    private final int code;

    private final String message;
}
