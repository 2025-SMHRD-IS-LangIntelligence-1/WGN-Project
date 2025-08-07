package com.smhrd.web.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.smhrd.web.dto.CandidateFeedDTO;
import com.smhrd.web.dto.CommentDTO;
import com.smhrd.web.dto.FeedForSearchDTO;
import com.smhrd.web.dto.FeedWithImgDTO;
import com.smhrd.web.entity.t_comment;
import com.smhrd.web.entity.t_feed;

@Mapper
public interface FeedMapper {

	public ArrayList<FeedWithImgDTO> selectFeedByMemId(String mb_id);

	public void saveFeed(t_feed feed);

	void saveFeedImg(@Param("feed_idx") int feed_idx, @Param("imgUrls") List<String> imgUrls);
	
	@Select("select feed_img_url from t_feed_img where feed_idx=#{feed_idx} order by feed_img_idx asc")
	public ArrayList<String> selectFeedImgByFeedIdx(int feed_idx);
	
	FeedWithImgDTO selectFeedByIdx(int feed_idx);

	@Insert("insert into t_comment values(null, #{feed_idx}, #{mb_id}, #{mb_nick}, #{cmt_content}, now())")
	public void saveComment(t_comment cmt);

	public ArrayList<CommentDTO> getCmtByfeedIdx(int feed_idx);

	@Delete("delete from t_feed where feed_idx = #{feed_idx}")
	public void deleteFeed(int feed_idx);

	@Update("update t_feed set feed_likes = feed_likes + 1 where feed_idx = #{feed_idx}")
	public void addFeedLike(int feed_idx);
	
	@Update("update t_feed set feed_likes = feed_likes - 1 where feed_idx = #{feed_idx}")
	public void deleteFeedLike(int feed_idx);

	@Select("select feed_likes from t_feed where feed_idx = #{feed_idx}")
	public int countFeedLike(int feed_idx);
	
	public List<CandidateFeedDTO> getCandidateFeed(String mb_id);
	
	public List<FeedForSearchDTO> getFeedForSearch(String mb_id);
}
