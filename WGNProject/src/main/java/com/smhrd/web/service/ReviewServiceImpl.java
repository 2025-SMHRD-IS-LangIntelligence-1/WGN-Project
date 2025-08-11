package com.smhrd.web.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.smhrd.web.dto.ReviewDTO;
import com.smhrd.web.dto.WordCloudAndRatingsDTO;
import com.smhrd.web.entity.t_review;
import com.smhrd.web.mapper.RestaurantMapper;
import com.smhrd.web.mapper.ReviewMapper;

@Service
public class ReviewServiceImpl implements ReviewService {

	@Autowired
	private ReviewMapper reviewMapper;
	@Autowired
	private RestaurantMapper restaurantMapper;

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
