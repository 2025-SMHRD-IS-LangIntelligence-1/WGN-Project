<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

		<h2>내가 쓴 피드 목록</h2>

			<c:if test="${empty feeds}">
			    <p>작성한 피드가 없습니다.</p>
			</c:if>
			
			<c:forEach var="feed" items="${feeds}">
			    <div style="border:1px solid #ccc; padding:10px; margin-bottom:10px;">
			        <p><strong>내용:</strong> ${feed.feed_content}</p>
			        <p><small>작성일: ${feed.created_at}</small></p>
			    </div>
			</c:forEach>
		
</body>
</html>