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

import com.smhrd.web.dto.CandidateFeedDTO;
import com.smhrd.web.dto.FeedForSearchDTO;
import com.smhrd.web.dto.LogDTO;
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
	public List<Integer> sendLogsAndFeeds(String mb_id) {

		List<Integer> FeedIdxList;
		
		System.out.println("sendLogsAndFeeds 메서드 실행");

		// HTTP 헤더 설정
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);

		// 데이터 바인딩
		List<LogDTO> logs = this.getMemberLog(mb_id);
		List<CandidateFeedDTO> feeds = this.getCandidateFeed(mb_id);

		System.out.println("가져온 로그 수 : " + logs.size());
		System.out.println("가져온 피드 수 : " + feeds.size());

		if (logs.size() == 0) {
	        // 사용자 로그가 없을 경우 기본 피드 제공
	        FeedIdxList = feedMapper.getMixedFeeds();
	        return FeedIdxList;
	    }
		
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

		System.out.println("requestBody의 크기 : " + requestBody.size());

		// 요청 생성
		HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(requestBody, headers);

		System.out.println("요청 생성 완료");

		// FastAPI URL
		String pythonUrl = "http://localhost:8000/receive_logs_and_feeds";

		// 요청 보내고 결과 받기
		ParameterizedTypeReference<List<Integer>> responseType = new ParameterizedTypeReference<>() {};
		ResponseEntity<List<Integer>> response = restTemplate.exchange(
		    pythonUrl,
		    HttpMethod.POST,
		    requestEntity,
		    responseType
		);
		
		FeedIdxList = response.getBody();

		System.out.println("요청 보내고 결과 받기 완료");
		System.out.println("응답 본문: " + FeedIdxList);

		return FeedIdxList;
	}

	
	@Override
	public List<FeedForSearchDTO> getFeedForSearch(String mb_id) {
		List<FeedForSearchDTO> feeds = feedMapper.getFeedForSearch(mb_id);
		return feeds;
	}
	
	@Override
	public List<Integer> sendFeedForSearch(String mb_id) {
		
		System.out.println("sendFeedForSearch 메서드 실행");

		// HTTP 헤더 설정
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);

		// 데이터 바인딩
		List<FeedForSearchDTO> feeds = this.getFeedForSearch(mb_id);

		System.out.println("가져온 피드 수 : " + feeds.size());

		List<Map<String, Object>> feedList = new ArrayList<>();

		for (FeedForSearchDTO feed : feeds) {

			Map<String, Object> feedData = new HashMap<>();
			feedData.put("feed_idx", feed.getFeed_idx());
			feedData.put("feed_likes", feed.getFeed_likes());
			feedData.put("res_tag", feed.getRes_tag());
			feedData.put("feed_content", feed.getFeed_content());
			feedList.add(feedData);
		}

		// 요청 생성
		HttpEntity<List<Map<String, Object>>> requestEntity = new HttpEntity<>(feedList, headers);

		System.out.println("요청 생성 완료");

		// FastAPI URL
		String pythonUrl = "http://localhost:8000/receive_feed_for_search";

		// 요청 보내고 결과 받기
		ParameterizedTypeReference<List<Integer>> responseType = new ParameterizedTypeReference<>() {};
		ResponseEntity<List<Integer>> response = restTemplate.exchange(
		    pythonUrl,
		    HttpMethod.POST,
		    requestEntity,
		    responseType
		);
		
		List<Integer> FeedIdxList = response.getBody();

		System.out.println("요청 보내고 결과 받기 완료");
		System.out.println("응답 본문: " + FeedIdxList);

		return FeedIdxList;
	}
	
}
