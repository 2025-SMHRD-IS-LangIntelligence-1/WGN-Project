<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1">
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
			<form action="${pageContext.request.contextPath}" id="search-form"
				method="get">
				<div class="search-box">
					<input name="query" type="text" class="form-control"
						placeholder="검색어 입력"> <input type="submit" value="검색"
						class="search-btn">
				</div>
			</form>
			<!-- // 룰렛!!! -->
			<div id="pre-search" class="presearch">
				<h5 class="presearch-title">
					뭐 먹을지 고민이라면? <span class="emoji">🎰</span>
				</h5>

				<div class="slot-card">
					<div class="reel-window">
						<ul id="reelList"></ul>
					</div>
				</div>

				<button id="spinBtn" type="button" class="spin-btn btn btn-warning">
					<i class="bi bi-lightning-charge"></i> 레버 당기기
				</button>

				<div id="pickedMenu" class="picked-hint">
					<i class="bi bi-compass"></i> <span>슬롯 결과가 검색창에 자동 입력돼요.</span>
				</div>
			</div>


			<div class="search-tabs" style="display: none;">
				<a href="#" class="tab active" id="tab-res"><i
					class="bi bi-shop"></i> <span>음식점</span></a> <a href="#" class="tab"
					id="tab-feed"><i class="bi bi-grid-3x3-gap"></i> <span>피드</span></a>
				<a href="#" class="tab" id="tab-member"><i class="bi bi-person"></i>
					<span>사용자</span></a>
			</div>

			<!-- 섹션들 -->
			<div id="res-section" class="res-section-box" style="display: none;"></div>
			<div id="feed-section" style="display: none;"></div>
			<div id="member-section" style="display: none;"></div>

			<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
		</div>
	</div>
	<script type="text/javascript">
		const contextPath = "${pageContext.request.contextPath}";
	</script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/search.js"></script>

</body>
</html>