package com.smhrd.web.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectProvider;

import com.smhrd.web.dto.RestaurantDTO;
import com.smhrd.web.entity.t_res_img;
import com.smhrd.web.entity.t_restaurant;
import com.smhrd.web.entity.t_review;
import com.smhrd.web.sqlBuilder.RestaurantSqlBuilder;

@Mapper
public interface RestaurantMapper {

	@SelectProvider(type = RestaurantSqlBuilder.class, method = "buildSearchQuery")
	List<RestaurantDTO> searchByMultipleKeywords(@Param("keywords") String[] keywords);

	RestaurantDTO getByResIdx(int res_idx);
	
	@Select("Select * from t_restaurant where res_idx = #{res_idx}")
	t_restaurant resdetail(int res_idx);
	
	@Select("Select * from t_res_img where res_idx = #{rex_idx}")
	List<t_res_img> res_img(int res_idx);
	
	@Select("Select * from t_review where res_idx = #{rex_idx}")
	List<t_review> res_review(int res_idx);
	

}
