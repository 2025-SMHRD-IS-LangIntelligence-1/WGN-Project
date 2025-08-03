<!-- <%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> -->
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>addFeed</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/feed.css" />
<!-- <link rel="stylesheet" href="../CSS/addFeed.css"> -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<body>

	<!-- 
    <div class="top-bar">
        <i class="icon">▦</i>
        <div class="logo">WGN</div>
    </div>
    -->

	<%@ include file="/WEB-INF/views/common/topBar.jsp"%>
	<div class="mobile-container">
		<div class="content">
			<form action="${pageContext.request.contextPath}/feed/upload"
				method="post" enctype="multipart/form-data">
				<div class="add-box">
					<div class="add-box-header">
						<button class="close-btn">✕</button>
						<button class="submit-btn" disabled>게시하기</button>
					</div>
					<br>
					<div class="upload-wrapper">
						<!-- 업로드 버튼 -->
						<label for="file-upload" class="upload-box"> <img
							src="camera-icon.png" alt=■> <span>사진/영상</span>
						</label>
						<!-- 숨겨진 파일 업로드 -->
						<input type="file" name="files" id="file-upload"
							class="file-upload" accept="image/*, video/*" hidden multiple>
					</div>
					<br>
					<!-- 검색창 -->
					<textarea name="feed_content" id="feed_content" class="desc-text"
						rows="3" placeholder="내용을 작성해주세요"></textarea>
					<br>
				</div>

				<div>
					<!-- 회색 선 -->
					<div class="section_divider"></div>
					<!-- 검색창 -->
					<input type="text" class="search_input" placeholder="음식점을 입력하세요">
					<input type="hidden" name="res_idx" id="selectedResIdx">
					<!-- 검색 결과 리스트 -->
					<div class="search-list"></div>
				</div>
			</form>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		const contextPath = '${pageContext.request.contextPath}';
	</script>
	<script
		src="${pageContext.request.contextPath}/resources/js/addFeed.js"></script>

</body>

</html>