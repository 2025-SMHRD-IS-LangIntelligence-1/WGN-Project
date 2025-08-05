package com.smhrd.web.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//메뉴 
@Data
@AllArgsConstructor
@NoArgsConstructor
public class t_menu {

 // 메뉴 식별자 
 private Integer menu_idx;

 // 음식점 식별자 
 private Integer res_idx;

 // 메뉴 명 
 private String menu_name;

 // 메뉴 가격 
 private String menu_price;

}