package com.plantdisease.plantdiseasejavares.controller;

import com.plantdisease.plantdiseasejavares.common.Result;
import com.plantdisease.plantdiseasejavares.common.ResultCode;
import com.plantdisease.plantdiseasejavares.util.AliOssUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/common")
public class CommonController {

    @Autowired
    AliOssUtil aliOssUtil;

    /**
     * 文件上传接口
     */
    @PostMapping("/upload")
    public Result<String> upload(MultipartFile file) {

        try {

            // 上传文件
            String url = aliOssUtil.upload(file);

            return Result.success(url);

        } catch (Exception e) {

            e.printStackTrace();

            return Result.error(ResultCode.FILE_UPLOAD_ERROR);
        }
    }
}