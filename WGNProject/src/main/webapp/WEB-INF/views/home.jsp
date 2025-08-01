<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1">
<title>Home</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/home.css" />
</head>
<body>
		<%@ include file="/WEB-INF/views/common/topBar.jsp"%>
	<div class="mobile-container">
		<div class="content">
			<!-- 광고 -->
			<div class="ad-banner">광주맛집</div>

			<!-- 피드 -->
			<div class="feed">

				<!-- 게시물 1 -->
				<div class="post">
					<div class="post-header">
						<div class="post-user">
							<img src="https://search.pstatic.net/common/?autoRotate=true&type=w560_sharpen&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20250724_184%2F1753329591483vtYsm_JPEG%2F%25C1%25A6%25B8%25F1%25C0%25BB-%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4_-001.jpg">
							<div class="post-user-info">
								<b>OtherUsers</b> <span style="color: #888; font-size: 12px;">3분
									전</span>
							</div>
						</div>
						<button class="follow-btn">팔로우</button>
					</div>

					<!-- Carousel: 여러 장 (이미지 클릭 -> 상세페이지) -->
					<a href="post.html">
						<div id="carousel1" class="carousel slide" data-bs-touch="true"
							data-bs-interval="false">
							<div class="carousel-inner">
								<div class="carousel-item active">
									<img
										src="https://search.pstatic.net/common/?autoRotate=true&type=w560_sharpen&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20250724_184%2F1753329591483vtYsm_JPEG%2F%25C1%25A6%25B8%25F1%25C0%25BB-%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4_-001.jpg">
								</div>
								<div class="carousel-item">
									<img
										src="https://search.pstatic.net/common/?autoRotate=true&type=w560_sharpen&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20250724_184%2F1753329591483vtYsm_JPEG%2F%25C1%25A6%25B8%25F1%25C0%25BB-%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4_-001.jpg">
								</div>
							</div>
						</div>
					</a>

					<div class="post-actions">
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

					<div class="post-caption">
						<span class="caption-text"> 금보도 잘 안되는 도로 쪽에 새로 생긴 구로시로
							라멘집인데 완전 맛있네요 ㅋㅋㅋ 면도 쫄깃하고 시원한 국물이 일품! 분위기도 깔끔하고 다음에도 꼭 갈 생각입니다. </span>
						<span class="more-btn" onclick="toggleMore(this)">더보기</span>
					</div>
				</div>

				<!-- 게시물 2 -->
				<div class="post">
					<div class="post-header">
						<div class="post-user">
							<img src="https://via.placeholder.com/40">
							<div class="post-user-info">
								<b>OtherUsers</b> <span style="color: #888; font-size: 12px;">10분
									전</span>
							</div>
						</div>
						<button class="follow-btn">팔로우</button>
					</div>

					<a href="post.html">
						<div id="carousel2" class="carousel slide" data-bs-touch="true"
							data-bs-interval="false">
							<div class="carousel-inner">
								<div class="carousel-item active">
									<img
										src="https://search.pstatic.net/common/?autoRotate=true&type=w560_sharpen&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20250724_184%2F1753329591483vtYsm_JPEG%2F%25C1%25A6%25B8%25F1%25C0%25BB-%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4_-001.jpg">
								</div>
								<div class="carousel-item">
									<img
										src="https://search.pstatic.net/common/?autoRotate=true&type=w560_sharpen&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20250724_184%2F1753329591483vtYsm_JPEG%2F%25C1%25A6%25B8%25F1%25C0%25BB-%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4_-001.jpg">
								</div>
							</div>
						</div>
					</a>

					<div class="post-actions">
						<i class="bi bi-heart"></i> <i class="bi bi-chat ms-3"></i> <span
							class="stats ms-2">2 좋아요 · 5 댓글</span>
					</div>

					<div class="location-card"
						onclick="window.location='restaurant.html'">
						<div class="location-info">
							<b>구로시로</b> <span>일식 · 면</span>
						</div>
						<i class="bi bi-chevron-right"></i>
					</div>

					<div class="post-caption">
						<span class="caption-text"> 또 가고 싶은 라멘 맛집! 양도 많고 국물도 진하고
							면발도 탱탱해서 최고였어요. </span> <span class="more-btn"
							onclick="toggleMore(this)">더보기</span>
					</div>
				</div>

			</div>

		</div>
		<!-- 이 줄빼면 적용 안됨 -->
		<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
	</div>
</body>
</html>