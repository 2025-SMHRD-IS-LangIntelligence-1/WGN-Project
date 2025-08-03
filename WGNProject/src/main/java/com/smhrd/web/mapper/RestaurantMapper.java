package com.smhrd.web.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.SelectProvider;

import com.smhrd.web.dto.RestaurantDTO;
import com.smhrd.web.sqlBuilder.RestaurantSqlBuilder;

@Mapper
public interface RestaurantMapper {

	@SelectProvider(type = RestaurantSqlBuilder.class, method = "buildSearchQuery")
	List<RestaurantDTO> searchByMultipleKeywords(@Param("keywords") String[] keywords);

}
