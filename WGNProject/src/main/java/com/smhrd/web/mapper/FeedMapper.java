package com.smhrd.web.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.smhrd.web.entity.t_feed;

@Mapper
public interface FeedMapper {

	@Select("select * from t_feed where mb_id=#{mb_id}")
	public ArrayList<t_feed> selectFeedByMemId(String mb_id);
	
	@Select("select * from t_feed where feed_idx=#{feed_idx}")
	public ArrayList<t_feed> selectFeedByFeedIdx(int feed_idx);

	public void saveFeed(t_feed feed);

	public void saveFeedImg(@Param("feed_idx") int feed_idx, @Param("imgUrls") List<String> imgUrls);
	
	@Select("select feed_img_url from t_feed_img where feed_idx=#{feed_idx} order by feed_img_idx asc")
	public ArrayList<String> selectFeedImgByFeedIdx(int feed_idx);
}
