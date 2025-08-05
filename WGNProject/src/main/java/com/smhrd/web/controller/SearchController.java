package com.smhrd.web.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.smhrd.web.dto.RestaurantDTO;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.MemberService;
import com.smhrd.web.service.RestaurantService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/search")
public class SearchController {
	
	@Autowired
    RestaurantService restaurantService;
	@Autowired
	MemberService memberService;
	
	@GetMapping
	public String goSearch() {
		return "/search/search";
	}

	@GetMapping("/restaurant")
	@ResponseBody
	public List<RestaurantDTO> searchRestaurants(@RequestParam("keyword") String keyword) {	    

	    List<RestaurantDTO> resInfoList = restaurantService.searchByMultipleKeyword(keyword);
	    if(resInfoList == null) {
	        log.warn("검색 결과가 null");
	    } else {
	        log.info("검색 결과 개수: {}", resInfoList.size());
	    }
	    
	    return resInfoList;
	}
	
	@GetMapping("/member")
	@ResponseBody
	public List<t_member> searchMember(@RequestParam("keyword") String keyword) {
		
		List<t_member> memberList = memberService.searchByIdOrNick(keyword);
		if(memberList == null) {
	        log.warn("검색 결과가 null");
	    } else {
	        log.info("검색 결과 개수: {}", memberList.size());
	    }
		
		return memberList;
	}
	
}