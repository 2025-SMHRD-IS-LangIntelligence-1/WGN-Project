package com.smhrd.web.entity;

import java.sql.Timestamp;

//방문 한곳 
public class t_going {

 // 방문 식별자 
 private Integer going_idx;

 // 회원 아이디 
 private String mb_id;

 // 음식점 식별자 
 private Integer res_idx;

 // 방문 날짜 
 private Timestamp created_at;

}