package com.smhrd.web.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_log;
import com.smhrd.web.service.RecommendationService;

@RestController
@RequestMapping("/recommandation")
public class RecommandationController {

	@Autowired
	RecommendationService recommendationService;
	
	@PostMapping("/feed")
		public List<t_feed> recommendFeeds(@RequestBody t_log log) {
	        List<t_feed> recommendedFeeds = recommendationService.getRecommendedFeeds(log);
	        return recommendedFeeds;
	    }
	
}
