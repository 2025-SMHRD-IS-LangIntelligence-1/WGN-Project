package com.smhrd.web.entity;

import java.security.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class t_feed_like {

	private int like_idx;
	private String feed_idx;
	private String mb_id;
	private Timestamp created_at;
}
