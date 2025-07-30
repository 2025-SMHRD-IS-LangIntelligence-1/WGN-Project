package com.smhrd.web.entity;

import java.sql.Timestamp;

//찜한 음식점 
public class t_favorite {

 // 찜 식별자 
 private Integer fav_dix;

 // 회원 아이디 
 private String mb_id;

 // 음식점 식별자 
 private Integer res_idx;

 // 찜한 날짜 
 private Timestamp created_at;


}