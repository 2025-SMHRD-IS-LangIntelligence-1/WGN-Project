package com.smhrd.web.service;

import java.util.List;

import com.smhrd.web.dto.CandidateFeedDTO;
import com.smhrd.web.dto.FeedForSearchDTO;
import com.smhrd.web.dto.LogDTO;

public interface RecommendationService {

	// === 사용자 행동 로그 기반 피드 추천 서비스 메서드 ===
	
	List<LogDTO> getMemberLog(String mb_id);
	
	List<CandidateFeedDTO> getCandidateFeed(String mb_id);
	
	// 멤버 아이디를 바탕으로 Logs와 Feed를 FastAPI로 보내서 추천 Feed의 Feed_idx List를 받아오는 메서드 
	List<Integer> sendLogsAndFeeds(String mb_id);
	
	// === 피드 검색 서비스 메서드 ===
	
	List<FeedForSearchDTO> getFeedForSearch(String mb_id);
	
	// 멤버 아이디를 바탕으로 Feed를 FastAPI로 보내서 추천 Feed의 Feed_idx List를 받아오는 메서드
	List<Integer> sendFeedForSearch(String mb_id, String query);

	// === 음식점 검색 서비스 메서드 ===

	List<Integer> sendQuery(String query);


}
