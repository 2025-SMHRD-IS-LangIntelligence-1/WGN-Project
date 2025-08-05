package com.smhrd.web.controller;

import java.util.List;

import org.apache.catalina.mapper.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.smhrd.web.dto.RestaurantDTO;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.entity.t_res_img;
import com.smhrd.web.service.MemberService;
import com.smhrd.web.service.RestaurantService;
import com.smhrd.web.entity.t_restaurant;
import com.smhrd.web.entity.t_review;
import com.smhrd.web.mapper.RestaurantMapper;

import org.springframework.ui.Model;

import jakarta.servlet.http.HttpSession;

@RequestMapping("/restaurant")
@Controller
public class RestaurantController {
	@Autowired
	private RestaurantMapper resmapper;
	
	@Autowired
	MemberService memberService;
	
	
	
    @GetMapping
    public String resdetail(@RequestParam("res_idx") int res_idx, HttpSession session, Model model ) {
    	
    	// 로그인 체크
    	boolean loginCheck = memberService.loginCheck(session);
		
		if (!loginCheck) {
			return "member/login";
		}
    	
		
		t_restaurant res =  resmapper.resdetail(res_idx);
		
		model.addAttribute("res",res);
		
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
		
		List<t_review> res_review = resmapper.res_review(res_idx);
		
		model.addAttribute("res_review", res_review);
		
		
        return "restaurant/restaurant";
    }
}