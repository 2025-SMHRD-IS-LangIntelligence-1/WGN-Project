package com.smhrd.web.service;

import java.util.List;

import com.smhrd.web.entity.t_notification;

public interface NotificationService {

	void makeFollowNoti(String sender, String receiver);

	void makeLikeNoti(String sender, String receiver, int feed_idx);

	void makeCommentNoti(String sender, String receiver, int feed_idx, String comment);

	List<t_notification> showRecentNoti(String receiver);

}
