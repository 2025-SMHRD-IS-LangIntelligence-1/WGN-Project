package com.smhrd.web.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//음식점
@Data
@AllArgsConstructor
@NoArgsConstructor
public class t_restaurant {

 // 음식점 식별자 
 private Integer res_idx;

 // 음식점 카테고리 
 private String res_category;

 // 음식점 명 
 private String res_name;

 // 지역 구분 
 private String res_region;

 // 음식점 주소 
 private String res_addr;

 // 음식점 전화 
 private String res_tel;

 // 위도
 private BigDecimal lat;

 // 경도 
 private BigDecimal lon;

 // 음식점 태그
 private String res_tag;
 
 // 음식점 별점
 private float res_ratings;
 
 // 마지막 업데이트 (리뷰, 피드)
 private Timestamp last_update;
 
 // 워드클라우드 Base64 문자열 저장
 private String nk_positive_wc;
 private String nk_negative_wc;
 private String wgn_positive_wc;
 private String wgn_negative_wc;

}
