<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addFeed</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/feed.css" />
</head>
<body>
		<%@ include file="/WEB-INF/views/common/topBar.jsp"%>
		<div class="content">
			<div class="add-box">
				<!-- 음식점을 지도로 받아와야 함 -->
				<!-- 파일 첨부 최대 10개까지 할 수 있게 -->
				<!-- 텍스트 입력할 수 있는 란 -->
				<input type="file" class="form-control mb-2"><br>
				<textarea class="form-control" rows="3" placeholder="설명 작성"></textarea>
				<button class="btn btn-primary mt-2">게시</button>				
			</div>
		</div>
		<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
</body>
</html>