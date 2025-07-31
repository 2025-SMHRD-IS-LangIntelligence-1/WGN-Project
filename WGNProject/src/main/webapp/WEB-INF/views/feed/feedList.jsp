<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>feedList</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/feedList.css" />
</head>

<body>
	<div class="mobile-container">
		<%@ include file="/WEB-INF/views/common/topBar.jsp"%>
		<div class="content">
			<c:forEach var="feed" items="${feeds}">
				<div class="feed">
					<p>${feed.title}
					<p>${feed.content}</p>
				</div>
			</c:forEach>
		</div>
		<%@ include file="/WEB-INF/views/common/bottomBar.jsp" %>
	</div>
</body>
</html>