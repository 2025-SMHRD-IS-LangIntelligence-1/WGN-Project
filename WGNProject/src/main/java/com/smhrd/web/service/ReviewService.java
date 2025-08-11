package com.smhrd.web.service;

import java.util.List;

import com.smhrd.web.dto.ReviewDTO;
import com.smhrd.web.entity.t_review;

public interface ReviewService {
	
    void insertReview(t_review review);
    
	List<ReviewDTO> getResReview(int res_idx);
	
}
