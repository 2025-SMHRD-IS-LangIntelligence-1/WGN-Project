package com.smhrd.web.controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.entity.t_favorite;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.entity.t_review;
import com.smhrd.web.mapper.ReviewMapper;
import com.smhrd.web.service.CloudinaryService;
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
	@Autowired
	private CloudinaryService cloudinaryService;
	
	@PostMapping("/insertReview")
	public String insertReview(t_review review, MultipartFile review_file, HttpSession session,
			@RequestParam(value = "rank_toggle", required = false) String rankToggle) throws IOException {
		
		t_member member = (t_member)session.getAttribute("member");
		String mb_id = member.getMb_id();
		ProfileDTO profile = memberService.getProfileInfo(mb_id);
		
		// 파일 클라우디너리 저장 후 url 반환
		
		if (review_file != null && !review_file.isEmpty()) {
		    List<MultipartFile> files = Arrays.asList(review_file);
		    List<String> urls = cloudinaryService.uploadFiles(files);

		    if (urls != null && !urls.isEmpty()) {
		        String url = urls.get(0);
		        review.setImg_link(url);
		    }
		}		
		// t_review에 저장
		
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
