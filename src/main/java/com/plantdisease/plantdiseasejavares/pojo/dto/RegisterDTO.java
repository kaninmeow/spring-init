package com.plantdisease.plantdiseasejavares.pojo.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 注册请求参数
 *
 * @author plant-disease
 */
@Data
@Schema(description = "注册请求参数")
public class RegisterDTO {

    @NotBlank(message = "用户名不能为空")
    @Size(min = 4, max = 64, message = "用户名长度4-64个字符")
    @Schema(description = "用户名", example = "admin2")
    private String username;

    @NotBlank(message = "密码不能为空")
    @Size(min = 6, max = 32, message = "密码长度6-32个字符")
    @Schema(description = "密码", example = "admin123")
    private String password;

    @Schema(description = "姓名", example = "管理员二号")
    private String name;

    @Schema(description = "邮箱", example = "admin2@plantdisease.com")
    private String email;

    @Schema(description = "手机号", example = "13800138000")
    private String phone;
}
