package com.smhrd.web.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectProvider;

import com.smhrd.web.dto.FavoriteresDTO;
import com.smhrd.web.dto.GoingresDTO;
import com.smhrd.web.dto.RestaurantDTO;
import com.smhrd.web.dto.ReviewDTO;
import com.smhrd.web.entity.t_convenience;
import com.smhrd.web.entity.t_menu;
import com.smhrd.web.entity.t_res_img;
import com.smhrd.web.entity.t_restaurant;
import com.smhrd.web.entity.t_running_time;
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
	
	@Select("Select * from t_convenience where res_idx = #{rex_idx}")
	List<t_convenience> res_convenience(int res_idx);
	
	@Select("Select * from t_running_time where res_idx = #{rex_idx}")
	List<t_running_time> res_running_time(int res_idx);
	
	@Select("Select * from t_menu where res_idx = #{rex_idx}")
	List<t_menu> res_menu(int res_idx);

	List<ReviewDTO> getresreview(int res_idx);

	List<FavoriteresDTO> myfavoriteres(List<Integer> residx, String mb_id);

	List<GoingresDTO> mygoingres(List<Integer> goingresidx, String mb_id);
	

}
