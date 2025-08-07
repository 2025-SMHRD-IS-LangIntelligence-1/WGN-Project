package com.smhrd.web.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.smhrd.web.dto.CommentDTO;
import com.smhrd.web.dto.FeedWithImgDTO;
import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.dto.RestaurantDTO;
import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.CloudinaryService;
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
	
	private Logger logger = LoggerFactory.getLogger(getClass());
	@Autowired
	FeedService feedService;
	@Autowired
	CloudinaryService cloudinaryService;
	@Autowired
	MemberService memberService;
	@Autowired
	RestaurantService restaurantService;

	FeedController(CloudinaryService cloudinaryService) {
		this.cloudinaryService = cloudinaryService;
	}

	@GetMapping
	public String feedDetail(HttpSession session, @RequestParam("feed_idx") int feedIdx, Model model) {
		
		

        
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
		
		model.addAttribute("feed", feed);
		model.addAttribute("resInfo", resInfo);
		model.addAttribute("comments", comments);
		
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
	public String uploadFeed(@ModelAttribute t_feed feed, @RequestParam("files") List<MultipartFile> files,
			@RequestParam("res_idx") Integer res_idx, HttpSession session) {
		
		
        // ✅ 넘어온 파일 개수 로깅
	    System.out.println("📷 업로드 요청 파일 개수: " + files.size());
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
		

	    try {
	    	feedService.saveFeed(feed, files);
	    } catch (IOException e) {
	    	log.error("파일 업로드 중 오류 발생", e);
	    }
	    
		// 사용자 로그 저장
		memberService.saveLog(mb_id, res_idx, "글작성");
		
		return "redirect:/";
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
		
		int feedLikeNum = feedService.addFeedLike(feed_idx);
		memberService.saveLog(mb_id, res_idx, "좋아요");
		return feedLikeNum;
	}
	
	@PostMapping("/deleteFeedLike")
	@ResponseBody
	public int deleteFeedLike(@RequestBody int feed_idx, HttpSession session) {
		
		int feedLikeNum = feedService.deleteFeedLike(feed_idx);
		return feedLikeNum;
	}
	
	@GetMapping("/preview/{feed_idx}")
	@ResponseBody
	public Map<String, Object> getFeedDetailJson(
	    @PathVariable("feed_idx") int feedIdx,
	    HttpSession session
	) {
	    Map<String, Object> result = new HashMap<>();

	    t_member logined = (t_member) session.getAttribute("member");

	    if (logined == null) {
	        result.put("error", "unauthorized");
	        return result;  // 401 처리해도 됨
	    }

	    String mbId = logined.getMb_id();

	    // 피드 상세 데이터
	    FeedWithImgDTO feed = feedService.getFeedByFeedIdx(feedIdx);

	    // 피드 주인 정보
	    String feedOwnerId = feed.getMb_id();
	    ProfileDTO feedOwnerProfile = memberService.getProfileInfo(feedOwnerId);

	    // 팔로우 여부
	    boolean isFollowing = memberService.isFollowing(mbId, feedOwnerId);

	    // 음식점 정보
	    int resIdx = feed.getRes_idx();
	    RestaurantDTO resInfo = restaurantService.getByResIdx(resIdx);

	    // 댓글 수
	    List<CommentDTO> comments = feedService.getCmtByFeedIdx(feedIdx);
	    int commentCount = comments.size();

	    // 로그 저장
	    memberService.saveLog(mbId, resIdx, "클릭");

	    // 응답 구성
	    result.put("feed", feed);
	    result.put("feedOwnerProfile", feedOwnerProfile);
	    result.put("isFollowing", isFollowing);
	    result.put("resInfo", resInfo);
	    result.put("commentCount", commentCount);

	    return result;
	}


}
