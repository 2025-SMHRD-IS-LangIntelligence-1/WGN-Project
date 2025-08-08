package com.smhrd.web.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.smhrd.web.config.AsyncConfig;
import com.smhrd.web.dto.CommentDTO;
import com.smhrd.web.dto.FeedPreviewDTO;
import com.smhrd.web.dto.FeedWithImgDTO;
import com.smhrd.web.entity.t_comment;
import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.mapper.FeedMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FeedServiceImpl implements FeedService {

	@Autowired
	FeedMapper feedMapper;
	@Autowired
	CloudinaryService cloudinaryService;
	@Autowired
	NotificationService notificationService;

	FeedServiceImpl(AsyncConfig asyncConfig) {
	}

	@Override
	public ArrayList<FeedWithImgDTO> getFeedByMemId(String mb_id) {
		ArrayList<FeedWithImgDTO> feeds = feedMapper.selectFeedByMemId(mb_id);
		return feeds;
	}

	@Override
	public List<FeedWithImgDTO> getImgUrls(List<FeedWithImgDTO> feeds) {
		for (FeedWithImgDTO feed : feeds) {
			List<String> imgUrls = feedMapper.selectFeedImgByFeedIdx(feed.getFeed_idx());
			feed.setImageUrls(imgUrls);
		}
		return feeds; // 수정된 원본 리스트 그대로 반환
	}

	@Override
	public void saveFeed(t_feed feed, List<MultipartFile> files) throws IOException {

		feedMapper.saveFeed(feed); // feed 객체를 활용해 db에 튜플을 추가하고 feed 객체에 idx를 등록

		int feed_idx = feed.getFeed_idx(); // 등록된 idx 꺼내오기

		System.out.println("업로드된 MultipartFile 수: " + files.size());
		List<String> imgUrls = cloudinaryService.uploadFiles(files); // 클라우디너리에 이미지 등록하고 url 받아오기

		System.out.println("클라우디너리에서 반환된 이미지 URL 수: " + imgUrls.size());
		feedMapper.saveFeedImg(feed_idx, imgUrls);
	}

	@Override
	public FeedWithImgDTO getFeedByFeedIdx(int feedIdx) {
		FeedWithImgDTO feed = feedMapper.selectFeedByIdx(feedIdx);
		List<String> feedImg = feedMapper.selectFeedImgByFeedIdx(feedIdx);
		feed.setImageUrls(feedImg);
		return feed;
	}

	@Override
	public void saveComment(int feed_idx, String feed_content, t_member logined) {

		t_comment comment = new t_comment();

		String mb_id = logined.getMb_id();
		String mb_nick = logined.getMb_nick();

		comment.setFeed_idx(feed_idx);
		comment.setMb_id(mb_id);
		comment.setMb_nick(mb_nick);
		comment.setCmt_content(feed_content);

		feedMapper.saveComment(comment);

		String sender = mb_id;
		String receiver = feedMapper.selectFeedByIdx(feed_idx).getMb_id();

		notificationService.makeCommentNoti(sender, receiver, feed_idx, feed_content);
	}

	@Override
	public List<CommentDTO> getCmtByFeedIdx(int feedIdx) {
		log.info("getCmtByFeedIdx 함수 실행");
		List<CommentDTO> comments = feedMapper.getCmtByfeedIdx(feedIdx);
		log.info("가져온 코멘트 수 : " + comments.size());
		return comments;
	}

	@Override
	public void deleteFeed(int feed_idx) {
		feedMapper.deleteFeed(feed_idx);

	}

	@Override
	@Transactional
	public int addFeedLike(int feed_idx, String mb_id) {
		try {
			// 1. 좋아요 기록 추가 (중복 시 예외 발생)
			feedMapper.addFeedLike(feed_idx, mb_id);

			// 2. 좋아요 알림 생성 (성공 시에만)
			String sender = mb_id;
			String receiver = feedMapper.selectFeedByIdx(feed_idx).getMb_id();
			notificationService.makeLikeNoti(sender, receiver, feed_idx);

		} catch (DuplicateKeyException e) {
			// 이미 좋아요 되어 있음 → 알림 생성, 좋아요 수 증가는 안 함
		}

		// 최종 좋아요 수 피드에 반영
		feedMapper.incrementFeedLikes(feed_idx);

		return feedMapper.countFeedLike(feed_idx);
	}

	@Override
	public int deleteFeedLike(int feed_idx, String mb_id) {

		feedMapper.deleteFeedLike(feed_idx, mb_id);

		// 최종 좋아요 수 피드에 반영
		feedMapper.decrementFeedLikes(feed_idx);
		
		return feedMapper.countFeedLike(feed_idx);
		
	}

	@Override
	public List<FeedPreviewDTO> getFeedsByFeedIdx(List<Integer> feedIdxList) {

		List<FeedPreviewDTO> feedList = new ArrayList<>();

		for (int feedIdx : feedIdxList) {
			FeedPreviewDTO feed = feedMapper.getFeedsByFeedIdx(feedIdx);
			feedList.add(feed);
			List<String> img = feedMapper.selectFeedImgByFeedIdx(feedIdx);
			feed.setImageUrls(img);
		}

		return feedList;
	}

}
