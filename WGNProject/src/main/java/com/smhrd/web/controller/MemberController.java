package com.smhrd.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.MemberService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@RequestMapping("/member")
@Controller
public class MemberController {

	@Autowired
	MemberService memberService;

	// 회원 가입 페이지로 이동
	@GetMapping("/join")
	public String goJoin() {
		return "member/join";
	}
	
	// 멤버 정보를 DB에 저장
	@PostMapping("/joinMember")
	public String join(t_member mem, @RequestParam("mb_pw_check") String pwCheck, HttpServletRequest request) {
		
		// 기존 세션 파괴
		request.getSession().invalidate();
		
		// 회원가입
		boolean joinCheck = memberService.join(mem, pwCheck);
		
		// 회원가입 성공 시 새로운 세션 만들어서 회원 정보 저장
		if (joinCheck) {
	        HttpSession newSession = request.getSession(true);
	        newSession.setAttribute("member", mem); // 또는 가입 결과를 다시 조회해서 최신 정보 저장
	    }
		
		return "redirect:/";
		
	}
	
	// 아이디 중복체크
	@GetMapping("/checkId")
	@ResponseBody
	public String checkId(@RequestParam String inputId) {
		String idCheckResult = memberService.checkId(inputId);
		return idCheckResult;
	}

	// 닉네임 중복체크
	@GetMapping("/checkNick")
	@ResponseBody
	public String checkNick(@RequestParam String inputNick) {
		String NickCheckResult = memberService.checkNick(inputNick);
		return NickCheckResult;
	}
	
	// 로그인 페이지로 이동
	@GetMapping("/login")
	public String goLogin() {
		return "member/login";	
	}
	
	// 로그인 기능
	@PostMapping("/loginMember")
	public String login(t_member mem, HttpSession session, RedirectAttributes ra) {
		
		// 로그인 메서드
	    t_member member = memberService.login(mem);
	    if (member == null) {
	    	System.out.println("아이디 또는 비밀번호가 올바르지 않습니다.");
	    	ra.addFlashAttribute("loginErrorMsg", "아이디와 비밀번호를 확인해주세요.");
	        return "redirect:/member/login";
	    }

	    session.setAttribute("member", member);

	    try {
	        // 로그인 성공 후에만 프로필 로드 (입력값 mem.getMb_id() 말고, 검증된 member.getMb_id() 사용)
	        ProfileDTO profile = memberService.getProfileInfo(member.getMb_id());
	        session.setAttribute("profile", profile);
	    } catch (IllegalArgumentException e) {
	        // 프로필 없다고 로그인까지 막을 필요는 없으니, 경고만 주고 진행하거나 기본 프로필을 넣으세요.
	        System.out.println("[WARN] 프로필 없음: " + e.getMessage());
	        session.removeAttribute("profile"); // 또는 기본 프로필 세팅
	    }

	    return "redirect:/";
	}
	
	// 로그아웃 기능
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.removeAttribute("member");
		session.removeAttribute("profile");
		return "redirect:/";	
	}
	
	// 팔로우 기능
	@PostMapping("/follow")
	@ResponseBody
	public String follow(HttpSession session, @RequestParam("following_id") String following_id) {
		
		// 로그인 되어있는지 체크
		boolean loginCheck = memberService.loginCheck(session);
		
		// 로그인 되어 있지 않다면 로그인 페이지로
		if (!loginCheck) {
			return "notLoggedIn";
		}
		
	    t_member member = (t_member) session.getAttribute("member");
		
	    // 팔로우하는 사람 (주체)
		String follower_id = member.getMb_id();
		
		// 팔로우하는 사람 (주체) / 팔로우받는 사람 (객체) 저장
		memberService.followMem(follower_id, following_id);
		
		return "followSuccess";
	}
	
	// 언팔로우 기능
	@PostMapping("/unfollow")
	@ResponseBody
	public String unfollow(HttpSession session, @RequestParam("following_id") String following_id) {
		
		// 로그인 되어있는지 체크
		boolean loginCheck = memberService.loginCheck(session);
		
		// 로그인 되어 있지 않다면 로그인 페이지로
		if (!loginCheck) {
			return "notLoggedIn";
		}
		
	    t_member member = (t_member) session.getAttribute("member");
		
	    // 팔로우하는 사람 (주체)
		String follower_id = member.getMb_id();
		
		// 팔로우하는 사람 (주체) / 팔로우받는 사람 (객체) 삭제
		memberService.unfollowMem(follower_id, following_id);
		
		return "unfollowSuccess";
	}
	
}
