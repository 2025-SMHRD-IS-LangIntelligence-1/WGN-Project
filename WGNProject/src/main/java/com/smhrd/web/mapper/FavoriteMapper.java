package com.smhrd.web.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.smhrd.web.entity.t_favorite;

@Mapper
public interface FavoriteMapper {

	@Insert("INSERT INTO t_favorite (mb_id, res_idx, fav_rating)"
			+ "values (#{mb_id}, #{res_idx}, #{fav_rating})")
	void insertFavorite(t_favorite favorite);


	@Select("Select * from t_favorite where mb_id=#{mb_id}")
	List<t_favorite> selectFavorite(String mb_id);

	@Select(" SELECT COUNT(*) FROM t_favorite "
			+ "WHERE mb_id = #{mb_id} AND res_idx = #{res_idx}")
	int existsByMbIdAndResIdx(String mb_id, int res_idx);


}
