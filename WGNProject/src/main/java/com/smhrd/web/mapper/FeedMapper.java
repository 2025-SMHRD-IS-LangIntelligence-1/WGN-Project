package com.smhrd.web.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.smhrd.web.entity.t_feed;
import com.smhrd.web.entity.t_feed_img;

@Mapper
public interface FeedMapper {

	@Select("select * from t_feed where mb_id=#{mb_id}")
	public ArrayList<t_feed> selectFeedByMemId(String mb_id);
	
	@Select("select * from t_feed where feed_idx=#{feed_idx}")
	public ArrayList<t_feed> selectFeedByFeedIdx(int feed_idx);

	public void saveFeed(t_feed feed);

	@Insert("insert into t_feed_img values(null,#{feed_idx},#{feed_img_url})")
	public void saveFeedImg(int feed_idx, String feed_img_url);
	
	@Select("select feed_img_url from t_feed_img where feed_idx=#{feed_idx} order by feed_img_idx asc")
	public ArrayList<String> selectFeedImgByFeedIdx(int feed_idx);
}
