package com.smhrd.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.web.dto.MyPageDTO;
import com.smhrd.web.entity.Member;
import com.smhrd.web.mapper.MemberMapper;

@Service
public class MyPageServiceImpl implements MyPageService {

	@Autowired
	MemberMapper memberMapper;

	@Override
	public void join() {
		
		
	}

	@Override
	public void login() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public MyPageDTO ShowMyPage(String member_id) {
		
		// 멤버 정보 불러오기
		Member memberInfo = memberMapper.findById(member_id);
		String nickname = memberInfo.getNickname();
		int follower;
		int following;
		MyPageDTO myPageDTO = new myPageDTO(nickname, follower, following);
		
		return myPageDTO;
		
	}

}
