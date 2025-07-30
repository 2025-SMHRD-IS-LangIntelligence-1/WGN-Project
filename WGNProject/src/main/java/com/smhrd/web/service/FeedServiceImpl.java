package com.smhrd.web.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.web.entity.t_feed;
import com.smhrd.web.mapper.FeedMapper;

@Service
public class FeedServiceImpl implements FeedService{

	@Autowired
	FeedMapper feedMapper;
	
	@Override
	public ArrayList<t_feed> showFeed() {
		ArrayList<t_feed> feeds = feedMapper.selectFeed();
		return feeds;
	}

	@Override
	public void addFeed() {
		// TODO Auto-generated method stub
		
	}

}
