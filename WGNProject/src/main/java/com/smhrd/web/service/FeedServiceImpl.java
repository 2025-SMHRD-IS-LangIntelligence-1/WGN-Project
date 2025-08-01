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
	public ArrayList<t_feed> showFeedByMemId(String mb_id) {
		ArrayList<t_feed> feeds = feedMapper.selectFeedByMemId(mb_id);
		return feeds;
	}

	@Override
	public void addFeed() {
		// TODO Auto-generated method stub
		
	}

}
