package com.smhrd.web.advice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.ProfileService;

import jakarta.servlet.http.HttpSession;

// @ControllerAdvice: 모든 컨트롤러에 공통으로 적용되는 설정
@ControllerAdvice
public class GlobalModelAttribute {

    @Autowired
    private ProfileService profileService;

    // @ModelAttribute("profile")
    // 모든 컨트롤러의 요청 처리 전에 실행되어,
    // 뷰에 전달할 모델에 "profile"이라는 이름으로 데이터를 담아줌
    public ProfileDTO addProfileToModel(HttpSession session) {
        // 현재 로그인된 회원 정보를 세션에서 꺼냄
        t_member logined = (t_member) session.getAttribute("member");
        
        // 로그인 상태라면
        if (logined != null) {
            // 프로필 서비스에서 회원 ID로 프로필 정보를 조회해서 반환
            // 이 데이터가 모델에 "profile" 이름으로 담겨 뷰에서 사용 가능
            return profileService.getProfileInfo(logined.getMb_id());
        }
        // 로그인 안 된 경우 null 반환 -> 모델에 데이터가 추가되지 않음
        return null;
    }
}
