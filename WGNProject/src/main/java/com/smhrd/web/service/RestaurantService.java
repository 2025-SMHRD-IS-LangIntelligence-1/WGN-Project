package com.smhrd.web.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.smhrd.web.dto.RestaurantDTO;

public interface RestaurantService {

	public List<RestaurantDTO> searchByKeywords(String[] keywords);
	
}
