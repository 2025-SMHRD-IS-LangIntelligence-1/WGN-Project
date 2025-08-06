package com.smhrd.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.web.entity.t_review;
import com.smhrd.web.mapper.ReviewMapper;

@Service
public class ReviewServicempl implements ReviewService{

	
	@Autowired
	private ReviewMapper reviewMapper;

    @Override
    public void insertReview(t_review review) {
        reviewMapper.insertReview(review);
    }

}
