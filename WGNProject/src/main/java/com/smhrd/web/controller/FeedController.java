package com.smhrd.web.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.hc.core5.http.HttpStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.smhrd.web.dto.CommentDTO;
import com.smhrd.web.dto.FeedPreviewDTO;
import com.smhrd.web.dto.FeedResponseDTO;
import com.smhrd.web.dto.FeedWithImgDTO;
import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.dto.RestaurantDTO;
import com.smhrd.web.entity.t_favorite;
import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.mapper.FavoriteMapper;
import com.smhrd.web.mapper.FeedMapper;
import com.smhrd.web.service.CloudinaryService;
import com.smhrd.web.service.FavoriteService;
import com.smhrd.web.service.FeedService;
import com.smhrd.web.service.MemberService;
import com.smhrd.web.service.RestaurantService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("feed")
@Controller
@Slf4j
public class FeedController {

	@Autowired
	FeedService feedService;
	@Autowired
	CloudinaryService cloudinaryService;
	@Autowired
	MemberService memberService;
	@Autowired
	RestaurantService restaurantService;
	@Autowired
	FavoriteMapper favoritemapper;
	@Autowired
	FavoriteService favoriteService;
	@Autowired
	FeedMapper feedMapper;

	FeedController(CloudinaryService cloudinaryService) {
		this.cloudinaryService = cloudinaryService;
	}

	@GetMapping
	public String feedDetail(HttpSession session, @RequestParam("feed_idx") int feedIdx, Model model)
			throws JsonProcessingException {

		// 로그인 되어 있는지 체크
		boolean loginCheck = memberService.loginCheck(session);

		// 로그인이 되어 있지 않으면 로그인 페이지로
		if (!loginCheck) {
			return "member/login";
		}

		// 세션에서 로그인한 멤버 정보 꺼내오기
		t_member logined = (t_member) session.getAttribute("member");
		String mbId = logined.getMb_id();

		// feedIdx를 이용해 DB에서 피드 상세 데이터 조회
		FeedWithImgDTO feed = feedService.getFeedByFeedIdx(feedIdx);

		// 피드에서 피드 주인 아이디 꺼내오기
		String feedOwnerId = feed.getMb_id();

		// 피드 주인 정보 가져오기
		ProfileDTO feedOwnerProfile = memberService.getProfileInfo(feedOwnerId);

		// 해당 사용자가 피드 주인을 팔로우하고 있는지 여부를 체크하는 메서드
		boolean isFollowing = memberService.isFollowing(mbId, feedOwnerId);

		model.addAttribute("isFollowing", isFollowing);
		model.addAttribute("feedOwnerProfile", feedOwnerProfile);
		

		// 음식점 정보 가져오기
		int resIdx = feed.getRes_idx();
		RestaurantDTO resInfo = restaurantService.getByResIdx(resIdx);

		// 댓글 정보 가져오기
		List<CommentDTO> comments = feedService.getCmtByFeedIdx(feedIdx);

		// 해당 사용자가 피드를 좋아하는지 여부를 체크하는 메서드
		boolean isLiking = memberService.isLiking(mbId, feedIdx);
		
		model.addAttribute("feed", feed);
		model.addAttribute("resInfo", resInfo);
		model.addAttribute("comments", comments);
		model.addAttribute("isLiking", isLiking);

		// 사용자 로그 저장
		memberService.saveLog(mbId, resIdx, "클릭");

		return "feed/feed";
	}

	@GetMapping("/addFeed")
	public String goAddFeed(HttpSession session) {

		// 로그인 되어 있는지 체크
		boolean loginCheck = memberService.loginCheck(session);

		// 로그인이 되어 있지 않으면 로그인 페이지로
		if (!loginCheck) {
			return "member/login";
		}

		return "feed/addFeed";
	}

	@PostMapping("/upload")
	public String uploadFeed(t_feed feed, @RequestParam("files") List<MultipartFile> files,
			@RequestParam("res_idx") Integer res_idx, HttpSession session,
			@RequestParam(value = "rank_toggle", required = false) String rankToggle) {

		// 넘어온 파일 개수 로깅
		System.out.println("업로드 요청 파일 개수: " + files.size());

		// 로그인 되어 있는지 체크
		boolean loginCheck = memberService.loginCheck(session);

		// 로그인이 되어 있지 않으면 로그인 페이지로
		if (!loginCheck) {
			return "member/login";
		}

		// 세션에서 멤버 정보 가져오기
		t_member member = (t_member) session.getAttribute("member");

		String mb_id = member.getMb_id();

		feed.setMb_id(mb_id);
		feed.setRes_idx(res_idx);
		Double ratings = feed.getRatings();
		System.out.println("피드 별점: " + feed.getRatings());
		System.out.println("피드 별점: " + ratings);

		try {
			feedService.saveFeed(feed, files);
		} catch (IOException e) {
			log.error("파일 업로드 중 오류 발생", e);
		}

		// 랭킹 등록
		if ("on".equals(rankToggle)) {
			t_favorite favorite = new t_favorite();
			favorite.setMb_id(mb_id);
			favorite.setRes_idx(res_idx);
			favorite.setFav_rating(feed.getRatings());
			favoriteService.insertFavorite(favorite);
		}

		// 사용자 로그 저장
		memberService.saveLog(mb_id, res_idx, "글작성");

		return "redirect:/";
	}

