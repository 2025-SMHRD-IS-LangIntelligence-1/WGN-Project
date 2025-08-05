package com.smhrd.web.entity;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//피드
@Data
@AllArgsConstructor
@NoArgsConstructor
public class t_feed {

 // 피드 식별자 
 private Integer feed_idx;

 // 회원 아이디 
 private String mb_id;

 // 음식점 식별자 
 private Integer res_idx;

 // 피드 내용 
 private String feed_content;

 // 좋아요 수 
 private Integer feed_likes;
 
 // 별점
 private Double ratings;

 // 작성 일자 
 private Timestamp created_at;

}
