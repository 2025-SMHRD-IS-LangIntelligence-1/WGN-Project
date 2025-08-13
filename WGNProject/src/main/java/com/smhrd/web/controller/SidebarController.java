package com.smhrd.web.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.smhrd.web.dto.LikefeedimgDTO;
import com.smhrd.web.dto.MycommentDTO;
import com.smhrd.web.dto.MyreviewDTO;
import com.smhrd.web.dto.RestaurantDTO;
import com.smhrd.web.entity.t_feed_img;
import com.smhrd.web.entity.t_feed_like;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.mapper.RestaurantMapper;
import com.smhrd.web.service.MemberService;
import com.smhrd.web.mapper.SidebarMapper;

import org.springframework.ui.Model;
import jakarta.servlet.http.HttpSession;
import lombok.Data;

@Controller
@RequestMapping("/sidebar")
public class SidebarController {
	
	@Autowired
	MemberService memberService;
	@Autowired
	SidebarMapper sidebarmapper;
	
	@GetMapping("/likes/json")
	@ResponseBody
	public ResponseEntity<?> getLikedFeedsJson(HttpSession session) {
	    boolean loginCheck = memberService.loginCheck(session);
	    if (!loginCheck) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
	                             .body(Map.of("error", "로그인이 필요합니다."));
	    }

	    t_member logined = (t_member) session.getAttribute("member");
	    String mb_id = logined.getMb_id();

	    List<LikefeedimgDTO> likefeedimg = sidebarmapper.getLikedFeedThumbnails(mb_id);

	    return ResponseEntity.ok(likefeedimg); // JSON 자동 변환
	}
	
	 @GetMapping("/comments/json")
	    @ResponseBody
	    public ResponseEntity<?> getMyCommentsJson(HttpSession session) {
	        boolean loginCheck = memberService.loginCheck(session);
	        if (!loginCheck) {
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
	                    .body(Map.of("error", "로그인이 필요합니다."));
	        }

	        t_member logined = (t_member) session.getAttribute("member");
	        String mb_id = logined.getMb_id();

	        List<MycommentDTO> items = sidebarmapper.getMyComments(mb_id);
	        
	        return ResponseEntity.ok(items);
	    }
	 	
	    @DeleteMapping("/{commentIdx}")
	    public ResponseEntity<?> deleteOne(@PathVariable Long commentIdx, HttpSession session) {
	        if (!memberService.loginCheck(session)) {
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
	                    .body(Map.of("error", "로그인이 필요합니다."));
	        }
	        t_member logined = (t_member) session.getAttribute("member");
	        String mbId = logined.getMb_id();

	        int n = sidebarmapper.deleteComment(mbId, commentIdx);
	        if (n == 0) {
	            // 본인 댓글이 아니거나 이미 삭제된 경우
	            return ResponseEntity.status(HttpStatus.NOT_FOUND)
	                    .body(Map.of("error", "대상 댓글이 없거나 권한이 없습니다."));
	        }
	        return ResponseEntity.ok(Map.of("deleted", 1));
	    }
	 	
	    @DeleteMapping("/bulk")
	    @ResponseBody
	    public ResponseEntity<?> deleteMyCommentsBulk(@RequestBody IdsPayload payload, HttpSession session) {
	        // 로그인 체크
	        if (!memberService.loginCheck(session)) {
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
	                    .body(Map.of("error", "로그인이 필요합니다."));
	        }
	        if (payload == null || payload.getIds() == null || payload.getIds().isEmpty()) {
	            return ResponseEntity.badRequest().body(Map.of("error", "삭제할 ID가 없습니다."));
	        }

	        // 세션에서 mb_id
	        t_member logined = (t_member) session.getAttribute("member");
	        String mbId = logined.getMb_id();

	        int deleted = sidebarmapper.deleteComments(mbId, payload.getIds());
	        return ResponseEntity.ok(Map.of("deleted", deleted));
	    }

	    @Data
	    public static class IdsPayload {
	        private List<Long> ids;
	    }
	    
	    /** 내가 작성한 리뷰 목록 */
	    @GetMapping("/reviews/json")
	    @ResponseBody
	    public ResponseEntity<?> getMyReviewsJson(HttpSession session) {
	        if (!memberService.loginCheck(session)) {
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
	                    .body(Map.of("error", "로그인이 필요합니다."));
	        }
	        t_member me = (t_member) session.getAttribute("member");
	        String mbId = me.getMb_id();

	        List<MyreviewDTO> list = sidebarmapper.getMyReviews(mbId);
	        return ResponseEntity.ok(list);
	    }
	    
	    @DeleteMapping("/{reviewIdx}")
	    public ResponseEntity<?> deletereviewOne(@PathVariable Long reviewIdx, HttpSession session) {
	        if (!memberService.loginCheck(session)) {
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
	                    .body(Map.of("error", "로그인이 필요합니다."));
	        }
	        t_member me = (t_member) session.getAttribute("member");
	        String mbId = me.getMb_id();

	        int n = sidebarmapper.deleteReview(mbId, reviewIdx);
	        if (n == 0) {
	            return ResponseEntity.status(HttpStatus.NOT_FOUND)
	                    .body(Map.of("error", "대상 리뷰가 없거나 권한이 없습니다."));
	        }
	        return ResponseEntity.ok(Map.of("deleted", 1));
	    }
	

	    /** 내가 작성한 리뷰 벌크 삭제 */
	    @DeleteMapping("/reviews/bulk")
	    @ResponseBody
	    public ResponseEntity<?> deleteMyReviewsBulk(@RequestBody IdsPayload payload, HttpSession session) {
	        if (!memberService.loginCheck(session)) {
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
	                    .body(Map.of("error", "로그인이 필요합니다."));
	        }
	        if (payload == null || payload.ids == null || payload.ids.isEmpty()) {
	            return ResponseEntity.badRequest().body(Map.of("error", "삭제할 ID가 없습니다."));
	        }
	        t_member me = (t_member) session.getAttribute("member");
	        String mbId = me.getMb_id();

	        int deleted = sidebarmapper.deleteReviews(mbId, payload.ids);
	        return ResponseEntity.ok(Map.of("deleted", deleted));
	    }


}
