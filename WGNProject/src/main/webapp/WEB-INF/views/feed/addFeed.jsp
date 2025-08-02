<!-- <%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> -->
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>addFeed</title>
    <link rel="stylesheet"
   	href="${pageContext.request.contextPath}/resources/css/common.css" />
	<link rel="stylesheet"
   	href="${pageContext.request.contextPath}/resources/css/feed.css" />
   	<!-- <link rel="stylesheet" href="../CSS/addFeed.css"> -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<body>
    
    <!-- 
    <div class="top-bar">
        <i class="icon">▦</i>
        <div class="logo">WGN</div>
    </div>
    -->

    <%@ include file="/WEB-INF/views/common/topBar.jsp"%>
    <div class="mobile-container">
        <div class="content">
        	<form action="${pageContext.request.contextPath}/feed/upload" method="post" enctype="multipart/form-data">
	            <div class="add-box">
	                <div class="add-box-header">
	                    <button class="close-btn">✕</button>
	                    <button class="submit-btn">게시하기</button>
	                </div>
	                <br>
	                <div class="upload-wrapper">
	                    <!-- 업로드 버튼 -->
	                    <label for="file-upload" class="upload-box">
	                        <img src="camera-icon.png" alt=■>
	                        <span>사진/영상</span>
	                    </label>
	                    <!-- 숨겨진 파일 업로드 -->
	                    <input type="file" name="file" id="file-upload" class="file-upload" accept="image/*, video/*" hidden>
	                </div>
	                <br>
	                <!-- 검색창 -->
	                <textarea name="feed_content" class="desc-text" rows="3" placeholder="설명 작성"></textarea>
	                <br>
	            </div>
	
	            <div>
	                <!-- 회색 선 -->
	                <div class="section_divider"></div>
	                <!-- 검색창 -->
	                <input type="text" class="search_input" placeholder="음식점을 입력하세요">
	
	                <div class="search-res">
	                     <!-- 음식 썸네일 -->
	                    <img src="sample_food.jpg" alt="음식 이미지" class="res_thumbnail">
	                    <!-- 텍스트 정보 -->
	                    <div class="res_info">
	                        <h3 class="res_name">해물짬뽕 전문점</h3>
	                        <p class="res_addr">광주광역시 북구 탄탕로 141번길 7 행복건물 1층</p>
	                        <!-- 평점 영역 -->
	                        <div class="rating_info">
	                            <img src="coin-icon.png" alt="별" class="ratings_icon">
	                            <span class="ratings_text">4.8</span>
	                        <!-- 스프링쿨 WGNProject / com.smhrd.web.entity / res이랑 review-->
	                        </div>
	                    </div>
	                </div>
	            </div>
            </form>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/bottomBar.jsp"%> 
</body>

</html>