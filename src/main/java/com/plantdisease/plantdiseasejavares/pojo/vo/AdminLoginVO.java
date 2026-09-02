package com.plantdisease.plantdiseasejavares.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 管理员登录响应
 *
 * @author plant-disease
 */
@Data
@Builder
@Schema(description = "管理员登录响应")
public class AdminLoginVO {

    @Schema(description = "管理员ID")
    private Long id;

    @Schema(description = "用户名")
    private String username;

    @Schema(description = "姓名")
    private String name;

    @Schema(description = "头像URL")
    private String avatar;

    @Schema(description = "角色")
    private String role;

    @Schema(description = "最后登录时间")
    private LocalDateTime lastLoginTime;
}
