package com.smhrd.web.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class t_res_img {

	// 음식점 이미지 식별자
	private int res_img_idx;
	
	// 음식점 식별자
	private int res_idx;
	
	// 음식점 이미지 url
	private String res_img_url;
}
