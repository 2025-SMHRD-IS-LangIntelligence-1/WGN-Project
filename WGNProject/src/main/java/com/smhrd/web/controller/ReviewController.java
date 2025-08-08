package com.smhrd.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.entity.t_favorite;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.entity.t_review;
import com.smhrd.web.mapper.ReviewMapper;
import com.smhrd.web.service.FavoriteService;
import com.smhrd.web.service.MemberService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/restaurant")
public class ReviewController {
	
	
	@Autowired
	private ReviewMapper reviewmapper;
	@Autowired
	private MemberService memberService;
	@Autowired
	private FavoriteService favoriteService;
	
	@PostMapping("/insertReview")
	public String insertReview(t_review review, HttpSession session,
			@RequestParam(value = "rank_toggle", required = false) String rankToggle) {
		
		t_member member = (t_member)session.getAttribute("member");
		String mb_id = member.getMb_id();
		ProfileDTO profile = memberService.getProfileInfo(mb_id);
		
		review.setMb_id(profile.getMb_id());
		review.setMb_nick(profile.getNickname());
		reviewmapper.insertReview(review);

		
	    // 랭킹 등록
	    if ("on".equals(rankToggle)) {
	    	t_favorite favorite = new t_favorite();
	    	favorite.setMb_id(mb_id);
	    	favorite.setRes_idx(review.getRes_idx());
	    	favorite.setFav_rating(review.getRatings());
	    	favoriteService.insertFavorite(favorite);
	    }

		
		return "redirect:/restaurant?res_idx="+review.getRes_idx();
	}

}