	// 등록 음식점 체크
	@GetMapping("/rescheck")
	@ResponseBody
	public ResponseEntity<Boolean> checkFavorite(@RequestParam("res_idx") int res_idx, HttpSession session) {
		// 세션에서 로그인 정보 가져오기
		t_member member = (t_member) session.getAttribute("member");

		String mb_id = member.getMb_id();
		System.out.println("넘어온 res_idx: " + res_idx);
		// 중복 확인
		boolean exists = favoriteService.checkFavoriteExists(mb_id, res_idx);
		return ResponseEntity.ok(exists);
	}
	
	@PostMapping("/update")
	public String updateFeed(
	        @RequestParam("feed_idx") Long feedIdx,
	        @RequestParam("feed_content") String feedContent,
	        @RequestParam(value = "ratings", required = false) Integer ratings,
	        @RequestParam("imageMode") String imageMode,
	        @RequestParam(value = "delete_img_urls", required = false) List<String> deleteImgUrls,
	        @RequestParam(value = "images", required = false) List<MultipartFile> images,
	        HttpSession session,
	        RedirectAttributes ra
	) {
		
	    System.out.println("=== [UPDATE FEED] 요청 들어옴 ===");
	    System.out.println("feed_idx       = " + feedIdx);
	    System.out.println("feed_content   = " + (feedContent!=null ? feedContent.substring(0, Math.min(60, feedContent.length())) : "null"));
	    System.out.println("ratings        = " + ratings);
	    System.out.println("imageMode      = " + imageMode);
		
	    System.out.println("deleteImgUrls  = " + (deleteImgUrls==null ? "null" : deleteImgUrls.size()+"개 -> " + deleteImgUrls));
	    if (images == null) {
	        System.out.println("images         = null");
	    } else {
	        System.out.println("images.size    = " + images.size());
	        for (int i=0;i<images.size();i++){
	            MultipartFile f = images.get(i);
	            System.out.println("  - images[" + i + "]: name=" + f.getName()
	                    + ", original=" + f.getOriginalFilename()
	                    + ", size=" + (f.isEmpty()?0:f.getSize())
	                    + ", isEmpty=" + f.isEmpty());
	        }
	    }
	    
	    // 로그인 사용자 ID 가져오기 (예: 세션에서)
	    t_member logined = (t_member) session.getAttribute("member");
    	String mbId = logined.getMb_id();
	    System.out.println("session.mb_id  = " + mbId);

	    if (mbId == null) {
	        System.out.println(">> 로그인 안됨 → redirect:/feed?feed_idx=" + feedIdx);
	        ra.addFlashAttribute("error", "로그인이 필요합니다.");
	        return "redirect:/feed?feed_idx=" + feedIdx; // 이 경로가 실제로 매핑돼 있는지도 꼭 확인!
	    }

	    try {
	        System.out.println(">> 1) 메타 업데이트 시작");
	        feedService.updateMeta(feedIdx, feedContent, ratings);
	        System.out.println(">> 1) 메타 업데이트 끝");

	        boolean replaceAll = "REPLACE_ALL".equalsIgnoreCase(imageMode);
	        boolean hasNewFiles = images != null && images.stream().anyMatch(f -> f != null && !f.isEmpty());
	        System.out.println("replaceAll     = " + replaceAll);
	        System.out.println("hasNewFiles    = " + hasNewFiles);

	        if (replaceAll) {
	            System.out.println(">> 2) 모드=REPLACE_ALL → 기존 이미지 전체 삭제");
	            feedService.deleteAllImages(feedIdx);

	            if (hasNewFiles) {
	                System.out.println(">> 3) 새 이미지 저장 시작 (REPLACE_ALL)");
	                feedService.saveImages(feedIdx, images);
	                System.out.println(">> 3) 새 이미지 저장 끝 (REPLACE_ALL)");
	            } else {
	                System.out.println(">> 3) 새 이미지 없음 (REPLACE_ALL)");
	            }
	        } else { // APPEND
	            System.out.println(">> 2) 모드=APPEND");

	            if (deleteImgUrls != null && !deleteImgUrls.isEmpty()) {
	                System.out.println(">> 2-1) 선택 삭제 실행: " + deleteImgUrls.size() + "개");
	                feedService.deleteSelectedImages(feedIdx, deleteImgUrls);
	            } else {
	                System.out.println(">> 2-1) 선택 삭제 없음");
	            }

	            if (hasNewFiles) {
	                System.out.println(">> 3) 새 이미지 추가 시작 (APPEND)");
	                feedService.saveImages(feedIdx, images);
	                System.out.println(">> 3) 새 이미지 추가 끝 (APPEND)");
	            } else {
	                System.out.println(">> 3) 새 이미지 없음 (APPEND)");
	            }
	        }

	        ra.addFlashAttribute("success", "피드가 수정되었습니다.");
	        System.out.println("=== [UPDATE FEED] 성공 → redirect:/feed?feed_idx=" + feedIdx + " ===");
	    } catch (Exception e) {
	        System.out.println("=== [UPDATE FEED] 실패 ===");
	        e.printStackTrace();
	        ra.addFlashAttribute("error", "피드 수정 중 오류가 발생했습니다: " + e.getMessage());
	    }

	    return "redirect:/feed?feed_idx=" + feedIdx;
	}
	

