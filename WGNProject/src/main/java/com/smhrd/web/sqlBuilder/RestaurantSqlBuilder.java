package com.smhrd.web.sqlBuilder;

import java.util.Map;

// 사용자가 입력한 키워드를 바탕으로 SQL 검색 쿼리를 동적으로 생성
public class RestaurantSqlBuilder {

	public String buildSearchQuery(Map<String, Object> params) {

	    String[] keywords = (String[]) params.get("keywords");

	    StringBuilder sql = new StringBuilder("SELECT r.res_idx,"
	            + "r.res_name, "
	            + "r.res_addr, "
	            + "ri.res_img_url AS res_thumbnail, "
	            + "IFNULL(AVG(rv.ratings), 0) AS res_avg_rating "
	            + "FROM t_restaurant r "
	            + "LEFT JOIN t_res_img ri ON r.res_idx = ri.res_idx "
	            + "AND ri.res_img_idx = ("
	            + "SELECT MIN(res_img_idx) FROM t_res_img WHERE res_idx = r.res_idx"
	            + ") "
	            + "LEFT JOIN t_review rv ON rv.res_idx = r.res_idx ");

	    // 키워드가 하나라도 있으면 WHERE 절 시작
	    if (keywords != null && keywords.length > 0) {
	        sql.append("WHERE ");

	        for (int i = 0; i < keywords.length; i++) {
	            if (i > 0) sql.append(" AND ");
	            sql.append("(")
	               .append("r.res_name LIKE CONCAT('%', #{keywords[").append(i).append("]}, '%') ")
	               .append("OR r.res_addr LIKE CONCAT('%', #{keywords[").append(i).append("]}, '%') ")
	               .append(")");
	        }
	        sql.append("\r\n"); // WHERE 절 끝나고 줄바꿈
	    }

	    // 마지막 GROUP BY는 항상 붙임
	    sql.append("GROUP BY r.res_idx, r.res_name, r.res_addr, ri.res_img_url");

	    return sql.toString();
	}

}
