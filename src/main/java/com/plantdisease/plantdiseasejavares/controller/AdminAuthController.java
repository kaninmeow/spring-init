package com.plantdisease.plantdiseasejavares.controller;

import com.plantdisease.plantdiseasejavares.annotation.SkipJwtValidation;
import com.plantdisease.plantdiseasejavares.common.Result;
import com.plantdisease.plantdiseasejavares.pojo.dto.LoginDTO;
import com.plantdisease.plantdiseasejavares.pojo.dto.RegisterDTO;
import com.plantdisease.plantdiseasejavares.service.AdminAuthService;
import com.plantdisease.plantdiseasejavares.util.SecurityUtil;
import com.plantdisease.plantdiseasejavares.pojo.vo.AdminInfoVO;
import com.plantdisease.plantdiseasejavares.pojo.vo.AdminLoginVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 管理员认证控制器
 *
 * @author plant-disease
 */
@Tag(name = "管理员认证", description = "管理员登录、注册、信息查询")
@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminAuthController {

    private final AdminAuthService adminAuthService;

    /**
     *
     * 管理员登录
     * @param loginDTO
     * @param request
     * @return
     */
    @Operation(summary = "管理员登录")
    @PostMapping("/login")
    @SkipJwtValidation
    public Result<AdminLoginVO> login(@Valid @RequestBody LoginDTO loginDTO, HttpServletRequest request) {
        String ip = getClientIp(request);
        AdminLoginVO vo = adminAuthService.login(loginDTO, ip);
        return Result.success(vo);
    }

    /**
     * 管理员注册
     * @param registerDTO
     * @return
     */
    @Operation(summary = "管理员注册")
    @PostMapping("/register")
    @SkipJwtValidation
    public Result<Void> register(@Valid @RequestBody RegisterDTO registerDTO) {
        adminAuthService.register(registerDTO);
        return Result.success();
    }

    /**
     * 获取管理员信息
     * @param request
     * @return
     */
    @Operation(summary = "获取管理员信息")
    @GetMapping("/info")
    @SkipJwtValidation
    public Result<AdminInfoVO> info(HttpServletRequest request) {
        Long userId = SecurityUtil.getCurrentUserId(request);
        AdminInfoVO vo = adminAuthService.getAdminInfo(userId);
        return Result.success(vo);
    }

    /**
     * 管理员登出
     * @return
     */
    @Operation(summary = "管理员登出")
    @PostMapping("/logout")
    @SkipJwtValidation
    public Result<Void> logout() {
        return Result.success();
    }

    /**
     * 获取用户IP
     * @param request
     * @return
     */
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // 多个代理时取第一个
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }
}
