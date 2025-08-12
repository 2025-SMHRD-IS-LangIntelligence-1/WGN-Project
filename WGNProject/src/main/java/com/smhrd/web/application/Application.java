package com.smhrd.web.application;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.smhrd.web.service.WordcloudService;

import org.springframework.boot.CommandLineRunner;
import org.springframework.beans.factory.annotation.Autowired;

@SpringBootApplication
public class Application implements CommandLineRunner {

    @Autowired
    private WordcloudService wordcloudService;

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
    	// wordcloudService.updateEmpty();
        System.out.println("updateEmpty() 실행 완료");
    }
}
