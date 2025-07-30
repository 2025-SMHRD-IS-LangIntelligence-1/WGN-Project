package com.smhrd.web.entity;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//파일 
@Data
@AllArgsConstructor
@NoArgsConstructor
public class t_file {

 // 파일 식별자 
 private Integer file_idx;

 // 피드 식별자 
 private Integer feed_idx;

 // 파일 명 
 private String file_name;

 // 파일 사이즈 
 private Integer file_size;

 // 파일 확장자 
 private String file_ext;

 // 등록 일자 
 private Timestamp uploaded_at;



}
