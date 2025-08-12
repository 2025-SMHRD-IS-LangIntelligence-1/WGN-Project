package com.smhrd.web.controller;

import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.Locale;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.smhrd.web.dto.ReviewDTO;
import com.smhrd.web.dto.WordCloudAndRatingsDTO;
import com.smhrd.web.entity.t_convenience;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.entity.t_menu;
import com.smhrd.web.entity.t_res_img;
import com.smhrd.web.service.MemberService;
import com.smhrd.web.service.ReviewService;
import com.smhrd.web.entity.t_restaurant;
import com.smhrd.web.entity.t_running_time;
import com.smhrd.web.mapper.RestaurantMapper;

import org.springframework.ui.Model;

import jakarta.servlet.http.HttpSession;

@RequestMapping("/restaurant")
@Controller
public class RestaurantController {

	@Autowired
	private RestaurantMapper resmapper;
	@Autowired
	private ReviewService reviewService;
	@Autowired
	private MemberService memberService;
	
	@GetMapping
    public String resDetail(@RequestParam("res_idx") int res_idx, HttpSession session, Model model ) {

		// 음식점 정보
		t_restaurant res = resmapper.resdetail(res_idx);

		model.addAttribute("res", res);

		// 이미지
		List<t_res_img> res_img_list = resmapper.res_img(res_idx);
		if (res_img_list == null) res_img_list = Collections.emptyList();

		t_res_img res_main_img;
		List<t_res_img> res_sub_img_list;
		int remaining = 0;
		
		String defaultImgUrl = "https://search.pstatic.net/sunny/?src=https%3A%2F%2Fi.pinimg.com%2F736x%2F79%2F30%2F00%2F7930007e8cbda86f9828e8c3e03eca6f.jpg&type=sc960_832";
		
		if (!res_img_list.isEmpty()) {
		    // 실제 이미지가 있을 때
		    res_main_img = res_img_list.get(0);
		    res_sub_img_list = (res_img_list.size() > 1)
		            ? res_img_list.subList(1, res_img_list.size())
		            : Collections.emptyList();
		    remaining = res_img_list.size() > 3 ? res_img_list.size() - 3 : 0;
		} else {
		    // 이미지가 없을 때: 기본 이미지 세팅
		    res_main_img = new t_res_img();
		    res_main_img.setRes_img_url(defaultImgUrl); // 기본 이미지 경로

		    res_sub_img_list = Collections.emptyList();
		    remaining = 0;
		}

		// 모델에 담기
		model.addAttribute("res_main_img", res_main_img);
		model.addAttribute("res_sub_img_list", res_sub_img_list);
		model.addAttribute("remaining", remaining);

		// 리뷰
		List<ReviewDTO> res_review = reviewService.getResReview(res_idx);
		model.addAttribute("res_review", res_review);

		// 편의시설
		List<t_convenience> res_con = resmapper.res_convenience(res_idx);
		model.addAttribute("res_con", res_con);

		// 1. 영업시간 전체 조회
		List<t_running_time> res_time = resmapper.res_running_time(res_idx);

		// 2. 요일 개수로 분기 처리
		if (res_time.size() == 1) {
			// 요일 하나일 때
			model.addAttribute("singleTime", res_time.get(0));
		} else {
			// 요일이 여러 개인 경우
			String todayKor = LocalDate.now().getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.KOREAN); // 예: 월

			List<t_running_time> todayTimes = new ArrayList<>();
			List<t_running_time> otherTimes = new ArrayList<>();

			for (t_running_time time : res_time) {
				if (time.getWeekday() != null && time.getWeekday().contains(todayKor)) {
					todayTimes.add(time);
				} else {
					otherTimes.add(time);
				}
			}

			model.addAttribute("todayTimes", todayTimes);
			model.addAttribute("otherTimes", otherTimes);
		}

		// 메뉴
		List<t_menu> res_menu = resmapper.res_menu(res_idx);
		model.addAttribute("res_menu", res_menu);

		// 평점 및 워드클라우드
		WordCloudAndRatingsDTO data = resmapper.getWcAndRatingsDTO(res_idx);
		model.addAttribute("data", data);

		// 세션에서 로그인 유저 꺼냄
		t_member logined = (t_member) session.getAttribute("member");		

		
		if (logined != null) {
			String mb_id = logined.getMb_id();
			memberService.saveLog(mb_id, res_idx, "클릭");
		}
	
		return "restaurant/restaurant";
	}

}