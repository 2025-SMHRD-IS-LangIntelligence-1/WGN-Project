package com.smhrd.web.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.smhrd.web.dto.FeedWithImgDTO;
import com.smhrd.web.entity.t_feed;

public interface FeedService {
	
	ArrayList<t_feed> getFeedByMemId(String mb_id);

	public void saveFeed(t_feed feed, List<MultipartFile> files) throws IOException;

	List<FeedWithImgDTO> getImgUrls(List<t_feed> feeds);
	
}
