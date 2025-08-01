package com.smhrd.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.smhrd.web.entity.t_member;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/")
public class HomeController {

	@GetMapping  // 홈 페이지 매핑 예시
	public String showHome(HttpSession session, Model model) {
	    t_member logined = (t_member) session.getAttribute("member");
	    System.out.println("[홈 페이지] session member: " + logined); 
	    return "home";  // 뷰 이름
	}
	
}
