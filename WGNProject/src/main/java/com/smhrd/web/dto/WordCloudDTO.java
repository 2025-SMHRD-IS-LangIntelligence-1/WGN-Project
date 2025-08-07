package com.smhrd.web.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class WordCloudDTO {

	// Base64로 인코딩된 이미지 4개 담을 수 있는 DTO
	
	private String NkPositiveWC;
	private String NkNegativeWC;
	private String WgnPositiveWC;
	private String WgnNegativeWC;
		
}
