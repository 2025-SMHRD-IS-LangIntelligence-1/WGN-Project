package com.smhrd.web.service;

import com.smhrd.web.dto.MyPageDTO;

public interface MyPageService {

	public void join();
	
	public void login();

	public MyPageDTO ShowMyPage(String member_id);
	
}
