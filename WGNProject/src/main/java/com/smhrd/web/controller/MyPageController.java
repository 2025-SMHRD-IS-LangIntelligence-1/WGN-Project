
package com.smhrd.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.smhrd.web.dto.MyPageDTO;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.mapper.MemberMapper;
import com.smhrd.web.service.MemberService;
import com.smhrd.web.service.MyPageService;

import jakarta.servlet.http.HttpSession;

@RequestMapping("/myPage")
@Controller
public class MyPageController {

	@Autowired
	MemberMapper myPageMapper;
	@Autowired
	MyPageService myPageService;
	
    @GetMapping
    public String showMyPage(HttpSession session, Model model) {
        // 세션에서 로그인한 사용자 정보 가져오기
        t_member logined = (t_member) session.getAttribute("member");

        // 로그인 안 되어 있으면 로그인 페이지로 리다이렉트
        if (logined == null) {
            return "redirect:/login";
        }

        MyPageDTO myPageDTO = myPageService.showMyPage(logined.getMb_id());
        return "myPage/myPage";
    }
	
	@GetMapping("/notifications")
	public String showNotifications() {
		return "myPage/notifications";
	}
	
	
}
