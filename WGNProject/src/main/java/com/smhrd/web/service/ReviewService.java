package com.smhrd.web.service;

import java.util.List;

import com.smhrd.web.dto.ReviewDTO;
import com.smhrd.web.dto.WordCloudDTO;
import com.smhrd.web.entity.t_review;

public interface ReviewService {
	
    void insertReview(t_review review);
    
	List<ReviewDTO> getResReview(int res_idx);
    
	// === 리뷰 워드클라우드 서비스 메서드 ===
	
	// 레스토랑 아이디를 바탕으로 리뷰를 FastAPI로 보내고 워드클라우드 이미지를 받아오는 메서드
	WordCloudDTO sendResReview(int res_idx);

	
}
