package com.smhrd.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.smhrd.web.service.NotificationService;

@RequestMapping("/notification")
@Controller
public class NotificationController {

	@Autowired
	NotificationService notificationService;
	
	@PostMapping("/read")
	@ResponseBody
	public void markAsRead(@RequestParam("noti_id") int notiId) {
		
		System.out.println("markAsRead 함수 실행");
	    notificationService.markAsRead(notiId);
	}
}
