package com.smhrd.web.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;

import org.apache.ibatis.annotations.Select;



import com.smhrd.web.entity.t_going;

@Mapper
public interface GoingMapper {

    @Insert("INSERT INTO t_going (res_idx, mb_id) VALUES (#{res_idx}, #{mb_id})")
	int insertGoing(int res_idx, String mb_id);
    
	@Delete("DELETE FROM t_going WHERE res_idx = #{res_idx} AND mb_id = #{mb_id}")
	int deleteGoing(int res_idx, String mb_id);
	 
	@Select("SELECT COUNT(*) FROM t_going WHERE res_idx = #{res_idx} AND mb_id = #{mb_id}")
	int isGoing(int res_idx, String mb_id);
	
	@Select("Select * from t_going where mb_id=#{mb_id}")
	List<t_going> selectgoing(String mb_id);

	
	
	
}
