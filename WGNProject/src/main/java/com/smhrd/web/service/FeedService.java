package com.smhrd.web.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.smhrd.web.dto.CommentDTO;
import com.smhrd.web.dto.FeedPreviewDTO;
import com.smhrd.web.dto.FeedWithImgDTO;
import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_member;

public interface FeedService {
	
	ArrayList<FeedWithImgDTO> getFeedByMemId(String mb_id);

	public void saveFeed(t_feed feed, List<MultipartFile> files) throws IOException;

	List<FeedWithImgDTO> getImgUrls(List<FeedWithImgDTO> feeds);

	FeedWithImgDTO getFeedByFeedIdx(int feedIdx);

	void saveComment(int feed_idx, String feed_content, t_member logined);

	List<CommentDTO> getCmtByFeedIdx(int feedIdx);

	void deleteFeed(int feed_idx);

	int addFeedLike(int feed_idx, String mb_id);
	
	int deleteFeedLike(int feed_idx, String mb_id);

	List<FeedPreviewDTO> getFeedsByFeedIdx(List<Integer> feedIdxList);

	List<Integer> getDefaultFeeds();

	void updateMeta(Long feedIdx, String feedContent, Integer ratings);

	void deleteAllImages(Long feedIdx);

	void saveImages(Long feedIdx, List<MultipartFile> images);

	void deleteSelectedImages(Long feedIdx, List<String> deleteImgUrls);

	





	
}
