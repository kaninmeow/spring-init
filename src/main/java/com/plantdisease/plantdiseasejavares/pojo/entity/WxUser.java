package com.plantdisease.plantdiseasejavares.pojo.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 微信小程序用户实体
 *
 * @author plant-disease
 */
@Data
@TableName("wx_user")
public class WxUser {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String openid;

    private String unionId;

    private String sessionKey;

    private String nickname;

    private String avatar;

    private String avatarUrl;

    private Integer gender;

    private String country;

    private String province;

    private String city;

    private String district;

    private String language;

    private String phone;

    private String signature;

    private String role;

    private Integer status;

    private Integer totalRecognitions;

    private Integer recognitionDays;

    private Integer postCount;

    private Integer commentCount;

    private Integer likeCount;

    private LocalDate lastRecognitionDate;

    private LocalDateTime lastLoginTime;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;
}
