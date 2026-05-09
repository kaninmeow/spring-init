package com.plantdisease.plantdiseasejavares.interceptor;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.plantdisease.plantdiseasejavares.common.Result;
import com.plantdisease.plantdiseasejavares.common.ResultCode;
import com.plantdisease.plantdiseasejavares.util.JwtUtil;
import com.plantdisease.plantdiseasejavares.util.SecurityUtil;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * JWT 校验拦截器
 *
 * @author plant-disease
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class JwtInterceptor implements HandlerInterceptor {

    private static final String AUTHORIZATION_HEADER = "Authorization";
    private static final String BEARER_PREFIX = "Bearer ";

    private final JwtUtil jwtUtil;
    private final ObjectMapper objectMapper;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // OPTIONS 请求直接放行
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        String authHeader = request.getHeader(AUTHORIZATION_HEADER);
        if (!StringUtils.hasText(authHeader) || !authHeader.startsWith(BEARER_PREFIX)) {
            writeUnauthorized(response, ResultCode.UNAUTHORIZED);
            return false;
        }

        String token = authHeader.substring(BEARER_PREFIX.length());
        if (!jwtUtil.validate(token)) {
            writeUnauthorized(response, ResultCode.TOKEN_INVALID);
            return false;
        }

        Claims claims = jwtUtil.parseToken(token);
        Long userId = claims.get("userId", Long.class);
        String username = claims.getSubject();
        String role = claims.get("role", String.class);

        SecurityUtil.setCurrentUser(request, userId, username, role);
        return true;
    }

    private void writeUnauthorized(HttpServletResponse response, ResultCode resultCode) throws Exception {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(Result.error(resultCode)));
    }
}
