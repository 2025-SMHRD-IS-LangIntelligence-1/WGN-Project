package com.smhrd.web.service;

import java.util.ArrayList;

import com.smhrd.web.entity.t_feed;

public interface FeedService {
	
	public void addFeed();

	ArrayList<t_feed> showFeedByMemId(String mb_id);
	
}
