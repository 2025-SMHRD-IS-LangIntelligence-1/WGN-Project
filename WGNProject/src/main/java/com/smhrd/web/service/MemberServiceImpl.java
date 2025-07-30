package com.smhrd.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.smhrd.web.controller.HomeController;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.mapper.MemberMapper;

@Service
public class MemberServiceImpl implements MemberService {

    private final HomeController homeController;

	@Autowired
	MemberMapper memberMapper;

    MemberServiceImpl(HomeController homeController) {
        this.homeController = homeController;
    }
	
	@Override
	public boolean join(t_member mem, String passwordCheck) {
		String pw = mem.getMb_pw();
		
		if (pw.equals(passwordCheck)) {
			memberMapper.join(mem);
			System.out.println("멤버등록");
			return true;
		}		
		else {
			return false;
		}
	}

	@Override
	public void login() {
		// TODO Auto-generated method stub
		
	}

}
