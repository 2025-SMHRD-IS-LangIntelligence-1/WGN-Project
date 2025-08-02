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
	public List<RestaurantDTO> searchByKeywords(String[] keywords) {
		
		List<RestaurantDTO> resInfoList = restaurantMapper.searchByMultipleKeywords(keywords);
		
		return resInfoList;
	}

}
