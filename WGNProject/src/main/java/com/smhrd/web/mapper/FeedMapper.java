package com.smhrd.web.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.smhrd.web.entity.t_feed;

@Mapper
public interface FeedMapper {

	@Select("select * from t_feed where mb_id=#{mb_id}")
	public ArrayList<t_feed> selectFeedByMemId(String mb_id);

	@Insert("insert into t_feed values(null,#{mb_id},#{res_idx},#{feed_content},0,NOW())")
	public void saveFeed(t_feed feed);
	
}
