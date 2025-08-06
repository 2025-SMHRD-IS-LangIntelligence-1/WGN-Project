package com.smhrd.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.entity.t_review;
import com.smhrd.web.mapper.ReviewMapper;
import com.smhrd.web.service.MemberService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/restaurant")
public class ReviewController {
	
	
	@Autowired
	private ReviewMapper reviewmapper;
	@Autowired
	private MemberService memberService;
	
	@PostMapping("/insertReview")
	public String insertReview(t_review review, HttpSession session) {
		
		t_member member = (t_member)session.getAttribute("member");
		String mb_id = member.getMb_id();
		ProfileDTO profile = memberService.getProfileInfo(mb_id);
		
		review.setMb_id(profile.getMb_id());
		review.setMb_nick(profile.getNickname());
		reviewmapper.insertReview(review);
		
		
		return "redirect:/restaurant?res_idx="+review.getRes_idx();
	}

}
