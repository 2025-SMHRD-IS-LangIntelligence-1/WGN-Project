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
import com.smhrd.web.dto.ReviewFeedDTO;
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

	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.APPLICATION_JSON);

	    HttpEntity<Integer> requestEntity = new HttpEntity<>(res_idx, headers);

	    System.out.println("요청 생성 완료: res_idx = " + res_idx);

	    String pythonUrl = "http://localhost:8000/receive_review";

	    RestTemplate restTemplate = new RestTemplate();

	    ParameterizedTypeReference<WordCloudDTO> responseType = new ParameterizedTypeReference<>() {};

	    ResponseEntity<WordCloudDTO> response = restTemplate.exchange(
	            pythonUrl,
	            HttpMethod.POST,
	            requestEntity,
	            responseType
	    );

	    WordCloudDTO result = response.getBody();

	    System.out.println("요청 보내고 결과 받기 완료");
	    System.out.println("응답 본문: " + result);

	    return result;
	}


}
