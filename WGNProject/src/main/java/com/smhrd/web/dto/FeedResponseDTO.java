package com.smhrd.web.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FeedResponseDTO {
	
    private List<FeedPreviewDTO> feeds;
    private List<String> followingMemList;
    private List<Integer> likedFeedList;

}
