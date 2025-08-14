package com.smhrd.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.smhrd.web.service.WordcloudService;

@SpringBootApplication
public class YgnProjectApplication {

   @Autowired
    private WordcloudService wordcloudService;
   
    public static void main(String[] args) {
       // wordcloudService.updateEmpty();
        System.out.println("updateEmpty() 실행 완료");
        SpringApplication.run(YgnProjectApplication.class, args);
    }

}
