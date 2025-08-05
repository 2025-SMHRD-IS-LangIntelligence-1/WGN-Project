package com.smhrd.web.service;

import java.util.List;

import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_log;

public interface RecommendationService {

	List<t_feed> getRecommendedFeeds(t_log log);

}
