package com.smhrd.web.dto;

//FeedRecommendationResponse.java
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FeedRecommendationResponse {
	
	private List<Integer> recommended_feed_ids;

}
