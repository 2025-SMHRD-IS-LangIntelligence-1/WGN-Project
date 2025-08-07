<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1">
<title>Home</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/home.css" />

<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>

<body>
	<%@ include file="/WEB-INF/views/common/topBar.jsp"%>

	<div class="mobile-container">

		<div class="content">
			<!-- 광고 -->
			<div class="ad-banner">광주맛집</div>
			
			<div class="feed" id="feed-list">
				<!-- JavaScript로 동적으로 채워짐 -->
			</div>
		</div>
		
		<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
	</div>

	<!-- Bootstrap JS (Carousel 동작 필수) -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/home.js"></script>
</body>

</html>