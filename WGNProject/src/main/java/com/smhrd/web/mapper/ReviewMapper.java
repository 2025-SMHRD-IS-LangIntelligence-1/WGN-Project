package com.smhrd.web.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;

import com.smhrd.web.entity.t_review;

@Mapper
public interface ReviewMapper {
	
	@Insert("Insert into t_review(res_idx, mb_id, review_content, img_link, ratings, mb_nick, created_at)"
			+ "values(#{res_idx}, #{mb_id}, #{review_content}, #{img_link}, #{ratings}, #{mb_nick}, NOW() )")
	void insertReview(t_review review);

}
