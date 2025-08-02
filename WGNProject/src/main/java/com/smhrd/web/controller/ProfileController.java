
package com.smhrd.web.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.dto.FeedWithImgDTO;
import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.FeedService;
import com.smhrd.web.service.MemberService;
import com.smhrd.web.service.ProfileService;

import jakarta.servlet.http.HttpSession;

@RequestMapping("/profile")
@Controller
public class ProfileController {

	@Autowired
	ProfileService profileService;
	@Autowired
	FeedService feedService;
	@Autowired
	MemberService memberService;
	
    @GetMapping("/myPage")
    public String showMyPage(HttpSession session, Model model) {
    	
    	// 로그인 체크
    	boolean loginCheck = memberService.loginCheck(session);
		
		if (!loginCheck) {
			return "member/login";
		}
		
		// 세션에서 로그인한 사용자 정보 가져오기
        t_member logined = (t_member) session.getAttribute("member");
        
        // 프로필 정보 저장
        ProfileDTO profile = profileService.showMyPage(logined.getMb_id());
        model.addAttribute("profile", profile);
        
        // 사용자가 작성한 피드 리스트 저장
        List<t_feed> feeds = feedService.showFeedByMemId(logined.getMb_id());
        
        // 사용자의 피드 리스트를 넣으면 각 피드 별로 이미지 리스트가 포함된 DTO를 생성해주는 메서드
        List<FeedWithImgDTO> feedDTOList = feedService.getImgUrls(feeds);
        
	    model.addAttribute("feedDTOList", feedDTOList);
	    
        return "profile/myPage";
    }
	
	@GetMapping("/{mb_id}")
	public String showOtherMemPage(String mb_id, HttpSession session, Model model) {

    	// 로그인 체크
    	boolean loginCheck = memberService.loginCheck(session);
		
		if (!loginCheck) {
			return "member/login";
		}
		
    	// 세션에서 로그인한 사용자 정보 가져오기
        t_member logined = (t_member) session.getAttribute("member");
		
        ProfileDTO profile = profileService.showOtherMemPage(mb_id);
        return "myPage/{mb_id}";
	}
	
	
	// 사용자 알림 관련 컨트롤러, 현재 안씀
	
	// @GetMapping("/notifications")
	// public String showNotifications() {
	//	return "myPage/notifications";
	// }
	
}
