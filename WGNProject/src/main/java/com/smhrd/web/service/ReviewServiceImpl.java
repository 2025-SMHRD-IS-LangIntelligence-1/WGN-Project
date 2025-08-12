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
	
	@Override
	public void insertReview(t_review review) {
		reviewMapper.insertReview(review);
	}

	@Override
	public List<ReviewDTO> getResReview(int res_idx) {
		List<ReviewDTO> res_review = reviewMapper.getResReview(res_idx);
		return res_review;
	}
	

}
