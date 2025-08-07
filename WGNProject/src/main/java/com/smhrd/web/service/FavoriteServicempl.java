package com.smhrd.web.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.web.entity.t_favorite;
import com.smhrd.web.mapper.FavoriteMapper;

@Service
public class FavoriteServicempl implements FavoriteService{
	
	@Autowired
	private FavoriteMapper favoritemapper;

	@Override
	public void insertFavorite(t_favorite favorite) {
		
		favoritemapper.insertFavorite(favorite);
	}
	
	@Override
	public List<t_favorite> getmyFavorite(String mb_id){
		List<t_favorite> myfavorite = favoritemapper.selectFavorite(mb_id);
		
	    return myfavorite;
	}
	
	// 등록 음식점 중복 체크
	@Override
	public boolean checkFavoriteExists(String mb_id, int res_idx) {
		
		int count = favoritemapper.existsByMbIdAndResIdx(mb_id, res_idx);
		
		boolean exists = count > 0;
		return exists;
	}
	
	
}
