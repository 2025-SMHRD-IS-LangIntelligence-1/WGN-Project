package com.smhrd.web.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReviewDTO {

	// 리뷰 entity
	// 리뷰 식별자
	private Integer review_idx;

	// 음식점 식별자
	private Integer res_idx;

	// 회원 아이디
	private String mb_id;

	// 리뷰 내용
	private String review_content;

	// 이미지 링크
	private String img_link;

	// 별점
	private float ratings;

	// 좋아요 수
	private Integer likes;

	// 작성 일시
	private Timestamp created_at;

	// 리뷰 작성자 닉네임
	private String mb_nick;

	// 리뷰 작성자 프로필 이미지
	private String mb_img;

}
