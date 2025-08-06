package com.smhrd.web.service;

import java.util.List;

import com.smhrd.web.dto.CandidateFeedDTO;
import com.smhrd.web.dto.LogDTO;

public interface RecommendationService {

	List<LogDTO> getMemberLog(String mb_id);
	
	List<CandidateFeedDTO> getCandidateFeed(String mb_id);
	
	List<Integer> sendLogsAndFeeds(String mb_id);

}
