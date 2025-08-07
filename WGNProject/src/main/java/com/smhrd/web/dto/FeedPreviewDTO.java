package com.smhrd.web.dto;

import java.sql.Timestamp;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FeedPreviewDTO {

	private int feed_idx;
    private String mb_id;
    private int res_idx;
    private String feed_content;
    private int feed_likes;
    private Timestamp created_at;
    private String mb_nick;
    private String res_name;
    private String res_category;
    private int comment_count;
    private String mb_img;
    private List<String> imageUrls;

}
