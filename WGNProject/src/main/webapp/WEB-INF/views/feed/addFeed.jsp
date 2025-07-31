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
		<div class="header">
			<img
				src="https://upload.wikimedia.org/wikipedia/commons/9/95/Instagram_logo_2022.svg"
				class="logo"> <i class="bi bi-send"></i>
		</div>

		<div class="add-box">
			<input type="file" class="form-control mb-2">
			<textarea class="form-control" rows="3" placeholder="설명 작성"></textarea>
			<button class="btn btn-primary mt-2">게시</button>
		</div>

		<div class="navbar-bottom">
			<a href="home.html"><i class="bi bi-house-door"></i></a> <a
				href="search.html"><i class="bi bi-search"></i></a> <a
				href="postAdd.html"><i class="bi bi-plus-square"></i></a> <a
				href="notifications.html"><i class="bi bi-heart"></i></a> <a
				href="myPage.html"><i class="bi bi-person-circle"></i></a>
		</div>
		<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
	</div>
</body>
</html>