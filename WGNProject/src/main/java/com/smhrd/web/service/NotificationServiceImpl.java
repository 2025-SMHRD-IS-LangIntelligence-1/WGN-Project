package com.smhrd.web.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.web.entity.t_notification;
import com.smhrd.web.mapper.NotificationMapper;

@Service
public class NotificationServiceImpl implements NotificationService{

	@Autowired
	NotificationMapper notificationMapper;
	
	@Override
	public void makeFollowNoti(String sender, String receiver) {
		
		t_notification noti = new t_notification();
		noti.setSender_id(sender);
		noti.setReceiver_id(receiver);
		noti.setType("follow");
		noti.setTarget_id(null);
		noti.setContent(null);
		
		notificationMapper.insertNotification(noti);
	}
	
	@Override
	public void makeLikeNoti(String sender, String receiver, int feed_idx) {
		
		t_notification noti = new t_notification();
		noti.setSender_id(sender);
		noti.setReceiver_id(receiver);
		noti.setType("like");
		noti.setTarget_id(feed_idx);
		noti.setContent(null);
		
		notificationMapper.insertNotification(noti);
	}
	
	@Override
	public void makeCommentNoti(String sender, String receiver, int feed_idx, String comment) {
		
		t_notification noti = new t_notification();
		noti.setSender_id(sender);
		noti.setReceiver_id(receiver);
		noti.setType("comment");
		noti.setTarget_id(feed_idx);
		noti.setContent(comment);
		
		notificationMapper.insertNotification(noti);
	}
	
	@Override
	public List<t_notification> showRecentNoti(String receiver) {
		
		List<t_notification> notiList = notificationMapper.getNotificationsByReceiver(receiver);
		
		return notiList;
	}

	
}
