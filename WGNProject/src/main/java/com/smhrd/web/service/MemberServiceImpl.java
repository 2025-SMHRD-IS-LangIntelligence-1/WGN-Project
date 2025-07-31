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

}
