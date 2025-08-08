package com.smhrd.web.controller;


import com.smhrd.web.dto.OrderPayloadDTO;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.FavoriteService;
import com.smhrd.web.service.MemberService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/favorite")
public class FavoriteController {

    private final FavoriteService favoriteService;
    private final MemberService memberService;
    
    
    @PostMapping("/order")
    public ResponseEntity<?> saveOrder(@RequestBody OrderPayloadDTO payload,
                                       HttpSession session) {
    	
    	t_member mem = (t_member) session.getAttribute("member");
    	
    	String mb_id = mem.getMb_id();
		// 로그인이 되어 있지 않으면 로그인 페이지로
		if (mb_id == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body("로그인이 필요합니다.");
		}
		
        if (payload == null || payload.getList() == null || payload.getList().isEmpty()) {
            return ResponseEntity.badRequest().body("정렬 목록이 비었습니다.");
        }

        favoriteService.saveOrder(mb_id, payload.getList());
        
        return ResponseEntity.ok().build();
    }

    // 선택: 수동 정렬 초기화
    @PostMapping("/order/reset")
    public ResponseEntity<?> resetOrder(HttpSession session) {
    	
    	t_member mem = (t_member) session.getAttribute("member");
    	
    	String mb_id = mem.getMb_id();
		// 로그인이 되어 있지 않으면 로그인 페이지로
		if (mb_id == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body("로그인이 필요합니다.");
		}

		
        favoriteService.resetOrder(mb_id);
        
        return ResponseEntity.ok().build();
    }
    
    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> deleteRanking(@RequestParam("res_idx") int resIdx, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        t_member mem = (t_member) session.getAttribute("member");
    	
    	String mb_id = mem.getMb_id();
        
        try {
            int deletedCount = favoriteService.deleteRanking(resIdx, mb_id);

            result.put("success", deletedCount > 0);
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        return result;
    
    }
}