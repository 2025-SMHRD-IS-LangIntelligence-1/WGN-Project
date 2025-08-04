package com.smhrd.web.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.smhrd.web.dto.FeedWithImgDTO;
import com.smhrd.web.entity.t_comment;
import com.smhrd.web.entity.t_feed;

@Mapper
public interface FeedMapper {

	public ArrayList<FeedWithImgDTO> selectFeedByMemId(String mb_id);

	public void saveFeed(t_feed feed);

	public void saveFeedImg(@Param("feed_idx") int feed_idx, @Param("imgUrls") List<String> imgUrls);
	
	@Select("select feed_img_url from t_feed_img where feed_idx=#{feed_idx} order by feed_img_idx asc")
	public ArrayList<String> selectFeedImgByFeedIdx(int feed_idx);
	
	FeedWithImgDTO selectFeedByIdx(int feed_idx);

	@Insert("insert into t_comment values(null, #{feed_idx}, #{mb_id}, #{mb_nick}, #{cmt_content}, now())")
	public void saveComment(t_comment cmt);

	@Select("select * from t_comment where feed_idx=#{feed_idx} order by created_at desc")
	public ArrayList<t_comment> getCmtByfeedIdx(int feedIdx);

	@Delete("delete from t_feed where feed_idx = #{feed_idx}")
	public void deleteFeed(int feed_idx);
	
}
