package com.plantdisease.plantdiseasejavares.util;

import com.aliyun.oss.*;
import com.aliyun.oss.common.auth.CredentialsProvider;
import com.aliyun.oss.common.auth.DefaultCredentialProvider;
import com.aliyun.oss.common.comm.SignVersion;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.UUID;

@Component
public class AliOssUtil {

    @Value("${aliyun.oss.endpoint}")
    private String endpoint;

    @Value("${aliyun.oss.bucket-name}")
    private String bucketName;

    @Value("${aliyun.oss.region}")
    private String region;

    @Value("${aliyun.oss.access-key-id}")
    private String accessKeyId;

    @Value("${aliyun.oss.access-key-secret}")
    private String accessKeySecret;

    /**
     * 文件上传
     */
    public String upload(MultipartFile file) throws Exception {

        // 获取输入流
        InputStream inputStream = file.getInputStream();

        // 获取原始文件名
        String originalFilename = file.getOriginalFilename();

        // 文件后缀
        String suffix = originalFilename.substring(originalFilename.lastIndexOf("."));

        // 生成唯一文件名
        String fileName = UUID.randomUUID().toString().replace("-", "") + suffix;

        // OSS对象名称
        String objectName = "upload/" + fileName;

        // 创建凭证对象
        CredentialsProvider credentialsProvider =
                new DefaultCredentialProvider(accessKeyId, accessKeySecret);

        // 配置
        ClientBuilderConfiguration configuration =
                new ClientBuilderConfiguration();

        // V4签名
        configuration.setSignatureVersion(SignVersion.V4);

        // 创建 OSSClient
        OSS ossClient = OSSClientBuilder.create()
                .endpoint(endpoint)
                .credentialsProvider(credentialsProvider)
                .clientConfiguration(configuration)
                .region(region)
                .build();

        try {

            // 上传文件
            ossClient.putObject(bucketName, objectName, inputStream);

            // 返回访问路径
            return "https://" +
                    bucketName +
                    "." +
                    endpoint.replace("https://", "")
                    + "/" +
                    objectName;

        } finally {

            if (ossClient != null) {
                ossClient.shutdown();
            }

            inputStream.close();
        }
    }
}