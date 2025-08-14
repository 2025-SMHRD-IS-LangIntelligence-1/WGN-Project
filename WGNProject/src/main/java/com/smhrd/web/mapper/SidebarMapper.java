package com.smhrd.web.mapper;


import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Result;

import com.smhrd.web.dto.LikefeedimgDTO;
import com.smhrd.web.dto.MycommentDTO;
import com.smhrd.web.dto.MyreviewDTO;
import com.smhrd.web.entity.t_feed_img;
import com.smhrd.web.entity.t_feed_like;

@Mapper
public interface SidebarMapper {
	
	  @Select("""
			    SELECT 
			      f.feed_idx                 AS feedIdx,
			      i.feed_img_url             AS thumbnail
			    FROM t_feed_like f
			    JOIN (
			      SELECT feed_idx, MIN(feed_img_idx) AS min_idx
			      FROM t_feed_img
			      GROUP BY feed_idx
			    ) m ON m.feed_idx = f.feed_idx
			    JOIN t_feed_img i
			      ON i.feed_idx = m.feed_idx
			     AND i.feed_img_idx = m.min_idx
			    WHERE f.mb_id = #{mb_id}

			    ORDER BY f.created_at DESC
			  """)
	List<LikefeedimgDTO> getLikedFeedThumbnails(String mb_id);

	List<MycommentDTO> getMyComments(String mb_id);

    @Delete("""
            DELETE FROM t_comment
            WHERE cmt_idx = #{id}
              AND mb_id = #{mbId}
        """)
	int deleteComment(String mbId, Long commentIdx);

    
	int deleteComments(String mbId, List<Long> ids);

	List<MyreviewDTO> getMyReviews(String mbId);

	int deleteReviews(String mbId, List<Long> ids);
	
	 // 단건 삭제
    @Delete("""
        DELETE FROM t_review
         WHERE review_idx = #{reviewIdx}
           AND mb_id = #{mbId}
    """)
	int deleteReview(String mbId, Long reviewIdx);




}
