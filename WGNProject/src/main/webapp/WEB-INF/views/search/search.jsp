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
	
		<div class="profile-tabs">
			  <!-- 게시글 탭 (기본 선택된 탭) -->
			  <a href="#" class="tab active" id="tab-posts">
			    	<span>게시글</span>
			  </a>
		
			  <!-- 지도 탭 -->
			  <a href="#" class="tab" id="tab-map">
			    	<span>지도</span>
			  </a>
			
			  <!-- 찜한 가게 탭 (새로 추가됨) -->
			  <a href="#" class="tab" id="tab-favorites">
			    	<span>사용자</span>
			  </a>
		</div>
	
			<!-- 검색 결과 그리드 -->
			<div class="container-fluid result-grid px-0">
				<div class="row g-1">
					<div class="col-4">
						<img src="https://via.placeholder.com/200">
					</div>
					<div class="col-4">
						<img src="https://via.placeholder.com/200">
					</div>
					<div class="col-4">
						<img src="https://via.placeholder.com/200">
					</div>
					<div class="col-4">
						<img src="https://via.placeholder.com/200">
					</div>
				</div>
			</div>
			<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
		</div>
	</div>
	
</body>
</html>