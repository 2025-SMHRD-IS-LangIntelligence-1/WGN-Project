package com.smhrd.web.dto;

import java.math.BigDecimal;
import java.sql.Timestamp;
//FeedRecommendationResponse.java
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FavoriteresDTO {

	private int res_idx;
	private String res_name;
	private String res_addr;
	private Double fav_rating;
	private String res_thumbnail; // 이미지 썸네일 경로
	private Timestamp created_at;
	// 위도
	private BigDecimal lat;

	// 경도
	private BigDecimal lon;

}
