package com.smhrd.web.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MapAddedRestaurant {

	private String member_id;
	private int restaurant_id;
	
}
