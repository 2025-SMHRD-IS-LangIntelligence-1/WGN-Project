package com.smhrd.web.mapper;

import java.util.ArrayList;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.smhrd.web.entity.Feed;

@Mapper
public interface FeedMapper {

	@Select("select * from feed")
	public ArrayList<Feed> selectFeed();
	
}
