package com.plantdisease.plantdiseasejavares.util;

import jakarta.servlet.http.HttpServletRequest;

/**
 * 安全工具类，从 Request 中获取当前登录用户信息
 *
 * @author plant-disease
 */
public final class SecurityUtil {

    private static final String ATTR_USER_ID = "currentUserId";
    private static final String ATTR_USERNAME = "currentUsername";
    private static final String ATTR_ROLE = "currentRole";

    private SecurityUtil() {
    }

    public static Long getCurrentUserId(HttpServletRequest request) {
        Object userId = request.getAttribute(ATTR_USER_ID);
        return userId != null ? (Long) userId : null;
    }

    public static String getCurrentUsername(HttpServletRequest request) {
        Object username = request.getAttribute(ATTR_USERNAME);
        return username != null ? (String) username : null;
    }

    public static String getCurrentRole(HttpServletRequest request) {
        Object role = request.getAttribute(ATTR_ROLE);
        return role != null ? (String) role : null;
    }

    public static void setCurrentUser(HttpServletRequest request, Long userId, String username, String role) {
        request.setAttribute(ATTR_USER_ID, userId);
        request.setAttribute(ATTR_USERNAME, username);
        request.setAttribute(ATTR_ROLE, role);
    }
}
