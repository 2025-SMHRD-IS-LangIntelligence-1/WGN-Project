<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addFeed</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/feed.css" />
</head>
<body>
	<div class="mobile-container">

		<div class="add-box">
			<input type="file" class="form-control mb-2">
			<textarea class="form-control" rows="3" placeholder="설명 작성"></textarea>
			<button class="btn btn-primary mt-2">게시</button>
		</div>

		<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
	</div>
</body>
</html>