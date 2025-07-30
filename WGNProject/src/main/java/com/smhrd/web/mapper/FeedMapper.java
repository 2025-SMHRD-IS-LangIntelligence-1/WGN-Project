package com.smhrd.web.mapper;

import java.util.ArrayList;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.smhrd.web.entity.t_feed;

@Mapper
public interface FeedMapper {

	@Select("select * from Feed")
	public ArrayList<t_feed> selectFeed();
	
}
