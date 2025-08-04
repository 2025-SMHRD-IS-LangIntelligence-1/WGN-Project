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

	@GetMapping  
	public String goHome(HttpSession session, Model model) {
	    t_member logined = (t_member) session.getAttribute("member");
	    return "home"; 
	}
	
}
