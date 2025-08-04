package com.smhrd.web.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.smhrd.web.dto.FeedWithImgDTO;
import com.smhrd.web.dto.RestaurantDTO;
import com.smhrd.web.entity.t_comment;
import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.CloudinaryService;
import com.smhrd.web.service.FeedService;
import com.smhrd.web.service.MemberService;
import com.smhrd.web.service.RestaurantService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("feed")
@Controller
@Slf4j
public class FeedController {
	
	@Autowired
	FeedService feedService;
	@Autowired
	CloudinaryService cloudinaryService;
	@Autowired
	MemberService memberService;
	@Autowired
	RestaurantService restaurantService;

    FeedController(CloudinaryService cloudinaryService) {
        this.cloudinaryService = cloudinaryService;
    }
	
    @GetMapping
    public String feedDetail(@RequestParam("feed_idx") int feedIdx, Model model) {
        // feedIdx를 이용해 DB에서 피드 상세 데이터 조회
        FeedWithImgDTO feed = feedService.getFeedByFeedIdx(feedIdx);
        // 음식점 정보 가져오기
        int resIdx = feed.getRes_idx();
        RestaurantDTO resInfo = restaurantService.getByResIdx(resIdx);
        List<t_comment> comments = feedService.getCmtByFeedIdx(feedIdx);
        
        model.addAttribute("feed", feed);
        model.addAttribute("resInfo", resInfo);
        model.addAttribute("comments", comments);
        return "feed/feed";
    }
    
	@GetMapping("/addFeed")
	public String goAddFeed(HttpSession session) {
		
		// 로그인 되어 있는지 체크
				boolean loginCheck = memberService.loginCheck(session);
				
		// 로그인이 되어 있지 않으면 로그인 페이지로
		if (!loginCheck) {
			return "member/login";
		}	
		
		return "feed/addFeed";
	}
	
	@PostMapping("/upload")
	public String uploadFeed(@ModelAttribute t_feed feed,
	                         @RequestParam("files") List<MultipartFile> files,
	                         @RequestParam("res_idx") Integer res_idx,
	                         HttpSession session) {

		// 로그인 되어 있는지 체크
		boolean loginCheck = memberService.loginCheck(session);
		
		// 로그인이 되어 있지 않으면 로그인 페이지로
		if (!loginCheck) {
			return "member/login";
		}
		
		// 세션에서 멤버 정보 가져오기
		t_member member = (t_member) session.getAttribute("member");

	    String mb_id = member.getMb_id();
	    
	    feed.setMb_id(mb_id);
	    feed.setRes_idx(res_idx);

	    try {
	        feedService.saveFeed(feed, files);
	    } catch (IOException e) {
	    	log.error("파일 업로드 중 오류 발생", e); 
	    }

	    return "redirect:/";
	}
	
	@PostMapping("/comment")
	public String saveComment(@RequestParam("feed_idx") int feed_idx,
	                          @RequestParam("cmt_content") String cmt_content,
	                          HttpSession session,
	                          HttpServletRequest request,
	                          Model model) {

	    // 여기서 세션에서 로그인 유저 꺼냄
	    t_member logined = (t_member) session.getAttribute("member");

	    if (logined == null) {
	        return "redirect:/member/login";  // 로그인 안 된 경우
	    }

	    feedService.saveComment(feed_idx, cmt_content, logined);
	    
	    log.info("댓글 저장 완료");
	    
	    return "redirect:" + request.getHeader("Referer");
	}

	
	
}
