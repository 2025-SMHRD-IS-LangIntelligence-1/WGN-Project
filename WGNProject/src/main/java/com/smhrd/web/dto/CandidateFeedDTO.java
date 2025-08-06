package com.smhrd.web.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CandidateFeedDTO {

	private int feed_idx;
	
	private int res_idx;
	
	private int feed_likes;
	
	private String res_category;
	
	private String res_tag;
	
}
