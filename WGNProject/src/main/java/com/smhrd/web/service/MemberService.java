package com.smhrd.web.service;

import java.util.List;

import org.springframework.scheduling.annotation.Async;

import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.entity.t_member;
import jakarta.servlet.http.HttpSession;

public interface MemberService {
	
	t_member login(t_member mem);

	boolean join(t_member mem, String pwCheck);

	String checkId(String inputId);

	String checkNick(String inputNick);
	
	// 로그인 여부를 체크
	boolean loginCheck(HttpSession session);

	@Async
	void followMem(String follower_id, String following_id);

	@Async
	void unfollowMem(String follower_id, String following_id);

	boolean isFollowing(String mbId, String feedOwnerId);

	@Async
	void updateWithImg(String mbId, String nickname, String intro, String url);
	
	@Async
	void update(String mbId, String nickname, String intro);

	@Async
	void saveLog(String mb_id, Integer res_idx, String action_type);
	
	ProfileDTO getProfileInfo(String mb_id);

	public List<t_member> searchByIdOrNick(String keyword);

}
