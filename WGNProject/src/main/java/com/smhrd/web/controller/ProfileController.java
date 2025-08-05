
package com.smhrd.web.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.dto.FeedWithImgDTO;
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
    public String myPage(HttpSession session, Model model) {
        
    	// 로그인 체크
    	boolean loginCheck = memberService.loginCheck(session);
		
		if (!loginCheck) {
			return "redirect:/member/login";
		}
    	
		// 세션에서 로그인 정보 가져오기
    	t_member logined = (t_member) session.getAttribute("member");
    	String mb_id = logined.getMb_id();

        // 내 아이디로 프로필 페이지 보여주기
        return "redirect:/profile/" + mb_id;
    }
    
    @GetMapping("/{mb_id}")
    public String showMyPage(@PathVariable String mb_id, HttpSession session, Model model) {
    	
    	// 로그인 체크
    	boolean loginCheck = memberService.loginCheck(session);
		
		if (!loginCheck) {
			return "redirect:/member/login";
		}
		
		// 세션에서 로그인한 사용자 정보 가져오기
        t_member logined = (t_member) session.getAttribute("member");
     	String myId = logined.getMb_id();
        
        // 마이페이지 여부 확인
        boolean isMyPage = logined.getMb_id().equals(mb_id);
        model.addAttribute("isMypage", isMyPage);
        
        // 해당 사용자가 마이페이지 주인을 팔로우하고 있는지 여부를 체크하는 메서드
 		boolean isFollowing = memberService.isFollowing(myId, mb_id);
 		
 		model.addAttribute("isFollowing", isFollowing);
 		model.addAttribute("mb_id", mb_id);
     	
        // 프로필 정보 저장
        ProfileDTO profile = profileService.getProfileInfo(mb_id);
        model.addAttribute("profile", profile);
        
        // 사용자가 작성한 피드 리스트 저장
        List<FeedWithImgDTO> feeds = feedService.getFeedByMemId(mb_id);
        
        // 사용자의 피드 리스트를 넣으면 각 피드 별로 이미지 리스트가 포함된 DTO를 생성해주는 메서드
        List<FeedWithImgDTO> feedDTOList = feedService.getImgUrls(feeds);
    
        for (FeedWithImgDTO feed : feedDTOList) {
            System.out.println("feed_idx in controller = " + feed.getFeed_idx());
        }
        
	    model.addAttribute("feedDTOList", feedDTOList);
	    
        return "profile/myPage";
    }
	
	@GetMapping("/notifications")
	public String showNotifications() {
	return "profile/notifications";
	
}
	
}
