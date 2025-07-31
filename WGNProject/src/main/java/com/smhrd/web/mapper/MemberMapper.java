package com.smhrd.web.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.smhrd.web.entity.t_member;

@Mapper
public interface MemberMapper {

	@Select("select * from t_member where mb_id=#{mb_id}")
	t_member findById(String mb_id);

	@Select("select * from t_member where mb_nick=#{mb_nick}")
	t_member findByNick(String inputNick);

	@Insert("insert into t_member(mb_id, mb_pw, mb_name, mb_nick)"
			+ "values(#{mb_id}, #{mb_pw}, #{mb_name}, #{mb_nick})")
	void join(t_member mem);
	
	@Select("select count(*) from follow where following_id=#{following_id}")
	int countFollowers();
	

	// @Select()
	// int countFollowings();

}
