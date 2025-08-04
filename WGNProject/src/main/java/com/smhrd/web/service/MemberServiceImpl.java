package com.smhrd.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.mapper.MemberMapper;

import jakarta.servlet.http.HttpSession;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	MemberMapper memberMapper;

	@Override
	public boolean join(t_member mem, String pwCheck) {
		String pw = mem.getMb_pw();
		System.out.println(pw);
		if (pw.equals(pwCheck)) {
			memberMapper.join(mem);
			return true;
		}		
		else {
			return false;
		}
	}

	@Override

	public String checkId(String inputId) {
		t_member foundId = memberMapper.findById(inputId);
		
		if (foundId == null) { // 입력한 아이디를 못 찾았으면 "true" 반환
			return "true";
		}else { // 아니면 "true" 반환
			return "false";
		}
	}

	@Override
	public String checkNick(String inputNick) {
		t_member foundMem = memberMapper.findByNick(inputNick);
		
		if (foundMem == null) { // 입력한 아이디를 못 찾았으면 "true" 반환
			return "true";
		}else { // 아니면 "true" 반환
			return "false";
		}
	}

	@Override
	public t_member login(t_member mem) {
		t_member foundMem = memberMapper.findById(mem.getMb_id());
		
		if (foundMem == null) { // 입력한 아이디를 못 찾았으면 null 반환
			return null;
		}else { // 찾았으면 멤버 정보 반환
			return foundMem;
		}
	}

	@Override
	public boolean loginCheck(HttpSession session) {
		// 세션에서 로그인한 사용자 정보 가져오기
        t_member logined = (t_member) session.getAttribute("member");
    	
    	// 로그인 안 되어 있으면 false 반환
        if (logined == null) {
            return false;
        }
        
        // 로그인 되어 있으면 true 반환
		return true;
	}

	@Override
	public void followMem(String follower_id, String following_id) {
		memberMapper.followMem(follower_id, following_id);
		
	}

	@Override
	public void unfollowMem(String follower_id, String following_id) {
		memberMapper.unfollowMem(follower_id, following_id);
	}

	@Override
	public boolean isFollowing(String mbId, String feedOwnerId) {
		int result = memberMapper.isFollowing(mbId, feedOwnerId);
		
		if (result == 0) {
			return false;
		}
		
		return true;
	}

}
