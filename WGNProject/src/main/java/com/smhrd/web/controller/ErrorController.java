package com.smhrd.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class ErrorController {

	@GetMapping("/error")
	public String handleError() {
		System.out.println("이담님이다");
		System.out.println("이담님 접니다 보이시나요?");
		return "error/error";
	}
	
	
}
