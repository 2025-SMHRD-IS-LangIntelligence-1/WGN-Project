package com.smhrd.web.service;

import java.util.List;

import com.smhrd.web.dto.CandidateFeedDTO;
import com.smhrd.web.dto.LogDTO;
import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_log;

public interface RecommendationService {

	List<LogDTO> getMemberLog(String mb_id);
	
	List<CandidateFeedDTO> getCandidateFeed(String mb_id);
	
	List<t_feed> getRecommendedFeeds(t_log log);	
	
	List<Integer> sendLogsAndFeeds(String mb_id);

}
