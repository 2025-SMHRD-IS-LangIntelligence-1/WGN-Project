package com.smhrd.web.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RestaurantDTO {

    private int res_idx;
    private String res_name;
    private String res_addr;
    private String res_thumbnail; // 이미지 썸네일 경로
    private Double res_avg_rating; // 평균 평점

}