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
import com.smhrd.web.dto.FeedPreviewDTO;
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

	@Insert("insert into t_feed_like values (null, #{feed_idx}, #{mb_id}, now())")
	public void addFeedLike(int feed_idx, String mb_id);
	
	@Delete("delete from t_feed_like where mb_id=#{mb_id} and feed_idx=#{feed_idx}")
	public void deleteFeedLike(int feed_idx, String mb_id);
	
	@Select("SELECT feed_likes FROM t_feed WHERE feed_idx = #{feed_idx}")
	public int countFeedLike(int feed_idx);

	public List<CandidateFeedDTO> getCandidateFeed(String mb_id);

	public List<FeedForSearchDTO> getFeedForSearch(String mb_id);

	public FeedPreviewDTO getFeedsByFeedIdx(int feed_idx);

	@Select("""
			    (SELECT feed_idx FROM t_feed ORDER BY created_at DESC LIMIT 8)
			    UNION
			    (SELECT feed_idx FROM t_feed ORDER BY feed_likes DESC LIMIT 6)
			    UNION
			    (SELECT feed_idx FROM t_feed ORDER BY RAND() LIMIT 6)
			    LIMIT 20
			""")
	List<Integer> getMixedFeeds();

	@Select("select feed_idx from t_feed_like where mb_id=#{mbId}")
	public List<Integer> getLikedFeedIdx(String mbId);

	@Update("UPDATE t_feed SET feed_likes = feed_likes + 1 WHERE feed_idx = #{feed_idx}")
	void incrementFeedLikes(@Param("feed_idx") int feed_idx);

	@Update("UPDATE t_feed SET feed_likes = feed_likes - 1 WHERE feed_idx = #{feed_idx} AND feed_likes > 0")
	void decrementFeedLikes(@Param("feed_idx") int feed_idx);

	@Select("select feed_idx from t_feed_like where mb_id=#{mb_id}")
	public List<Integer> getAllLikedFeed(String mb_id);

	public void updateFeedMeta(Long feedIdx, String content, Integer ratings);

	public List<String> selectImageUrlsByFeedId(Long feedIdx);

	public void deleteImagesByFeedId(Long feedIdx);

	public void deleteImagesByUrls(Long feedIdx, List<String> deleteUrls);

	public void insertFeedImage(Long feedIdx, String url);


}
