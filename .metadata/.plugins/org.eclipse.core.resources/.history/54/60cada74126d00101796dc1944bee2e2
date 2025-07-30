package com.smhrd.web.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.web.entity.Feed;
import com.smhrd.web.mapper.FeedMapper;

@Service
public class FeedServiceImpl implements FeedService{

	@Autowired
	FeedMapper feedMapper;
	
	@Override
	public ArrayList<Feed> showFeed() {
		ArrayList<Feed> feeds = feedMapper.selectFeed();
		return feeds;
	}

	@Override
	public void addFeed() {
		// TODO Auto-generated method stub
		
	}

}
