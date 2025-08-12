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
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.smhrd.web.dto.WordCloudAndRatingsDTO;
import com.smhrd.web.mapper.RestaurantMapper;

@Component
public class WordcloudService {

	@Autowired
	RestaurantMapper restaurantMapper;
	
	public WordCloudAndRatingsDTO sendResReview(int res_idx) {

	    System.out.println("sendResReview 메서드 실행");

	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.APPLICATION_JSON);

	    String pythonUrl = "http://localhost:8000/receive_review?res_idx=" + res_idx;

	    HttpEntity<Void> requestEntity = new HttpEntity<>(headers);

	    RestTemplate restTemplate = new RestTemplate();

	    ParameterizedTypeReference<WordCloudAndRatingsDTO> responseType = new ParameterizedTypeReference<>() {};

	    ResponseEntity<WordCloudAndRatingsDTO> response = restTemplate.exchange(
	            pythonUrl,
	            HttpMethod.POST,
	            requestEntity,
	            responseType
	    );

	    WordCloudAndRatingsDTO result = response.getBody();

	    System.out.println("요청 보내고 결과 받기 완료");
	    System.out.println("응답 본문: " + result);

	    return result;
	}

	
	public void updateWordCloud(int res_idx) {
		
		WordCloudAndRatingsDTO data = this.sendResReview(res_idx);
		String wc1 = data.getNk_positive_wc();
		String wc2 = data.getNk_negative_wc();
		String wc3 = data.getWgn_positive_wc();
		String wc4 = data.getWgn_negative_wc();
		float ratings = data.getWgn_ratings();
		restaurantMapper.updateWcAndRatings(res_idx, wc1, wc2, wc3, wc4, ratings);
		
	}

    // 1시간마다 실행 (밀리초 단위)
    @Scheduled(fixedRate = 60 * 60 * 1000)
    public void updateScheduler() {
    	
    	 System.out.println("스케줄러 실행중! " + System.currentTimeMillis());
    	
        // 최근 1시간 동안 리뷰/피드가 변경된 음식점 idx 가져오기
    	LocalDateTime time = LocalDateTime.now().minusHours(1);
    	List<Integer> updateList = restaurantMapper.findRecentlyUpdated(time);

        for (int res_idx : updateList) {
            try {
                // 워드클라우드 생성 요청 & DB 업데이트
                this.updateWordCloud(res_idx);
            } catch (Exception e) {
                // 에러 로그 기록 후 다음 음식점 계속 처리
                System.err.println("워드클라우드 업데이트 실패 resId=" + res_idx + ", error=" + e.getMessage());
            }
        }
    }
    
    public void updateEmpty() {
    	List<Integer> EmptyList = restaurantMapper.selectEmpty();
    	
    	for (int res_idx : EmptyList) {
            try {
                // 워드클라우드 생성 요청 & DB 업데이트
                this.updateWordCloud(res_idx);
            } catch (Exception e) {
                // 에러 로그 기록 후 다음 음식점 계속 처리
                System.err.println("워드클라우드 업데이트 실패 resId=" + res_idx + ", error=" + e.getMessage());
            }
        }
    	
    }
	
}
