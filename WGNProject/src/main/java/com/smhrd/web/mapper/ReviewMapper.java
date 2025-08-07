package com.smhrd.web.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.smhrd.web.dto.ReviewDTO;
import com.smhrd.web.entity.t_review;

@Mapper
public interface ReviewMapper {
	
	@Insert("Insert into t_review(res_idx, mb_id, review_content, img_link, ratings, mb_nick, created_at)"
			+ "values(#{res_idx}, #{mb_id}, #{review_content}, #{img_link}, #{ratings}, #{mb_nick}, NOW() )")
	void insertReview(t_review review);
	
	@Select("select r.*, m.mb_img "
			+ "from t_review r "
			+ "inner join t_member m on m.mb_id = r.mb_id "
			+ "where res_idx=#{res_idx}")
	List<ReviewDTO> getResReview(int res_idx);
}
