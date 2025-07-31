package com.smhrd.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.web.dto.MyPageDTO;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.mapper.MemberMapper;

import ch.qos.logback.core.model.Model;

@Service
public class MyPageServiceImpl implements MyPageService {

	@Autowired
	MemberMapper memberMapper;

	@Override
	public MyPageDTO ShowMyPage(Model model) {
		
		// 멤버 정보 불러오기
		MyPageDTO myPageDTO;
		
		return myPageDTO;
		
	}

}
