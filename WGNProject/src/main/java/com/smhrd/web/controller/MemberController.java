package com.smhrd.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.MemberService;
import com.smhrd.web.service.ProfileService;

import jakarta.servlet.http.HttpSession;

@RequestMapping("/member")
@Controller
public class MemberController {

    private final HomeController homeController;

	@Autowired
	MemberService memberService;
	@Autowired
	ProfileService profileService;

    MemberController(HomeController homeController) {
        this.homeController = homeController;
    }
	
	@GetMapping("/join")
	public String showJoin() {
		return "member/join";
	}
	
	@PostMapping("/joinMember")
	public String join(t_member mem, @RequestParam("mb_pw_check") String pwCheck) {
		boolean joinCheck = memberService.join(mem, pwCheck);
		
		if (joinCheck) {
			return "redirect:/";
		}
		return "member/join";
		
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
	public String login(t_member mem, HttpSession session, Model model) {
	    t_member member = memberService.login(mem);
	    ProfileDTO profile = profileService.showMyPage(mem.getMb_id());
	    
	    if (member != null) {
	        session.setAttribute("member", member);  // 멤버 정보 세션에 저장
	        session.setAttribute("profile", profile); // 프로필 정보 세션에 저장
	        return "redirect:/";
	    } else {
	        model.addAttribute("msg", "아이디 또는 비밀번호가 올바르지 않습니다.");
	        return "member/login";  // 로그인 실패 시 다시 로그인 페이지로
	    }
	}
	
}
