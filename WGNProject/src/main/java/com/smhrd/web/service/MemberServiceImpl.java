package com.smhrd.web.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.mapper.MemberMapper;

import jakarta.servlet.http.HttpSession;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	MemberMapper memberMapper;
	@Autowired
	NotificationService notificationService;

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
		}else if (foundMem.getMb_pw().equals(mem.getMb_pw())) { // 입력한 비밀번호와 DB의 비밀번호가 같으면 멤버 정보 반환
			System.out.println(foundMem.getMb_pw());
			System.out.println(mem.getMb_pw());
			return foundMem;
		}else { // 입력한 비밀번호와 DB의 비밀번호가 다르면 null 반환
			return null;
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
		notificationService.makeFollowNoti(follower_id, following_id);
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

	@Override
	public void updateWithImg(String mbId, String nickname, String intro, String url) {
		memberMapper.updateWithImg(mbId, nickname, intro, url);
	}

	@Override
	public void update(String mbId, String nickname, String intro) {
		memberMapper.update(mbId, nickname, intro);
		
	}

	@Override
	public void saveLog(String mb_id, Integer res_idx, String action_type) {
		System.out.println("MemberService : " + action_type + "로그 저장 완료");
		memberMapper.saveLog(mb_id, res_idx, action_type);
	}
	

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

	
	@Override
	public List<t_member> searchByIdOrNick(String keyword) {
		
		if(keyword == null || keyword.trim().isEmpty()) {
	        return List.of();
	    }
	    
		List<t_member> profileList = memberMapper.searchByIdOrNick(keyword);
		
		return profileList;
	}

}
