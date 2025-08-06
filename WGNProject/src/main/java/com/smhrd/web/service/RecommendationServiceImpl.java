package com.smhrd.web.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.smhrd.web.dto.CandidateFeedDTO;
import com.smhrd.web.dto.FeedRecommendationResponse;
import com.smhrd.web.dto.LogDTO;
import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_log;
import com.smhrd.web.mapper.FeedMapper;
import com.smhrd.web.mapper.LogMapper;

@Service
public class RecommendationServiceImpl implements RecommendationService {

	@Autowired
	LogMapper logMapper;
	@Autowired
	FeedMapper feedMapper;
	@Autowired
	private RestTemplate restTemplate;

	@Override
	public List<LogDTO> getMemberLog(String mb_id) {
		List<LogDTO> logs = logMapper.getMemberLog(mb_id);
		return logs;
	}

	@Override
	public List<CandidateFeedDTO> getCandidateFeed(String mb_id) {
		List<CandidateFeedDTO> candidateFeed = feedMapper.getCandidateFeed(mb_id);
		return candidateFeed;
	}

	@Override
	public List<t_feed> getRecommendedFeeds(t_log log) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Integer> sendLogsAndFeeds(String mb_id) {

		// HTTP 헤더 설정
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);

		// 데이터 보내기
		List<LogDTO> logs = this.getMemberLog(mb_id);
		List<CandidateFeedDTO> feeds = this.getCandidateFeed(mb_id);

		List<Map<String, Object>> logList = new ArrayList<>();

		for (LogDTO log : logs) {

			Map<String, Object> logData = new HashMap<>();
			logData.put("log_idx", log.getLog_idx());
			logData.put("mb_id", log.getMb_id());
			logData.put("res_idx", log.getRes_idx());
			logData.put("res_category", log.getRes_category());
			logData.put("res_tag", log.getRes_tag());
			logData.put("action_type", log.getAction_type());
			String isoTimestamp = log.getCreated_at().toInstant().toString();
			logData.put("created_at", isoTimestamp);
			logList.add(logData);
		}

		List<Map<String, Object>> feedList = new ArrayList<>();

		for (CandidateFeedDTO feed : feeds) {

			Map<String, Object> feedData = new HashMap<>();
			feedData.put("feed_idx", feed.getFeed_idx());
			feedData.put("res_idx", feed.getRes_idx());
			feedData.put("feed_likes", feed.getFeed_likes());
			feedData.put("res_category", feed.getRes_category());
			feedData.put("res_tag", feed.getRes_tag());
			feedList.add(feedData);
		}

		// logs와 feeds를 하나의 Map으로 묶어서 보냄
		Map<String, Object> requestBody = new HashMap<>();
		requestBody.put("logs", logList);
		requestBody.put("feeds", feedList);

		// 요청 생성
		HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(requestBody, headers);

		// FastAPI URL
		String pythonUrl = "http://localhost:8000/receive_logs_and_feeds";

		// 요청 보내고 결과 받기
		ResponseEntity<FeedRecommendationResponse> response = restTemplate.postForEntity(pythonUrl, requestEntity, FeedRecommendationResponse.class);

		List<Integer> recommendedIds = response.getBody().getRecommended_feed_ids();
		
		System.out.println("추천 피드 ID: " + recommendedIds);

		return recommendedIds;
	}

}
