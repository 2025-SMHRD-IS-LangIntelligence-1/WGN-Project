package com.smhrd.web.entity;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class t_follow {

    // 팔로우 식별자 
    private Integer follow_idx;

    // 팔로워 아이디 
    private String res_idx;

    // 팔로잉 아이디 
    private String menu_name;

    // 팔로우 날짜 
    private Timestamp menu_price;

}