<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>addFeed</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/addFeed.css" />
</head>

<body>

	<%@ include file="/WEB-INF/views/common/topBar.jsp"%>

	<div class="mobile-container">
		<div class="content">
			<form action="<c:url value='/feed/upload'/>" method="post"
				enctype="multipart/form-data">

				<div class="add-box">
					<!-- 상단 닫기 및 제출 버튼 -->
					<div class="add-box-header">
						<button class="close-btn" type="button">✕</button>
						<button class="submit-btn" type="submit" disabled>게시하기</button>
					</div>

					<!-- 파일 업로드 영역 -->
					<div class="upload-wrapper">
						<!-- 업로드 버튼 영역 -->
						<div class="upload-box-container">
							<label for="file-upload" class="upload-box"> <i
								class="bi bi-camera"></i> <span>사진/영상</span>
							</label> <input type="file" name="files" id="file-upload"
								class="file-upload" accept="image/*" hidden multiple>
							<p class="upload-limit-text">최대 5장까지 업로드할 수 있습니다.</p>
						</div>

						<!-- 미리보기 썸네일은 옆에 유지 -->
						<div id="preview-container" class="preview-container"></div>
					</div>

					<!-- 에러 메시지 -->
					<span id="fileError" class="text-danger"
						style="display: none; font-size: 13px;">사진을 선택해주세요.</span>

					<!-- 피드 내용 입력 -->
					<textarea name="feed_content" id="feed_content" class="desc-text"
						rows="3" placeholder="내용을 작성해주세요"></textarea>
					<span id="contentError" class="text-danger"
						style="display: none; font-size: 13px;">내용을 입력해주세요.</span>
				</div>


				<!-- 클래스명 통일 -->

				<div class="rating-wrapper">
					<span class="rating-title">별점</span>
					<div class="star-input">
						<input type="radio" id="star5" name="ratings" value="5" /> <label
							for="star5" title="5 stars">★</label> <input type="radio"
							id="star4" name="ratings" value="4" /> <label for="star4"
							title="4 stars">★</label> <input type="radio" id="star3"
							name="ratings" value="3" /> <label for="star3" title="3 stars">★</label>

						<input type="radio" id="star2" name="ratings" value="2" /> <label
							for="star2" title="2 stars">★</label> <input type="radio"
							id="star1" name="ratings" value="1" />
						<!-- name 통일 -->
						<label for="star1" title="1 star">★</label>
					</div>
				</div>

				<span id="ratingError" class="text-danger"
					style="display: none; font-size: 13px;">별점을 선택해주세요.</span>

				<!-- 랭킹 등록 -->
				<div class="favorite-wrapper">
					<span class="favorite-title"> 내 랭킹 등록하기 </span>
					<div class="favorite-input">
						<div id="rankToggleWrapper">
							<label class="switch-toggle"> <input type="checkbox"
								id="rank_toggle" name="rank_toggle"> <span
								class="slider"> <span class="label-on">ON</span> <span
									class="label-off">OFF</span>
							</span>
							</label>
						</div>
						<span id="duplicateFavoriteMsg" class="text-danger"
							style="display: none; font-size: 13px; margin-left: 10px;">이미
							등록한 음식점입니다.</span>
					</div>
				</div>

				<!-- 음식점 검색 (반드시 form 안에 둠) -->
				<div class="search-input-wrap">
					<i class="bx bx-search"></i>
					<input type="text" class="search_input" placeholder="음식점을 입력하세요">
				</div>
				<input type="hidden" name="res_idx" id="selectedResIdx"> <span
					id="resError" class="text-danger"
					style="display: none; font-size: 13px;">음식점을 선택해주세요.</span>
				<div class="search-list"></div>

			</form>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>

	<!-- jQuery 및 JS 연결 -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		const contextPath = '${pageContext.request.contextPath}';
	</script>
	<script
		src="${pageContext.request.contextPath}/resources/js/addFeed.js"></script>

</body>
</html>
