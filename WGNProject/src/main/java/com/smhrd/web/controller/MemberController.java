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

import jakarta.servlet.http.HttpSession;
import jakarta.websocket.Session;

@RequestMapping("/member")
@Controller
public class MemberController {

	@Autowired
	MemberService memberService;
	
	@GetMapping("/join")
	public String showJoin() {
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

	@GetMapping("/checkNick")
	@ResponseBody
	public String checkNick(@RequestParam String inputNick) {
		String NickCheckResult = memberService.checkNick(inputNick);
		return NickCheckResult;
	}
	
	@GetMapping("/login")
	public String goLogin() {
		return "member/login";	
	}
	
	@PostMapping("/loginMember")
	public String login(t_member mem, HttpSession session) {
		t_member member = memberService.login(mem);
		session.setAttribute("member", member);
		return "member/loginSuccess";
	}
	
}
