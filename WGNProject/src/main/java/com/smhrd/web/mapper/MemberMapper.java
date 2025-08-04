package com.smhrd.web.mapper;

import org.apache.ibatis.annotations.Delete;
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

	@Insert("insert into t_member(mb_id, mb_pw, mb_name, mb_nick, mb_img)"
			+ "values(#{mb_id}, #{mb_pw}, #{mb_name}, #{mb_nick}, 'https://res.cloudinary.com/duyrajdqg/image/upload/v1754316075/profile-default_qa5qxt.png')")
	void join(t_member mem);
	
	@Select("select count(*) from t_follow where following_id=#{following_id}")
	// mem을 팔로워하는 모든 사람을 id를 활용해서 구하는 메서드
	int countFollowers(String mb_id);

	@Select("select count(*) from t_follow where follower_id=#{follower_id}")
	// mem이 팔로잉하고 있는 모든 사람을 id를 활용해서 구하는 메서드
	int countFollowings(String mb_id);

	@Select("select count(*) from t_feed where mb_id=#{mb_id}")
	// mem이 가지고 있는 모든 피드를 id를 활용해서 구하는 메서드
	int countFeed(String mb_id);

	@Insert("insert into t_follow values(null, #{follower_id}, #{following_id}, now())")
	void followMem(String follower_id, String following_id);

	@Delete("delete from t_follow where follower_id = #{follower_id} and following_id = #{following_id}")
	void unfollowMem(String follower_id, String following_id);

	@Select("select COUNT(*) from t_follow where follower_id = #{mbId} and following_id = #{feedOwnerId}")
	int isFollowing(String mbId, String feedOwnerId);

}
