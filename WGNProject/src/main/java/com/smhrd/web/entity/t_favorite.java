package com.smhrd.web.entity;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//찜한 음식점
@Data
@AllArgsConstructor
@NoArgsConstructor
public class t_favorite {

 // 찜 식별자 
 private Integer fav_idx;

 // 회원 아이디 
 private String mb_id;

 // 음식점 식별자 
 private Integer res_idx;

 // 찜한 날짜 
 private Timestamp created_at;


}