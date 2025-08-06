package com.smhrd.web.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.smhrd.web.dto.LogDTO;

@Mapper
public interface LogMapper {

	List<LogDTO> getMemberLog(String mb_id);
	
}
