package com.smhrd.web.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.smhrd.web.dto.FeedWithImgDTO;
import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_member;

public interface FeedService {
	
	ArrayList<FeedWithImgDTO> getFeedByMemId(String mb_id);

	public void saveFeed(t_feed feed, List<MultipartFile> files) throws IOException;

	List<FeedWithImgDTO> getImgUrls(List<FeedWithImgDTO> feeds);

	FeedWithImgDTO getFeedByFeedIdx(int feedIdx);

	void saveComment(int feed_idx, String feed_content, t_member logined);
	
}
