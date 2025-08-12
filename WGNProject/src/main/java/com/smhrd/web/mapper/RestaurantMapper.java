package com.smhrd.web.mapper;

import java.time.LocalDateTime;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectProvider;
import org.apache.ibatis.annotations.Update;

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

	@Select("""
		    SELECT res_idx FROM t_restaurant 
			WHERE last_update >= #{time}
			UNION
			SELECT res_idx FROM (
			    SELECT res_idx FROM t_restaurant
			    WHERE (nk_positive_wc IS NULL OR nk_positive_wc = '' 
			       OR nk_negative_wc IS NULL OR nk_negative_wc = '' 
			       OR wgn_positive_wc IS NULL OR wgn_positive_wc = '' 
			       OR wgn_negative_wc IS NULL OR wgn_negative_wc = '')
			    LIMIT 30
			) AS limited_missing_wc
			""")
		List<Integer> findRecentlyUpdatedOrMissingWC(LocalDateTime time);

	@Update("""
			update t_restaurant
			set wgn_ratings = #{ratings},
				nk_positive_wc = #{wc1},
			    nk_negative_wc = #{wc2},
			    wgn_positive_wc = #{wc3},
			    wgn_negative_wc = #{wc4}
			where res_idx = #{res_idx}
			""")
	void updateWcAndRatings(int res_idx, String wc1, String wc2, String wc3, String wc4, float ratings);
	
}
