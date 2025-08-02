package com.smhrd.web.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.smhrd.web.dto.FeedWithImgDTO;
import com.smhrd.web.entity.t_feed;
import com.smhrd.web.mapper.FeedMapper;

@Service
public class FeedServiceImpl implements FeedService{

	@Autowired
	FeedMapper feedMapper;
	@Autowired
	CloudinaryService cloudinaryService;
	
	@Override
	public ArrayList<t_feed> getFeedByMemId(String mb_id) {
		ArrayList<t_feed> feeds = feedMapper.selectFeedByMemId(mb_id);
		return feeds;
	}

	@Override
	public List<FeedWithImgDTO> getImgUrls(List<t_feed> feeds) {
		
		List<FeedWithImgDTO> result = new ArrayList<>();
		
		 for (t_feed feed : feeds) {
		        List<String> imgUrls = feedMapper.selectFeedImgByFeedIdx(feed.getFeed_idx());
		        FeedWithImgDTO dto = new FeedWithImgDTO();
		        dto.setFeed(feed);
		        dto.setImageUrls(imgUrls);
		        result.add(dto);
		 }

		return result;
	}

	@Override
	public void saveFeed(t_feed feed, List<MultipartFile> files) throws IOException {
		feedMapper.saveFeed(feed); // feed 객체를 활용해 db에 튜플을 추가하고 feed 객체에 idx를 등록
		int feed_idx = feed.getFeed_idx(); // 등록된 idx 꺼내오기
		List<String> imgUrls =  cloudinaryService.uploadFiles(files); // 클라우디너리에 이미지 등록하고 url 받아오기
		feedMapper.saveFeedImg(feed_idx, imgUrls);
		
	}

}
