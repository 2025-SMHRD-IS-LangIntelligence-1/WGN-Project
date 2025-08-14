package com.smhrd.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.smhrd.web.service.WordcloudService;

@SpringBootApplication
public class YgnProjectApplication implements CommandLineRunner {

    @Autowired
    private WordcloudService wordcloudService;

    public static void main(String[] args) {
        SpringApplication.run(YgnProjectApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        wordcloudService.updateEmpty();
        System.out.println("updateEmpty() 실행 완료");
    }
}
