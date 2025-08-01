package com.smhrd.web.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class t_feed_img {

	// 피드 이미지 식별자
	private int feed_img_idx;
	
	// 피드 이미지
	private int feed_idx;
	
	// 피드 이미지 url
	private String feed_img_url;
}
