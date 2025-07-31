package com.smhrd.web.service;

import com.smhrd.web.dto.ProfileDTO;

public interface ProfileService {

	ProfileDTO showMyPage(String mb_id);

	ProfileDTO showOtherMemPage(String mb_id);
	
}
