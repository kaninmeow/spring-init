package com.plantdisease.plantdiseasejavares.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.plantdisease.plantdiseasejavares.pojo.entity.AdminUser;
import org.apache.ibatis.annotations.Mapper;

/**
 * 系统管理员 Mapper
 *
 * @author plant-disease
 */
@Mapper
public interface AdminUserMapper extends BaseMapper<AdminUser> {
}