	@PostMapping("/delete")
	public String deleteFeed(HttpSession session, @RequestParam("feed_idx") int feed_idx) {

		// 해당 피드 정보 불러오기
		FeedWithImgDTO feed = feedService.getFeedByFeedIdx(feed_idx);

		// url 리스트 불러오기
		List<String> urls = feed.getImageUrls();
		List<String> publicIds = new ArrayList<>();

		// publicId 추출 후 파일 삭제하기
		for (String url : urls) {
			String publicId = cloudinaryService.extractPublicId(url);
			cloudinaryService.deleteFile(publicId);
		}

		// DB에서 피드 삭제
		feedService.deleteFeed(feed_idx);

		return "redirect:/profile/myPage";
	}

	@PostMapping("/comment")
	public String saveComment(@RequestParam("feed_idx") int feed_idx, @RequestParam("cmt_content") String cmt_content,
			HttpSession session, HttpServletRequest request, Model model) {

		// 여기서 세션에서 로그인 유저 꺼냄
		t_member logined = (t_member) session.getAttribute("member");

		if (logined == null) {
			return "redirect:/member/login"; // 로그인 안 된 경우
		}

		String mb_id = logined.getMb_id();

		feedService.saveComment(feed_idx, cmt_content, logined);
		FeedWithImgDTO feed = feedService.getFeedByFeedIdx(feed_idx);
		int res_idx = feed.getRes_idx();

		System.out.println("Feedcontroller : 댓글 저장 완료");

		return "redirect:" + request.getHeader("Referer");
	}

	@PostMapping("/addFeedLike")
	@ResponseBody
	public int addFeedLike(@RequestBody int feed_idx, HttpSession session) {

		// 세션에서 로그인 유저 꺼냄
		t_member logined = (t_member) session.getAttribute("member");
		String mb_id = logined.getMb_id();

		// 해당 피드 정보 불러오기
		FeedWithImgDTO feed = feedService.getFeedByFeedIdx(feed_idx);
		int res_idx = feed.getRes_idx();

		int feedLikeNum = feedService.addFeedLike(feed_idx, mb_id);
		memberService.saveLog(mb_id, res_idx, "좋아요");
		return feedLikeNum;
	}

	@PostMapping("/deleteFeedLike")
	@ResponseBody
	public int deleteFeedLike(@RequestBody int feed_idx, HttpSession session) {

		// 세션에서 로그인 유저 꺼냄
		t_member logined = (t_member) session.getAttribute("member");
		String mb_id = logined.getMb_id();

		int feedLikeNum = feedService.deleteFeedLike(feed_idx, mb_id);
		return feedLikeNum;
	}

	@PostMapping("/previews")
	@ResponseBody
	public FeedResponseDTO getFeedPreviews(@RequestBody List<Integer> feedIdxList, HttpSession session) {

		t_member member = (t_member) session.getAttribute("member");

		FeedResponseDTO response = new FeedResponseDTO();

		// feedIdxList를 받아서 해당 feed 리스트를 조회 후 반환
		List<FeedPreviewDTO> feeds = feedService.getFeedsByFeedIdx(feedIdxList);
		response.setFeeds(feeds);

		if (member == null) {
			response.setFollowingMemList(new ArrayList<>());
			response.setLikedFeedList(new ArrayList<>());
			return response;
		} else {

			String mb_id = member.getMb_id();

			// 이 멤버가 팔로우 하고 있는 모든 멤버 id를 가져오는 메서드
			List<String> followingMemList = memberService.getAllfollowMem(mb_id);

			// 이 멤버가 좋아하는 모든 피드 idx를 가져오는 메서드
			List<Integer> likedFeedList = memberService.getAllLikedFeed(mb_id);

			response.setFollowingMemList(followingMemList);
			response.setLikedFeedList(likedFeedList);

			return response;
		}

	}

}
