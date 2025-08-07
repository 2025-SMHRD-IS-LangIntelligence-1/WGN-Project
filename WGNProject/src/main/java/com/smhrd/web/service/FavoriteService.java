package com.smhrd.web.service;

import java.util.List;

import com.smhrd.web.entity.t_favorite;
import com.smhrd.web.entity.t_review;

public interface FavoriteService {
	
	void insertFavorite(t_favorite favorite);

	List<t_favorite> getmyFavorite(String mb_id);

	boolean checkFavoriteExists(String mb_id, int res_idx);



}

