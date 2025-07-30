package com.smhrd.web.entity;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//회원
@Data
@AllArgsConstructor
@NoArgsConstructor
public class t_member {

    // 회원 아이디 
    private String mb_id;

    // 회원 비밀번호 
    private String mb_pw;

    // 회원 이름 
    private String mb_name;

    // 회원 닉네임 
    private String mb_nick;

    // 가입 일자 
    private Timestamp joined_at;
	
}
