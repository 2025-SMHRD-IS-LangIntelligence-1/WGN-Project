package com.smhrd.web.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReviewFeedDTO {

	private int res_idx;
	private String naver_reviews;
	private String kakao_reviews;
	private String wgn_reviews;
	private String wgn_feed;
}
