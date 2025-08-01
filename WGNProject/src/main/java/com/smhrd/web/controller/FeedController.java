package com.smhrd.web.controller;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.CloudinaryService;
import com.smhrd.web.service.FeedService;

import jakarta.servlet.http.HttpSession;

@RequestMapping("feed")
@Controller
public class FeedController {
	
	@Autowired
	FeedService feedService;
	@Autowired
	CloudinaryService cloudinaryService;

    FeedController(CloudinaryService cloudinaryService) {
        this.cloudinaryService = cloudinaryService;
    }
	
	@GetMapping("/addFeed")
	public String goAddFeed() {
		return "feed/addFeed";
	}
	
	@PostMapping("/upload")
	public String uploadFeed(@RequestParam("file") MultipartFile file,
	                         @RequestParam("content") String content,
	                         HttpSession session) {
		
		
	    try {
	        // 세션에서 사용자 정보 꺼내기
	        t_member member = (t_member) session.getAttribute("member");
	        String mb_id = member.getMb_id();

	        cloudinaryService.uploadFile(file);

	        // DB에 이미지 저장
	        // feedService.saveFeed();

	        return "redirect:/"; // 업로드 성공 후 홈으로 이동
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "errorPage";
	    }
	}
	
}
