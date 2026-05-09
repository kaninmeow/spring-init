package com.plantdisease.plantdiseasejavares;

import com.plantdisease.plantdiseasejavares.util.JwtUtil;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest
class PlantDiseaseJavaResApplicationTests {

    @Autowired
    private JwtUtil jwtUtil;

    @Test
    void contextLoads() {
    }

    @Test
    void testJwtGenerateAndValidate() {
        String token = jwtUtil.generateToken(1L, "admin", "super_admin");
        assertNotNull(token);
        assertTrue(jwtUtil.validate(token));
    }
}
