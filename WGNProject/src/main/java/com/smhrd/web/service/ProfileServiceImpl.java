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
	public ProfileDTO getProfileInfo(String mb_id) {
		t_member mem = memberMapper.findById(mb_id);
		
		if (mem == null) {
	        throw new IllegalArgumentException("회원 정보를 찾을 수 없습니다: " + mb_id);
	    }
		
		String nickname = mem.getMb_nick();
		int feed_num = memberMapper.countFeed(mb_id);
		int follower = memberMapper.countFollowers(mb_id);
		int following = memberMapper.countFollowings(mb_id);
		String intro = mem.getMb_intro();
		String mb_img = mem.getMb_img();
		ProfileDTO profileDTO = new ProfileDTO(mb_id, nickname, feed_num, follower, following, intro, mb_img);
		return profileDTO;
	}

}
