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

 // 요일별 운영시간 
 private String weekday;

 // 라스트오더 시간 
 private String last_time;

 // 브레이크 시간 
 private String break_time;



}