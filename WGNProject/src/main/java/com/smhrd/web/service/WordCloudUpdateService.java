package com.smhrd.web.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.smhrd.web.mapper.RestaurantMapper;

@Service
public class WordCloudUpdateService {

	@Autowired
	RestaurantMapper restaurantMapper;


}
