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

@Controller
@RequestMapping("/search")
public class SearchController {

	@Autowired
    private RestaurantService restaurantService;
	
	@GetMapping
	public String goSearch() {
		return "search";
	}

	@GetMapping("/retaurant")
	@ResponseBody
	public List<RestaurantDTO> searchRestaurants(@RequestParam("keyword") String keyword) {
	    String[] keywords = keyword.split("\\s+"); 
	    List<RestaurantDTO> resInfoList = restaurantService.searchByKeywords(keywords);
	    
	    return resInfoList;
	}
	
}