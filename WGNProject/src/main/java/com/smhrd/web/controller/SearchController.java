package com.smhrd.web.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.smhrd.web.dto.RestaurantDTO;
import com.smhrd.web.service.RestaurantService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/search")
public class SearchController {
	
	@Autowired
    private RestaurantService restaurantService;
	
	@GetMapping
	public String goSearch() {
		return "search";
	}

	@GetMapping("/restaurant")
	@ResponseBody
	public List<RestaurantDTO> searchRestaurants(@RequestParam("keyword") String keyword) {
	    log.info("searchRestaurants() 호출 - keyword: {}", keyword);
	    
	    if(keyword == null || keyword.trim().isEmpty()) {
	        log.warn("검색 키워드가 비어있음");
	        return List.of();
	    }

		String[] keywords = keyword.trim().split("\\s+"); 
	    log.debug("분리된 키워드 개수: {}", keywords.length);

	    List<RestaurantDTO> resInfoList = restaurantService.searchByKeywords(keywords);
	    if(resInfoList == null) {
	        log.warn("검색 결과가 null");
	    } else {
	        log.info("검색 결과 개수: {}", resInfoList.size());
	    }
	    
	    return resInfoList;
	}
	
}