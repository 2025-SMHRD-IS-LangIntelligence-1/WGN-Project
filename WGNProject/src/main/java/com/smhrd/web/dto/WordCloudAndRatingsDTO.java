package com.smhrd.web.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class WordCloudAndRatingsDTO {

	// Base64로 인코딩된 이미지 4개 담을 수 있는 필드
	
	private String nk_positive_wc;
	private String nk_negative_wc;
	private String wgn_positive_wc;
	private String wgn_negative_wc;
	
	// 와구냠 평점 담을 수 있는 필드
	private float wgn_ratings;
		
}
