package com.smhrd.web.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;



@Configuration
public class WebConfig implements WebMvcConfigurer {

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		// /resources/** 요청을 webapp/resources/ 경로에서 찾도록 설정
		registry.addResourceHandler("/resources/**")
		.addResourceLocations("file:src/main/webapp/resources/");
	}
}
	

