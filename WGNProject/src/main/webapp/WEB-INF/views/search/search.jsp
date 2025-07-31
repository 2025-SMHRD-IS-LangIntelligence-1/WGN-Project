<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/CSS/search.css" />
</head>
<body>
	<div class="mobile-container">

		<!-- 검색 입력 -->
		<div class="search-box">
			<input type="text" class="form-control" placeholder="검색어 입력">
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
</body>
</html>