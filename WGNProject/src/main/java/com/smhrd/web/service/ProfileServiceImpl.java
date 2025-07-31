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
		t_member mem = memberMapper.findById(mb_id);
		String nickname = mem.getMb_nick();
		int feed_num = memberMapper.countFeed(mb_id);
		int follower = memberMapper.countFollowers(mb_id);
		int following = memberMapper.countFollowings(mb_id);
		ProfileDTO profileDTO = new ProfileDTO(nickname, feed_num, follower, following);
		return profileDTO;
	}

	@Override
	public ProfileDTO showOtherMemPage(String mb_id) {
		// TODO Auto-generated method stub
		return null;
	}

}
