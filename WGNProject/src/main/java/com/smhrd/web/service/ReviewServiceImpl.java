package com.smhrd.web.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.smhrd.web.dto.ReviewDTO;
import com.smhrd.web.dto.WordCloudDTO;
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

	@Override
	public WordCloudDTO sendResReview(int res_idx) {

		System.out.println("sendResReview 메서드 실행");

		// HTTP 헤더 설정
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);

		// 데이터 바인딩
		List<ReviewDTO> reviews = this.getResReview(res_idx);

		System.out.println("가져온 리뷰 수 : " + reviews.size());

		List<Map<String, Object>> reviewList = new ArrayList<>();

		for (ReviewDTO review : reviews) {

			Map<String, Object> reviewData = new HashMap<>();

			reviewData.put("review_idx", review.getReview_idx()); // 리뷰 식별자
			reviewData.put("res_idx", review.getRes_idx()); // 음식점 식별자
			reviewData.put("review_content", review.getReview_content()); // 리뷰 내용
			reviewData.put("likes", review.getLikes()); // 좋아요 수

			reviewList.add(reviewData);
		}

		// 요청 생성
		HttpEntity<List<Map<String, Object>>> requestEntity = new HttpEntity<>(reviewList, headers);

		System.out.println("요청 생성 완료");

		// FastAPI URL
		String pythonUrl = "http://localhost:8000/receive_review";

		RestTemplate restTemplate = new RestTemplate();
		
		// 1. 응답 타입 지정
		ParameterizedTypeReference<WordCloudDTO> responseType = new ParameterizedTypeReference<>() {
		};

		// 2. 요청 보내고 결과 받기
		ResponseEntity<WordCloudDTO> response = restTemplate.exchange(
				pythonUrl,
				HttpMethod.POST,
				requestEntity,
				responseType);

		WordCloudDTO result = response.getBody();

		System.out.println("요청 보내고 결과 받기 완료");
		System.out.println("응답 본문: " + result);

		return result;
	}

}
