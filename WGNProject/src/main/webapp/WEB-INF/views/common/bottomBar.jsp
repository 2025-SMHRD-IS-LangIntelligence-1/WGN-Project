<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>bottomBar</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bottomBar.css" />

</head>
<body>
	<nav class="bottomBar">
		<a href="${pageContext.request.contextPath}/">home</a>
		<a href="${pageContext.request.contextPath}/myPage/회원아이디">myPage</a>
		<!-- 세션에 기록된 로그인 데이터에서 회원아이디 기록해야 함 -->
		<a href="${pageContext.request.contextPath}/feed/addFeed">addFeed</a>
		<a href="${pageContext.request.contextPath}/search">search</a>
	</nav>
	
</body>
</html>