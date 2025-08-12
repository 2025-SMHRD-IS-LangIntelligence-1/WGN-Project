
package com.smhrd.web.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.smhrd.web.dto.ProfileDTO;
import com.smhrd.web.dto.FavoriteresDTO;
import com.smhrd.web.config.AsyncConfig;
import com.smhrd.web.dto.FeedWithImgDTO;
import com.smhrd.web.dto.GoingresDTO;
import com.smhrd.web.entity.t_favorite;
import com.smhrd.web.entity.t_going;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.mapper.RestaurantMapper;
import com.smhrd.web.entity.t_notification;
import com.smhrd.web.service.CloudinaryService;
import com.smhrd.web.service.FavoriteService;
import com.smhrd.web.service.FeedService;
import com.smhrd.web.service.GoingService;
import com.smhrd.web.service.MemberService;
import com.smhrd.web.service.NotificationService;

import jakarta.servlet.http.HttpSession;

@RequestMapping("/profile")
@Controller
public class ProfileController {

    private final CloudinaryService cloudinaryService;
    
	@Autowired
	FeedService feedService;
	@Autowired
	MemberService memberService;
	
	@Autowired
	FavoriteService favoriteService;
	
	@Autowired
	GoingService goingService;
	
	@Autowired
	RestaurantMapper restaurantmapper;
	
	@Autowired
	NotificationService notificationService;

    ProfileController(CloudinaryService cloudinaryService, AsyncConfig asyncConfig) {
        this.cloudinaryService = cloudinaryService;
    }
	
    @GetMapping("/myPage")
    public String myPage(HttpSession session, Model model) {
        
    	// 로그인 체크
    	boolean loginCheck = memberService.loginCheck(session);
		
		if (!loginCheck) {
			return "redirect:/member/login";
		}
    	
		// 세션에서 로그인 정보 가져오기
    	t_member logined = (t_member) session.getAttribute("member");
    	String mb_id = logined.getMb_id();
    	
        // 내 아이디로 프로필 페이지 보여주기
        return "redirect:/profile/" + mb_id;
    }
    
    @GetMapping("/{mb_id}")
    public String showMyPage(@PathVariable String mb_id, HttpSession session, Model model) {
    	System.out.println(mb_id);
    	
    	// 로그인 체크
    	boolean loginCheck = memberService.loginCheck(session);
		
		if (!loginCheck) {
			return "redirect:/member/login";
		}
		
		// 세션에서 로그인한 사용자 정보 가져오기
        t_member logined = (t_member) session.getAttribute("member");
     	String myId = logined.getMb_id();
        
        // 마이페이지 여부 확인
        boolean isMyPage = logined.getMb_id().equals(mb_id);
        model.addAttribute("isMypage", isMyPage);
        
        System.out.println(myId + mb_id);
        // 해당 사용자가 마이페이지 주인을 팔로우하고 있는지 여부를 체크하는 메서드
 		boolean isFollowing = memberService.isFollowing(myId, mb_id);
 		
 		model.addAttribute("isFollowing", isFollowing);
 		model.addAttribute("mb_id", mb_id);
     	
        // 프로필 정보 저장
        ProfileDTO profile = memberService.getProfileInfo(mb_id);
        model.addAttribute("profile", profile);
        
        // 사용자가 작성한 피드 리스트 저장
        List<FeedWithImgDTO> feeds = feedService.getFeedByMemId(mb_id);
        
        // 사용자의 피드 리스트를 넣으면 각 피드 별로 이미지 리스트가 포함된 DTO를 생성해주는 메서드
        List<FeedWithImgDTO> feedDTOList = feedService.getImgUrls(feeds);
    
        for (FeedWithImgDTO feed : feedDTOList) {
            System.out.println("feed_idx in controller = " + feed.getFeed_idx());
        }
        
        Collections.reverse(feedDTOList);
	    model.addAttribute("feedDTOList", feedDTOList);
	    
	    
	    // 사용자가 랭킹 음식점id 가져오기
	    List<t_favorite> myfavorite = favoriteService.getmyFavorite(mb_id);
	    List<Integer> residx = myfavorite.stream()
	    	    .map(t_favorite::getRes_idx)
	    	    .collect(Collectors.toList());
	    
	    // 회원이 랭킹 등록한 음식점 데이터 가져오기
	    List<FavoriteresDTO> myfavoriteres = restaurantmapper.myfavoriteres(residx, mb_id);
	    model.addAttribute("myfavoriteres", myfavoriteres);
	    
	    // 사용자 찜 음식점 id 가져오기
	    List<t_going> mygoing = goingService.getmygoing(mb_id);
	    
	    List<Integer> goingresidx = mygoing.stream()
	    	    .map(t_going::getRes_idx)
	    	    .collect(Collectors.toList());
	    
	    System.out.println("✔ goingresidx = " + goingresidx); // 전달할 res_idx 리스트 확인
	    List<GoingresDTO> mygoingres = restaurantmapper.mygoingres(goingresidx, mb_id);
	    model.addAttribute("mygoingres", mygoingres);
	    
	    System.out.println("feed_idx in controller = " + mygoingres.size());
	    
        return "profile/myPage";
    }
	
	@GetMapping("/notifications")
	public String showNotifications(HttpSession session, Model model) {
		
		// 로그인 체크
    	boolean loginCheck = memberService.loginCheck(session);
		
		if (!loginCheck) {
			return "redirect:/member/login";
		}
		
		// 세션에서 로그인한 사용자 정보 가져오기
        t_member logined = (t_member) session.getAttribute("member");
     	String myId = logined.getMb_id();
		
     	List<t_notification> notiList = notificationService.showRecentNoti(myId);
     	
     	model.addAttribute("notifications", notiList);
		
     	return "profile/notifications";
	}	
	
	@PostMapping("/update")
	public String updateProfile(HttpSession session,
			@RequestParam("nickname") String nickname,
			@RequestParam("intro") String intro,
			@RequestParam("file") MultipartFile file) throws IOException {
		
		// 로그인 체크
    	boolean loginCheck = memberService.loginCheck(session);
		
		if (!loginCheck) {
			return "redirect:/member/login";
		}
		
		// 세션에서 로그인한 사용자 정보 가져오기
        t_member logined = (t_member) session.getAttribute("member");
     	String myId = logined.getMb_id();
		
		// 리스트에 파일 추가
		List<MultipartFile> files = new ArrayList<MultipartFile>();
		files.add(file);
		
		String url;
		
		// 만약에 파일이 업로드 되지 않으면 
		if (files == null || files.isEmpty()) {
			memberService.update(myId, nickname, intro);
		} else {
		    List<String> urls = cloudinaryService.uploadFiles(files);

		    if (urls != null && !urls.isEmpty()) {
		        url = urls.get(0);
		        memberService.updateWithImg(myId, nickname, intro, url);
		    } else {
		        // 업로드 실패나 예상 못한 상황
		    	memberService.update(myId, nickname, intro);
		        System.err.println("Cloudinary 업로드 결과가 비어 있음");
		    }
		}
		
		return "redirect:/profile/myPage";
	}
	
}
