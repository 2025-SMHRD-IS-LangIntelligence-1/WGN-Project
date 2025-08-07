package com.smhrd.web.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.web.dto.RestaurantDTO;
import com.smhrd.web.mapper.RestaurantMapper;

@Service
public class RestaurantServiceImpl implements RestaurantService {

	@Autowired
	RestaurantMapper restaurantMapper;

	@Override
	public List<RestaurantDTO> searchByMultipleKeyword(String keyword) {
		
		if(keyword == null || keyword.trim().isEmpty()) {
	        return List.of();
	    }

		String[] keywords = keyword.trim().split("\\s+"); 
	    
		List<RestaurantDTO> resInfoList = restaurantMapper.searchByMultipleKeywords(keywords);
		
		return resInfoList;
	}

	@Override
	public RestaurantDTO getByResIdx(int res_idx) {
		
		RestaurantDTO resInfo = restaurantMapper.getByResIdx(res_idx);
		
		return resInfo;
	}
	
}
