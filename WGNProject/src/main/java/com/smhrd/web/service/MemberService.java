package com.smhrd.web.service;

import com.smhrd.web.entity.t_member;

public interface MemberService {
	
	void login();

	boolean join(t_member mem, String pwCheck);

	String checkId(String inputId);

}
