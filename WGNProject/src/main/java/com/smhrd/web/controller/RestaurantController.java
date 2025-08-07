package com.smhrd.web.controller;

import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.Locale;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.smhrd.web.dto.ReviewDTO;
import com.smhrd.web.dto.WordCloudDTO;
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
    	
		// 세션에서 로그인 유저 꺼냄
		t_member logined = (t_member) session.getAttribute("member");		
		String mb_id = logined.getMb_id();
				
		// 음식점 정보
		t_restaurant res = resmapper.resdetail(res_idx);

		model.addAttribute("res", res);

		// 이미지
		List<t_res_img> res_img_list = resmapper.res_img(res_idx);

		// 메인 이미지와 서브 이미지 분리
		t_res_img res_main_img = res_img_list.get(0);
		List<t_res_img> res_sub_img_list = res_img_list.subList(1, res_img_list.size());

		model.addAttribute("res_main_img", res_main_img);
		model.addAttribute("res_sub_img_list", res_sub_img_list);

		// 이미지 개수
		int remaining = res_img_list.size() > 3 ? res_img_list.size() - 3 : 0;
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

		memberService.saveLog(mb_id, null, null);
		
		return "restaurant/restaurant";
	}
	
	@PostMapping("/wordcloud")
	public WordCloudDTO makeWordCloud(@RequestParam int res_idx) {
		WordCloudDTO wc = reviewService.sendResReview(res_idx);
		return wc;
	}
	
}