package com.smhrd.web.dto;

import java.sql.Timestamp;

import com.smhrd.web.entity.t_comment;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CommentDTO {

	// 댓글 식별자
	private Integer cmt_idx;

	// 피드 식별자
	private Integer feed_idx;

	// 댓글 작성자 id
	private String mb_id;

	// 댓글 작성자 닉네임
	private String mb_nick;

	// 댓글 내용
	private String cmt_content;

	// 댓글 작성일자
	private Timestamp created_at;

	// 댓글 작성자 프로필 이미지
	private String mb_img;

}
