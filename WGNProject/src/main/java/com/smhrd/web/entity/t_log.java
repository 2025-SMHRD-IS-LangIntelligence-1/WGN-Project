package com.smhrd.web.entity;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//사용자 로그 
@Data
@AllArgsConstructor
@NoArgsConstructor
public class t_log {

 // 로그 식별자 
 private Integer log_idx;

 // 회원 아이디 
 private String mb_id;

 // 음식점 아이디
 private String res_idx;

 // 행동 유형 
 private String action_type;

 // 발생 시간 
 private Timestamp created_at;

}