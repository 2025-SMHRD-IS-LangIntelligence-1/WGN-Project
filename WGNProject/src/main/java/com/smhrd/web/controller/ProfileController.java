
package com.smhrd.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.ProfileService;

import jakarta.servlet.http.HttpSession;

@RequestMapping("/profile")
@Controller
public class ProfileController {

	@Autowired
	ProfileService profileService;
	
    @GetMapping
    public String showMyPage(HttpSession session, Model model) {
    	
    	// 세션에서 로그인한 사용자 정보 가져오기
        t_member logined = (t_member) session.getAttribute("member");
    	
    	// 로그인 안 되어 있으면 로그인 페이지로 리다이렉트
        if (logined == null) {
            return "redirect:/member/login";
        }

        ProfileDTO profileDTO = profileService.showMyPage(logined.getMb_id());
        model.addAttribute("profile", profileDTO);
        return "myPage/myPage";
    }
	
	@GetMapping("/{mb_id}")
	public String showOtherMemPage(String mb_id, HttpSession session, Model model) {

    	// 세션에서 로그인한 사용자 정보 가져오기
        t_member logined = (t_member) session.getAttribute("member");
    	
    	// 로그인 안 되어 있으면 로그인 페이지로 리다이렉트
        if (logined == null) {
            return "redirect:/member/login";
        }
		
        ProfileDTO profileDTO = profileService.showOtherMemPage(mb_id);
        return "myPage/{mb_id}";
	}
	
	
	@GetMapping("/notifications")
	public String showNotifications() {
		return "myPage/notifications";
	}
	
}
