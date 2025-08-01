package com.smhrd.web.dto;

import java.util.List;

import com.smhrd.web.entity.t_feed;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FeedWithImgDTO {
	
	 private t_feed feed;
	 private List<String> imageUrls;

}
