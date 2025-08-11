package com.smhrd.web.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.smhrd.web.dto.RestaurantDTO;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.FeedService;
import com.smhrd.web.service.MemberService;
import com.smhrd.web.service.RecommendationService;
import com.smhrd.web.service.RestaurantService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/search")
public class SearchController {
	
	@Autowired
    RestaurantService restaurantService;
	@Autowired
	MemberService memberService;
	@Autowired
	RecommendationService recommendationService;
	@Autowired
	FeedService feedService;
	
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
	
	@GetMapping("/feed")
	@ResponseBody
    public List<Integer> getRecommendedFeeds(@RequestParam String query, HttpSession session) {
    	
    	System.out.println("getRecommendFeeds 메서드 실행");
    	
        t_member member = (t_member) session.getAttribute("member");
        
        String mb_id;
        
        if (member == null) {
            System.out.println("세션에 로그인 정보가 없습니다.");
            mb_id = "hyereams";
        }else {
        	mb_id = member.getMb_id();
        	
        }
        
        List<Integer> FeedIdxList = recommendationService.sendFeedForSearch(mb_id, query);
        
        System.out.println("FeedIdxList : " + FeedIdxList);
        
        return FeedIdxList;
    }
	
	@GetMapping("/res")
	@ResponseBody
	public List<RestaurantDTO> getRecommendedRes(@RequestParam String query) {
		
	    System.out.println("getRecommendedRes 실행, query: " + query);
	    List<Integer> resIdxList = recommendationService.sendQuery(query);
	    List<RestaurantDTO> resList = new ArrayList<>();
	    
	    for (int resIdx : resIdxList) {
	    	RestaurantDTO res = restaurantService.getByResIdx(resIdx);
	    	resList.add(res);
	    }
	    
	    return resList;
	}
	
}