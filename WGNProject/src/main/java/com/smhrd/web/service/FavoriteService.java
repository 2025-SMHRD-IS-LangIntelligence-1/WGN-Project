package com.smhrd.web.service;

import java.util.List;

import com.smhrd.web.dto.OrderPayloadDTO;
import com.smhrd.web.dto.OrderPayloadDTO.Item;
import com.smhrd.web.entity.t_favorite;
import com.smhrd.web.entity.t_member;
import com.smhrd.web.entity.t_review;

public interface FavoriteService {
	
	void insertFavorite(t_favorite favorite);

	List<t_favorite> getmyFavorite(String mb_id);

	boolean checkFavoriteExists(String mb_id, int res_idx);

	void saveOrder(String mb_id, List<OrderPayloadDTO.Item> items);

	void resetOrder(String mb_id);

	int deleteRanking(int resIdx, String mb_id);





}

