package com.smhrd.web.controller;

import java.io.IOException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_feed_img;
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
	public String uploadFeed(@ModelAttribute t_feed feed,
							@RequestParam("file") MultipartFile file,
	                         HttpSession session) {
		

	    	// 세션에서 사용자 정보 꺼내기
	        t_member member = (t_member) session.getAttribute("member");
	        String mb_id = member.getMb_id();
	        
	        // 피드에 정보 등록하기
	        feed.setMb_id(mb_id);
	        feed.setRes_idx(11010243); // 테스트용 임시 res_idx
	        feed.setFeed_likes(0);
	        
	        try {
				feedService.saveFeed(feed, file);
			} catch (IOException e) {
				e.printStackTrace();
			}
	        
	        return "redirect:/"; // 업로드 성공 후 홈으로 이동

	}
	
}
