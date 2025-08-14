package com.smhrd.web.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

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

	@Update("update t_member set mb_nick=#{nickname}, mb_img=#{url}, mb_intro=#{intro} where mb_id=#{mbId}")
	void updateWithImg(String mbId, String nickname, String intro, String url);
	
	@Update("update t_member set mb_nick=#{nickname}, mb_intro=#{intro} where mb_id=#{mbId}")
	void update(String mbId, String nickname, String intro);

	@Insert("insert into t_log values(null, #{mb_id}, #{res_idx}, #{action_type}, now())")
	void saveLog(String mb_id, Integer res_idx, String action_type);

	@Select("SELECT * FROM t_member WHERE mb_id LIKE CONCAT('%', #{keyword}, '%') OR mb_nick LIKE CONCAT('%', #{keyword}, '%')")
	List<t_member> searchByIdOrNick(@Param("keyword") String keyword);

	// mb_id가 팔로우하고 있는 모든 아이디를 구하는 메서드
	@Select("select following_id from t_follow where follower_id = #{mb_id}")
	List<String> getAllfollowMem(String mb_id);

	// mb_id를 팔로우 하고 있는 모든 아이디를 구하는 메서드
	@Select("select follower_id from t_follow where following_id = #{mb_id}")
	List<String> getAllfollowingMem(String mb_id);

}
