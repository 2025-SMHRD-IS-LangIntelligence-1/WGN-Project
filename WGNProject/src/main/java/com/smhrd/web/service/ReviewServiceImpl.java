package com.smhrd.web.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.web.dto.ReviewDTO;
import com.smhrd.web.entity.t_review;
import com.smhrd.web.mapper.ReviewMapper;

@Service
public class ReviewServiceImpl implements ReviewService {

	@Autowired
	private ReviewMapper reviewMapper;
	@Autowired
	private RestaurantService restaurantService;
	
	@Override
	public void insertReview(t_review review) {
		
		// 리뷰 저장
		reviewMapper.insertReview(review);
		
		// 레스토랑 최근 업데이트 시점 변경
		int res_idx = review.getRes_idx();
		restaurantService.updateRecord(res_idx);
	}

	@Override
	public List<ReviewDTO> getResReview(int res_idx) {
		List<ReviewDTO> res_review = reviewMapper.getResReview(res_idx);
		return res_review;
	}
	

}
