<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/search.css" />
</head>
<body>
	<div class="mobile-container">
		<%@ include file="/WEB-INF/views/common/topBar.jsp"%>
		<div class="content">
		
			<!-- 검색 입력 -->
			<div class="search-box">
				<input type="text" class="form-control" placeholder="검색어 입력">
			</div>
	
			<div class="search-tabs">
				<!-- 음식점 탭 (기본 선택된 탭) -->
				<a href="#" class="tab active" id="tab-res">
				  	<i class="bi bi-search"></i>
				    <span>음식점</span>
				</a>
			
				<!-- 게시글 탭 -->
				<a href="#" class="tab" id="tab-feed">
					<i class="bi bi-grid-3x3-gap"></i>
				    <span>피드</span>
				</a>
				
				<!-- 사용자 탭 (새로 추가됨) -->
				<a href="#" class="tab" id="tab-member">
					<i class="bi bi-person"></i>
				    <span>사용자</span>
				</a>
			</div>
			
			<!-- 음식점 탭 : 리스트 형식 + 가로 정렬 + 세로 중앙 정렬 -->
			<div id="res-section" class="res-section-box">
			<div class="list-group-item d-flex align-items-center">
			    <img src="https://via.placeholder.com/300x200" alt="음식 이미지" class="res_thumbnail">
			    <!-- 텍스트 정보 영역 (가게명, 주소, 평점) -->
			    <div class="res-info">
			    	<h5 class="res_name" >해물짬뽕 전문점</h5>
			    	<p class="res_addr" >광주광역시 북구</p>
			    </div>
			    <div class="rating_info">
			    	<span class="ratings_text">4.8</span>
			    </div>
			    <i class="bi bi-chevron-right text-muted arrow-icon"></i>
			</div>
			</div>
			
			<!-- 게시글 탭 -->
			<div id="feed-section" style="display: none;">피드 콘텐츠</div>
			
			<!-- 사용자 탭 -->
			<div id="member-section" style="display: none;">사용자 콘텐츠</div>
		
			
			<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
		</div>
	</div>
	
	<script>
	$(function() {
	  // 탭 클릭 이벤트
	  $('.search-tabs .tab').on('click', function(e) {
	    e.preventDefault(); // <a href="#"> 기본 동작 막기
	
	    // 1. 모든 탭의 'active' 클래스 제거 → 시각적 효과 초기화
	    $('.search-tabs .tab').removeClass('active');
	
	    // 2. 클릭한 탭(this)에만 'active' 클래스 추가
	    $(this).addClass('active');
	
	    // 3. 모든 콘텐츠 영역 숨기기
	    $('#res-section, #feed-section, #member-section').hide();
	
	    // 4. 클릭한 탭 ID에 따라 해당 콘텐츠 영역만 표시
	    if (this.id === 'tab-res') {
	      $('#res-section').show();        // 음식점 탭 클릭 시
	    } else if (this.id === 'tab-feed') {
	      $('#feed-section').show();       // 피드 탭 클릭 시
	    } else if (this.id === 'tab-member') {
	      $('#member-section').show();     // 사용자 탭 클릭 시
	    }
	  });
	});
	</script>
	
</body>
</html>