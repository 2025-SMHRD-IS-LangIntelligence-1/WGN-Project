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
	href="${pageContext.request.contextPath}/css/myPage.css" />
</head>
<body>
	<div class="mobile-container">
		<%@ include file="/WEB-INF/views/common/topBar.jsp"%>

		<div class="notice">
			<div class="notice-item">
				<b>user_02</b> 님이 좋아요를 눌렀습니다.
			</div>
			<div class="notice-item">
				<b>user_03</b> 님이 댓글을 남겼습니다.
			</div>
		</div>
		<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
	</div>
</body>
</html>