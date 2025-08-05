package com.smhrd.web.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_log;

@Service
public class RecommendationServiceImpl implements RecommendationService {

	@Override
	public List<t_feed> getRecommendedFeeds(t_log log) {
		// 구현 예정
		return null;
	}

}
