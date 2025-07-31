package com.smhrd.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.mapper.MemberMapper;

@Service
public class ProfileServiceImpl implements ProfileService {

	@Autowired
	MemberMapper memberMapper;

	@Override
	public ProfileDTO showMyPage(String mb_id) {
		t_member member = memberMapper.findById(mb_id);
		String nickname = member.getMb_nick();
		int follower = 0;
		int following = 0;
		ProfileDTO profileDTO = new ProfileDTO(nickname, follower, following);
		return profileDTO;
	}

	@Override
	public ProfileDTO showOtherMemPage(String mb_id) {
		// TODO Auto-generated method stub
		return null;
	}

}
