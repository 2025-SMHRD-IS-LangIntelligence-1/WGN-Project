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
	href="${pageContext.request.contextPath}/resources/css/addFeed.css" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<body>

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
						<label for="file-upload" class=" upload-box"> <i
							class="bi bi-camera"></i> <span>사진/영상</span>
						</label>
						<!-- 숨겨진 파일 업로드 -->
						<input type="file" name="files" id="file-upload"
							class="file-upload" accept="image/*" hidden multiple>
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
					<!-- 별점 등록창 -->
					<div id="ratingForm">
						<input type="radio" id="star5" name="rating" value="5" /><label
							for="star5" title="5 stars">★</label> <input type="radio"
							id="star4" name="rating" value="4" /><label for="star4"
							title="4 stars">★</label> <input type="radio" id="star3"
							name="rating" value="3" /><label for="star3" title="3 stars">★</label>
						<input type="radio" id="star2" name="rating" value="2" /><label
							for="star2" title="2 stars">★</label> <input type="radio"
							id="star1" name="rating" value="1" /><label for="star1"
							title="1 star">★</label>
					</div>
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