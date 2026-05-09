package com.plantdisease.plantdiseasejavares.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.plantdisease.plantdiseasejavares.common.ResultCode;
import com.plantdisease.plantdiseasejavares.pojo.dto.LoginDTO;
import com.plantdisease.plantdiseasejavares.pojo.dto.RegisterDTO;
import com.plantdisease.plantdiseasejavares.pojo.entity.SysAdmin;
import com.plantdisease.plantdiseasejavares.exception.BusinessException;
import com.plantdisease.plantdiseasejavares.mapper.SysAdminMapper;
import com.plantdisease.plantdiseasejavares.service.AdminAuthService;
import com.plantdisease.plantdiseasejavares.util.JwtUtil;
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

    private final SysAdminMapper sysAdminMapper;
    private final JwtUtil jwtUtil;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Override
    public AdminLoginVO login(LoginDTO loginDTO, String ip) {
        SysAdmin admin = sysAdminMapper.selectOne(
                new LambdaQueryWrapper<SysAdmin>()
                        .eq(SysAdmin::getUsername, loginDTO.getUsername())
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
        sysAdminMapper.updateById(admin);

        // 生成 token
        String token = jwtUtil.generateToken(admin.getId(), admin.getUsername(), admin.getRole());

        log.info("管理员登录成功: username={}", admin.getUsername());

        return AdminLoginVO.builder()
                .token(token)
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
        Long count = sysAdminMapper.selectCount(
                new LambdaQueryWrapper<SysAdmin>()
                        .eq(SysAdmin::getUsername, registerDTO.getUsername())
        );
        if (count > 0) {
            throw new BusinessException(ResultCode.USERNAME_EXISTS);
        }

        SysAdmin admin = new SysAdmin();
        admin.setUsername(registerDTO.getUsername());
        admin.setPassword(passwordEncoder.encode(registerDTO.getPassword()));
        admin.setName(registerDTO.getName() != null ? registerDTO.getName() : "");
        admin.setEmail(registerDTO.getEmail() != null ? registerDTO.getEmail() : "");
        admin.setPhone(registerDTO.getPhone() != null ? registerDTO.getPhone() : "");
        admin.setRole("admin");
        admin.setStatus(1);

        sysAdminMapper.insert(admin);
        log.info("管理员注册成功: username={}", admin.getUsername());
    }

    @Override
    public AdminInfoVO getAdminInfo(Long adminId) {
        SysAdmin admin = sysAdminMapper.selectById(adminId);
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
