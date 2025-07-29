package com.smhrd.web.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.smhrd.web.entity.Member;

@Mapper
public interface MemberMapper {

	@Select("select * from Member where member_id=#{member_id}")
	Member findById(String member_id);
	
	@Insert("insert into Member values"
			+ "(#{member_id}, #{nickname}, #{password}, #{name}, #{ssn})")
	void join(Member mem);
}
