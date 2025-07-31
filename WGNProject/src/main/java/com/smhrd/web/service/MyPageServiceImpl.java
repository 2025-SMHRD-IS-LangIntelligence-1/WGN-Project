package com.smhrd.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.web.dto.MyPageDTO;
import com.smhrd.web.mapper.MemberMapper;

@Service
public class MyPageServiceImpl implements MyPageService {

	@Autowired
	MemberMapper memberMapper;

	@Override
	public MyPageDTO showMyPage(String mb_id) {
		// TODO Auto-generated method stub
		return null;
	}

}
