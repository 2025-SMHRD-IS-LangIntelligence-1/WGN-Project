package com.smhrd.web.dto;

import java.sql.Timestamp;

import com.smhrd.web.entity.t_comment;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MycommentDTO {

    private Long commentIdx;	 // 피드 댓글 ID
    private Long feedIdx;		 // 피드 ID

    private String mbId;         // 댓글 작성자 ID
    private String mbNick;       // 댓글 작성자 닉네임
    private String mbImg;        // 댓글 작성자 프로필
    private String content;      // 댓글 내용
    private Timestamp createdAt; // 댓글 작성일

    private String feedThumbnail;// 피드 썸네일
    private String feedMbNick;   // 피드 작성자 닉네임
    private String feedMbImg;    // 피드 작성자 프로필
    private String feedContent;  // 피드 내용
	

}
