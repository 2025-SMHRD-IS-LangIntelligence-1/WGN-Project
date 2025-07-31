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
    private String follower_id;
    // 팔로잉 아이디 
    private String following_id;

    // 팔로우 일시 
    private Timestamp followed_at;

}