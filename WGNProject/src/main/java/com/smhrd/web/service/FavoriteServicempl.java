package com.smhrd.web.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.smhrd.web.dto.OrderPayloadDTO;
import com.smhrd.web.dto.OrderPayloadDTO.Item;
import com.smhrd.web.entity.t_favorite;
import com.smhrd.web.entity.t_member;
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
	
	// 랭킹 순서
    @Override
    @Transactional
    public void saveOrder(String mb_id, List<OrderPayloadDTO.Item> items) {
        if (items == null || items.isEmpty()) return;

        favoritemapper.updateFavoriteOrderCase(mb_id, items);
    }
	
    @Override
    @Transactional
    public void resetOrder(String mb_id) {
    	favoritemapper.resetFavoriteOrder(mb_id);
    }
    
    @Override
    public int deleteRanking(int resIdx, String mb_id) {
    	return favoritemapper.deleteRanking(resIdx, mb_id);
    }
    
}
