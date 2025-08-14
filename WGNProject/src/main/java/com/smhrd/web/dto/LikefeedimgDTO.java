package com.smhrd.web.dto;

import java.sql.Timestamp;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LikefeedimgDTO {
	
    private int feedIdx;
    private String thumbnail;
}
