package com.smhrd.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.MemberService;

@RequestMapping("/member")
@Controller
public class MemberController {

	@Autowired
	MemberService memberService;
	
	@GetMapping("/join")
	public String showJoinForm() {
		return "member/join";
	}
	
	@PostMapping("/joinMember")
	public String join(t_member mem, @RequestParam("mb_pw_check") String pwCheck) {
		boolean joinCheck = memberService.join(mem, pwCheck);
		
		if (joinCheck) {
			return "member/joinSuccess";
		}else {
			return "home"; // 수정 필요
		}
		
	}
	
	@GetMapping("/checkId")
	@ResponseBody
	public String checkId(@RequestParam String inputId) {
		String idCheckResult = memberService.checkId(inputId);
		return idCheckResult;
	}
	
	@GetMapping("/login")
	public String login() {
		return "home";
		
	}
	
}
