<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>bottomBar</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
</head>
	<div class="navbar-bottom">
	  <a href="${pageContext.request.contextPath}/"><i class="bi bi-house-door"></i></a>
	  <a href="${pageContext.request.contextPath}/search"><i class="bi bi-search"></i></a>
	  <a href="${pageContext.request.contextPath}/feed/addFeed"><i class="bi bi-plus-square"></i></a>
	  <a href="${pageContext.request.contextPath}/myPage/notifications"><i class="bi bi-heart"></i></a>
	  <a href="${pageContext.request.contextPath}/profile/myPage"><i class="bi bi-person-circle"></i></a>
	  <!-- 수정 필요 : myPage/사용자이름으로 마이페이지에 접근할 수 있게 하기 -->
	</div>
	
</body>
</html>