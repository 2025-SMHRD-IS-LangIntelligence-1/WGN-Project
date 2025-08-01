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
				<form action="${pageContext.request.contextPath}/feed/upload" method="post" enctype="multipart/form-data">
				
					<!-- 이미지 파일 첨부 최대 10개까지 할 수 있게 -->
					<!-- 이미지 외 다른 파일은 안되게 처리해야 함 -->
					<!-- 아직 이미지 하나밖에 첨부 못 함, 여러 이미지 첨부할 수 있게 처리하기 -->
					<input name="file" type="file" class="form-control mb-2"><br>
					
					<textarea name="feed_content" class="form-control" rows="3" placeholder="내용 작성"></textarea>
					
					<!-- 검색 기능을 통해 음식점 idx를 곧바로 input 할 수 있게 처리할 예정 -->
					
					<button class="btn btn-primary mt-2">게시</button>
				</form>				
			</div>
		</div>
		<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
</body>
</html>