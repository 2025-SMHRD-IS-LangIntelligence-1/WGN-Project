package com.smhrd.web.dto;

import com.smhrd.web.entity.t_comment;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CommentDTO {


	// 댓글 entity
	private t_comment comment;

	// 댓글 작성자 프로필 이미지
	private String mb_img;
	
}
