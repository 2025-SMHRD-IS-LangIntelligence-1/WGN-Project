package com.smhrd.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.mapper.MemberMapper;

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
		t_member foundNick = memberMapper.findByNick(inputNick);
		
		if (foundNick == null) { // 입력한 아이디를 못 찾았으면 "true" 반환
			return "true";
		}else { // 아니면 "true" 반환
			return "false";
		}
	}
	
	@Override
	public void login() {
		// TODO Auto-generated method stub
		
	}

}
