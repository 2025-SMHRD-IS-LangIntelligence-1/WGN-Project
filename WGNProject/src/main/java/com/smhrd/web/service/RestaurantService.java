package com.smhrd.web.service;

import java.util.List;

import com.smhrd.web.dto.RestaurantDTO;


public interface RestaurantService {

	public List<RestaurantDTO> searchByMultipleKeyword(String keyword);
	
	public RestaurantDTO getByResIdx(int res_idx);
	
}
