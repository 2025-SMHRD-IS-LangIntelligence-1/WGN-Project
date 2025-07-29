package com.smhrd.web.entity;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Feed {

	private int feed_id;
	private String member_id;
	private int restaurant_id;
	private String feed_title;
	private String feed_content;
    private String image_url;
    private int likes;
    private int comment_count;
    private LocalDateTime created_at;
	
}
