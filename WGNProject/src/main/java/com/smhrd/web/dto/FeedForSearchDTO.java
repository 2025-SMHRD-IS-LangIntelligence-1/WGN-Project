package com.smhrd.web.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FeedForSearchDTO {

	private int feed_idx;
	
	private int feed_likes;
	
	private String res_tag;
	
	private String feed_content;
	
}
