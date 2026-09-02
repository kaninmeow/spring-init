package com.plantdisease.plantdiseasejavares.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.plantdisease.plantdiseasejavares.common.ResultCode;
import com.plantdisease.plantdiseasejavares.pojo.dto.LoginDTO;
import com.plantdisease.plantdiseasejavares.pojo.dto.RegisterDTO;
import com.plantdisease.plantdiseasejavares.pojo.entity.AdminUser;
import com.plantdisease.plantdiseasejavares.exception.BusinessException;
import com.plantdisease.plantdiseasejavares.mapper.AdminUserMapper;
import com.plantdisease.plantdiseasejavares.service.AdminAuthService;
import com.plantdisease.plantdiseasejavares.pojo.vo.AdminInfoVO;
import com.plantdisease.plantdiseasejavares.pojo.vo.AdminLoginVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

/**
 * 管理员认证服务实现
 *
 * @author plant-disease
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AdminAuthServiceImpl implements AdminAuthService {

    private final AdminUserMapper adminUserMapper;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Override
    public AdminLoginVO login(LoginDTO loginDTO, String ip) {
        AdminUser admin = adminUserMapper.selectOne(
                new LambdaQueryWrapper<AdminUser>().eq(AdminUser::getUsername, loginDTO.getUsername())
        );

        if (admin == null || !passwordEncoder.matches(loginDTO.getPassword(), admin.getPassword())) {
            throw new BusinessException(ResultCode.USERNAME_OR_PASSWORD_ERROR);
        }

        if (admin.getStatus() == 0) {
            throw new BusinessException(ResultCode.ACCOUNT_DISABLED);
        }

        // 更新登录信息
        admin.setLastLoginTime(LocalDateTime.now());
        admin.setLastLoginIp(ip);
        adminUserMapper.updateById(admin);

        log.info("管理员登录成功: username={}", admin.getUsername());

        return AdminLoginVO.builder()
                .id(admin.getId())
                .username(admin.getUsername())
                .name(admin.getName())
                .avatar(admin.getAvatar())
                .role(admin.getRole())
                .lastLoginTime(admin.getLastLoginTime())
                .build();
    }

    @Override
    public void register(RegisterDTO registerDTO) {
        // 检查用户名是否已存在
        Long count = adminUserMapper.selectCount(
                new LambdaQueryWrapper<AdminUser>()
                        .eq(AdminUser::getUsername, registerDTO.getUsername())
        );
        if (count > 0) {
            throw new BusinessException(ResultCode.USERNAME_EXISTS);
        }

        AdminUser admin = new AdminUser();
        admin.setUsername(registerDTO.getUsername());
        admin.setPassword(passwordEncoder.encode(registerDTO.getPassword()));
        admin.setName(registerDTO.getName() != null ? registerDTO.getName() : "");
        admin.setEmail(registerDTO.getEmail() != null ? registerDTO.getEmail() : "");
        admin.setPhone(registerDTO.getPhone() != null ? registerDTO.getPhone() : "");
        admin.setRole("admin");
        admin.setStatus(1);

        adminUserMapper.insert(admin);
        log.info("管理员注册成功: username={}", admin.getUsername());
    }

    @Override
    public AdminInfoVO getAdminInfo(Long adminId) {
        AdminUser admin = adminUserMapper.selectById(adminId);
        if (admin == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "管理员不存在");
        }

        return AdminInfoVO.builder()
                .id(admin.getId())
                .username(admin.getUsername())
                .name(admin.getName())
                .email(admin.getEmail())
                .phone(admin.getPhone())
                .avatar(admin.getAvatar())
                .role(admin.getRole())
                .status(admin.getStatus())
                .lastLoginTime(admin.getLastLoginTime())
                .createTime(admin.getCreateTime())
                .build();
    }
}
