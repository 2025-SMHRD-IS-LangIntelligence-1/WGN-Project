<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1">
<title>Insert title here</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/search.css?v=2" />
</head>
<body>
	<div class="mobile-container">
		<%@ include file="/WEB-INF/views/common/topBar.jsp"%>
		<div class="content">

			<!-- 검색 입력 -->

			<form action="${pageContext.request.contextPath}" id="search-form" method="get">
			    <div class="search-box">
			        <input name="query" type="text" class="form-control" placeholder="검색어 입력">
			        <input type="submit" value="검색" class="search-btn">
			    </div>
			</form>
			
			<div class="search-tabs">

				<!-- 음식점 탭 (기본 선택된 탭) -->
				<a href="#" class="tab active" id="tab-res"> <i
					class="bi bi-search"></i> <span>음식점</span>
				</a>

				<!-- 게시글 탭 -->
				<a href="#" class="tab" id="tab-feed">
				<i class="bi bi-grid-3x3-gap"></i> <span>피드</span>
				</a>

				<!-- 사용자 탭 (새로 추가됨) -->
				<a href="#" class="tab" id="tab-member"> <i class="bi bi-person"></i>
					<span>사용자</span>
				</a>
			</div>
			
			<!------- 음식점res 탭 : 리스트 형식 + 가로 정렬 + 세로 중앙 정렬 ----------->
				
			<div id="res-section" class="res-section-box">
				
			</div>
			
			<!-- button class="bookmark-btn">
		      <i class="bi bi-pin-fill"></i>
		    </button>

			<!----------------------- 게시글 feed 탭 ------------------------------>
			<div id="feed-section" style="display: none;">
			
			</div>
			
			<!----------------------- 사용자 member 탭 ------------------------------>
			<div id="member-section" style="display: none;">
				
				<div class="member-header"></div>
				<!--<form>
					<button class="my-follow-btn">팔로우</button>
				</form> -->
			</div>

			<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
		</div>
	</div>
	<script type="text/javascript">
		const contextPath = "${pageContext.request.contextPath}";
	</script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/search.js"></script>
	
</body>
</html>