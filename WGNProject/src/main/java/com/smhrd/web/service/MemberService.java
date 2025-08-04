package com.smhrd.web.service;

import com.smhrd.web.entity.t_member;

import jakarta.servlet.http.HttpSession;

public interface MemberService {
	
	t_member login(t_member mem);

	boolean join(t_member mem, String pwCheck);

	String checkId(String inputId);

	String checkNick(String inputNick);
	
	// 로그인 여부를 체크
	boolean loginCheck(HttpSession session);

	void followMem(String follower_id, String following_id);

	void unfollowMem(String follower_id, String following_id);

}
