package com.smhrd.web.entity;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class t_notification {
	
	    private int noti_id;
	    private String sender_id;
	    private String receiver_id;
	    private String type; // "follow", "comment", "like"
	    private Integer target_id; // 게시글 ID (nullable)
	    private String content; // 댓글 내용 (nullable)
	    private boolean read;
	    private Timestamp created_at;
	    
	}