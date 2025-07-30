package com.smhrd.web.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.smhrd.web.entity.t_feed;
import com.smhrd.web.service.FeedService;

@RequestMapping("feed")
@Controller
public class FeedController {
	
	@Autowired
	FeedService feedService;
	
	@GetMapping("/feedList")
	public String showFeed(Model model) {
		ArrayList<t_feed> feeds = feedService.showFeed();
		model.addAttribute("feeds", feeds);
		return "feedList";
	}
	
	@GetMapping("/addFeed")
	public String goAddFeed() {
		return "addFeed";
	}
	
}
