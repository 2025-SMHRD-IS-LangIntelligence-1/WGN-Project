package com.smhrd.web.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProfileDTO {

	private String mb_id;
	private String nickname;
	private int feed_num=0;
	private int follower=0;
	private int following=0;
	private String intro;
	private String mb_img;
	
}
