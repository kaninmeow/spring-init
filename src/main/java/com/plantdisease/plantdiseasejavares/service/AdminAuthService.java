package com.plantdisease.plantdiseasejavares.service;

import com.plantdisease.plantdiseasejavares.pojo.dto.LoginDTO;
import com.plantdisease.plantdiseasejavares.pojo.dto.RegisterDTO;
import com.plantdisease.plantdiseasejavares.pojo.vo.AdminInfoVO;
import com.plantdisease.plantdiseasejavares.pojo.vo.AdminLoginVO;

/**
 * 管理员认证服务
 *
 * @author plant-disease
 */
public interface AdminAuthService {

    /**
     * 管理员登录
     *
     * @param loginDTO 登录参数
     * @param ip       客户端IP
     * @return 登录结果
     */
    AdminLoginVO login(LoginDTO loginDTO, String ip);

    /**
     * 管理员注册
     *
     * @param registerDTO 注册参数
     */
    void register(RegisterDTO registerDTO);

    /**
     * 获取管理员信息
     *
     * @param adminId 管理员ID
     * @return 管理员信息
     */
    AdminInfoVO getAdminInfo(Long adminId);
}
