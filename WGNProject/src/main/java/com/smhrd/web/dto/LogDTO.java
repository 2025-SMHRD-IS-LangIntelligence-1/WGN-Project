package com.smhrd.web.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LogDTO {

	// 로그 식별자
	private Integer log_idx;
	
	// 회원 아이디
	private String mb_id;
	
	// 음식점 식별자
	private Integer res_idx;
	
	//음식점 카테고리 
	private String res_category;
	
	// 음식점 태그
	private String res_tag;
	 
	// 행동 유형 
	private String action_type;
	
	// 발생 시간 
	private Timestamp created_at;
	
}
