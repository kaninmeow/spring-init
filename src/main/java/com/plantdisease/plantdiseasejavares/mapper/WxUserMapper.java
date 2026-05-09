package com.plantdisease.plantdiseasejavares.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.plantdisease.plantdiseasejavares.pojo.entity.WxUser;
import org.apache.ibatis.annotations.Mapper;

/**
 * 微信用户 Mapper
 *
 * @author plant-disease
 */
@Mapper
public interface WxUserMapper extends BaseMapper<WxUser> {
}
