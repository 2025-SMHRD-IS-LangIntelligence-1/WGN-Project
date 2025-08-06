package com.smhrd.web.config;

import java.util.ArrayList;
import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import java.nio.charset.StandardCharsets;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    
	@Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");  // ★ webapp/resources 경로 매핑
    }
	
	@Bean
	public RestTemplate restTemplate() {
	    RestTemplate restTemplate = new RestTemplate();

	    // UTF-8 인코딩 지원을 위한 message converter 설정
	    List<HttpMessageConverter<?>> messageConverters = new ArrayList<>();
	    StringHttpMessageConverter stringConverter = new StringHttpMessageConverter(StandardCharsets.UTF_8);
	    messageConverters.add(stringConverter);
	    messageConverters.add(new MappingJackson2HttpMessageConverter());
	    restTemplate.setMessageConverters(messageConverters);

	    return restTemplate;
	}
	
}