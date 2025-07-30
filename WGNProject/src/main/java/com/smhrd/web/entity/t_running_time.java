package com.smhrd.web.entity;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//운영시간 
@Data
@AllArgsConstructor
@NoArgsConstructor
public class t_running_time {

 // 운영시간 식별자 
 private Integer running_idx;

 // 음식점 식별자 
 private Integer res_idx;

 // 요일 
 private String weekday;

 // 오픈 시간 
 private Timestamp open_time;

 // 종료 시간 
 private Timestamp close_time;

 // 운영 여부 
 private String is_running;

}