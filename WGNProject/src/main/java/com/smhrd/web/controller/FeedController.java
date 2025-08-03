package com.smhrd.web.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.CloudinaryService;
import com.smhrd.web.service.FeedService;
import com.smhrd.web.service.MemberService;

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

    FeedController(CloudinaryService cloudinaryService) {
        this.cloudinaryService = cloudinaryService;
    }
	
	@GetMapping("/addFeed")
	public String goAddFeed(HttpSession session) {
		
		boolean loginCheck = memberService.loginCheck(session);
		
		if (!loginCheck) {
			return "member/login";
		}
		
		return "feed/addFeed";
	}
	
	@PostMapping("/upload")
	public String uploadFeed(@ModelAttribute t_feed feed,
	                         @RequestParam("files") List<MultipartFile> files,
	                         HttpSession session) {

		// 세션에서 멤버 정보 가져오기
		
	    t_member member = (t_member) session.getAttribute("member");
	    
	    // 멤버 정보가 없다면 로그인 페이지로 리다이렉트
	    if (member == null) {
	        return "redirect:/login";
	    }

	    String mb_id = member.getMb_id();

	    feed.setMb_id(mb_id);
	    feed.setRes_idx(11010243); // 임시값
	    feed.setFeed_likes(0);

	    try {
	        feedService.saveFeed(feed, files);
	    } catch (IOException e) {
	    	log.error("파일 업로드 중 오류 발생", e); 
	    }

	    return "redirect:/";
	}

	
}
