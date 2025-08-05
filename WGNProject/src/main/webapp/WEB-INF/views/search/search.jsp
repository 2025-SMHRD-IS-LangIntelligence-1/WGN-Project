<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1">
<title>Insert title here</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/search.css?v=2" />
</head>
<body>
	<div class="mobile-container">
		<%@ include file="/WEB-INF/views/common/topBar.jsp"%>
		<div class="content">

			<!-- 검색 입력 -->
			<div class="search-box">
				<input type="text" class="form-control" placeholder="검색어 입력">
			</div>

			<div class="search-tabs">
				<!-- 음식점 탭 (기본 선택된 탭) -->
				<a href="#" class="tab active" id="tab-res"> <i
					class="bi bi-search"></i> <span>음식점</span>
				</a>

				<!-- 게시글 탭 -->
				<a href="#" class="tab" id="tab-feed">
				<i class="bi bi-grid-3x3-gap"></i> <span>피드</span>
				</a>

				<!-- 사용자 탭 (새로 추가됨) -->
				<a href="#" class="tab" id="tab-member"> <i class="bi bi-person"></i>
					<span>사용자</span>
				</a>
			</div>

			<!------- 음식점res 탭 : 리스트 형식 + 가로 정렬 + 세로 중앙 정렬 ----------->
			<div id="res-section" class="res-section-box">

				<div class="list-group-item d-flex align-items-center res-card">
					<img src="https://via.placeholder.com/300x200" alt="음식 이미지"
						class="res_thumbnail">

					<!-- 텍스트 정보 영역 (가게명, 주소, 평점) -->
					<div class="res-info">
						<h5 class="res_name">해물짬뽕 전문점</h5>
						<p class="res_addr">광주광역시 북구</p>
						<div class="rating_info">
							<span class="ratings_text">4.8</span>
						</div>
					</div>
					<!-- 📌 찜 버튼 (오른쪽 끝) -->
					<button class="bookmark-btn">
						<i class="bi bi-pin-fill"></i>
					</button>
				</div>
			</div>

			<!----------------------- 게시글feed 탭 ------------------------------>
			<div id="feed-section" style="display: none;">
				<div class="feed">

					<!-- 게시물 1 -->
					<div class="feed-item">
						<div class="feed-header">
							<div class="feed-member">
								<img src="https://via.placeholder.com/40">
								<div class="feed-member-info">
									<b>OtherUsers</b> <span style="color: #888; font-size: 12px;">3분
										전</span>
								</div>
							</div>
							<button class="follow-btn">팔로우</button>
						</div>

						<!-- Carousel -->
						<a href="feed.html?feed_idx=1">
							<div id="carousel1" class="carousel slide" data-bs-touch="true"
								data-bs-interval="false">
								<div class="carousel-inner">
									<div class="carousel-item active">
										<img src="https://via.placeholder.com/400x300" alt="음식 사진 1">
									</div>
									<div class="carousel-item">
										<img src="https://via.placeholder.com/400x300" alt="음식 사진 2">
									</div>
								</div>
								<button class="carousel-control-prev" type="button"
									data-bs-target="#carousel1" data-bs-slide="prev">
									<span class="carousel-control-prev-icon"></span>
								</button>
								<button class="carousel-control-next" type="button"
									data-bs-target="#carousel1" data-bs-slide="next">
									<span class="carousel-control-next-icon"></span>
								</button>
							</div>
						</a>

						<div class="feed-actions">
							<i class="bi bi-heart"></i> <i class="bi bi-chat ms-3"></i> <span
								class="stats ms-2">4 좋아요 · 15 댓글</span>
						</div>

						<div class="location-card"
							onclick="window.location='restaurant.html'">
							<div class="location-info">
								<b>쿠로시로</b> <span>일식 · 면</span>
							</div>
							<i class="bi bi-chevron-right"></i>
						</div>

						<div class="feed-caption">
							<span class="caption-text"> 금보도 잘 안되는 도로 쪽에 새로 생긴 구로시로
								라멘집인데 완전 맛있네요 ㅋㅋㅋ 면도 쫄깃하고 시원한 국물이 일품! 분위기도 깔끔하고 다음에도 꼭 갈 생각입니다.
							</span> <span class="more-btn" onclick="toggleMore(this)">더보기</span>
						</div>
					</div>

				</div>
			</div>
			
			<!----------------------- 사용자 member 탭 ------------------------------>
			<div id="member-section" style="display: none;">
				<div class="member-header">
					
				</div>
			</div>

			<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
		</div>
	</div>
	<script type="text/javascript">
		const contextPath = "${pageContext.request.contextPath}";
	</script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/search.js"></script>

</body>
</html>