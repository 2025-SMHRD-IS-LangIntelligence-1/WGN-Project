package com.smhrd.web.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.stereotype.Controller;

import com.smhrd.web.entity.t_member;
import com.smhrd.web.service.RecommendationService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/recommendation")
public class RecommandationController {

    @Autowired
    RecommendationService recommendationService;

    @ResponseBody
    @GetMapping("/feed")
    public List<Integer> getRecommendedFeeds(HttpSession session) {
    	
        t_member member = (t_member) session.getAttribute("member");
        String mb_id = member.getMb_id();
        
        if(mb_id == null) {
        	mb_id = "hyereams"; // 로그인 전 테스트용 아이디
        }
        
        return recommendationService.sendLogsAndFeeds(mb_id);
    }
}
