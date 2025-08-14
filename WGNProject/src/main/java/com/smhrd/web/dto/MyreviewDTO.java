package com.smhrd.web.dto;

import java.sql.Timestamp;

import com.smhrd.web.entity.t_comment;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MyreviewDTO {

    private Long resIdx;	 	 // 음식점 ID
    private Long reviewIdx;		 // 리뷰 댓글 ID


    private String res_name;     // 음식점 이름
    private String mbImg;        // 음식점 대표 사진


    private String review_img;	 // 리뷰 사진 하나밖에 못올림 
    private String reviewMbNick;   // 리뷰 작성자 닉네임
    private String reviewMbImg;    // 리뷰 작성자 프로필 사진
    private String reviewMbId;    // 리뷰 작성자 아이디
    private String reviewContent;  // 리뷰 내용
    private Float ratings;
    private Timestamp createdAt; // 리뷰 작성일

}
