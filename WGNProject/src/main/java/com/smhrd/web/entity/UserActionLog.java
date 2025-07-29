package com.smhrd.web.entity;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserActionLog {

	private int log_id;
	private String member_id;
	private String keyword;
	private String action_type;
	private LocalDateTime timestamp;
	
}
