package com.smhrd.web.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.FeedService;
import com.smhrd.web.service.RecommendationService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/recommendation")
public class RecommandationController {

    @Autowired
    RecommendationService recommendationService;
    @Autowired
    FeedService feedService;

    @GetMapping("/feed")
    @ResponseBody
    public List<Integer> getRecommendedFeeds(HttpSession session) {
    	
    	System.out.println("getRecommendFeeds 메서드 실행");
    	
        t_member member = (t_member) session.getAttribute("member");
        String mb_id;
        
        if (member == null) {
            System.out.println("세션에 로그인 정보가 없습니다.");
            // 로그인 안 된 경우 빈 리스트 반환
            return feedService.getDefaultFeeds();
        } else {
            mb_id = member.getMb_id();
            List<Integer> FeedIdxList = recommendationService.sendLogsAndFeeds(mb_id);
            System.out.println("FeedIdxList : " + FeedIdxList);
            return FeedIdxList;
        }

    }
    
}
