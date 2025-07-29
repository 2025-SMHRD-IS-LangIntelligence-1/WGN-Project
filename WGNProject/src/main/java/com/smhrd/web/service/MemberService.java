package com.smhrd.web.service;

import com.smhrd.web.entity.Member;

public interface MemberService {
	
	void login();

	boolean join(Member mem, String passwordCheck);

}
