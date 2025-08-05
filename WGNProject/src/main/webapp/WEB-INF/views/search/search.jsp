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
			
			<!----------------------- 사용자member 탭 ------------------------------>
			<div id="member-section" style="display: none;">
				<div class="member-header">
					<div class="feed-member">
						<img src="https://via.placeholder.com/40 alt="프로필">
						<!-- 예시 이미지 -->

						<div class="member-info">
							<span><b>홍길동</b></span> <span
								style="font-size: 12px; color: #888;">가나다라마바사</span>
						</div>
					</div>

					<!-- 팔로우 버튼 -->
					<form action="/member/follow" method="post">
						<input type="hidden" name="following_id" value="user123" />
						<button class="my-follow-btn">팔로우</button>
					</form>
				</div>
			</div>

			<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
		</div>
	</div>

	<script>
		$(function() {
			// 탭 클릭 이벤트
			$('.search-tabs .tab').on('click', function(e) {
				e.preventDefault(); // <a href="#"> 기본 동작 막기

				// 1. 모든 탭의 'active' 클래스 제거 → 시각적 효과 초기화
				$('.search-tabs .tab').removeClass('active');

				// 2. 클릭한 탭(this)에만 'active' 클래스 추가
				$(this).addClass('active');

				// 3. 모든 콘텐츠 영역 숨기기
				$('#res-section, #feed-section, #member-section').hide();

				// 4. 클릭한 탭 ID에 따라 해당 콘텐츠 영역만 표시
				if (this.id === 'tab-res') {
					$('#res-section').show(); // 음식점 탭 클릭 시
				} else if (this.id === 'tab-feed') {
					$('#feed-section').show(); // 피드 탭 클릭 시
				} else if (this.id === 'tab-member') {
					$('#member-section').show(); // 사용자 탭 클릭 시
				}
			});
		});
	</script>

</body>
</html>