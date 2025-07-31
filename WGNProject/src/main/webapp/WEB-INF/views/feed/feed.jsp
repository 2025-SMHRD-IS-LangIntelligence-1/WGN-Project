<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/feed.css" />
</head>
<body>
		<%@ include file="/WEB-INF/views/common/topBar.jsp"%>
		<div class="content">

			<!-- 상단 프로필 -->
			<div class="post-header">
				<div class="post-user">
					<img
						src="https://search.pstatic.net/common/?autoRotate=true&type=w560_sharpen&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20250724_184%2F1753329591483vtYsm_JPEG%2F%25C1%25A6%25B8%25F1%25C0%25BB-%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4_-001.jpg">
					<div class="post-user-info">
						<span><b>OtherUser</b></span> <span
							style="font-size: 12px; color: #888;">광주 · 2시간 전</span>
					</div>
				</div>
				<button class="follow-btn">팔로우</button>
			</div>

			<!-- 게시물 이미지 -->
			<div class="post-image">
				<img
					src="https://search.pstatic.net/common/?autoRotate=true&type=w560_sharpen&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20250724_184%2F1753329591483vtYsm_JPEG%2F%25C1%25A6%25B8%25F1%25C0%25BB-%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4_-001.jpg"
					alt="게시물">
			</div>

			<!-- 본문 내용 -->
			<div class="post-text">
				금보도 잘 안되는 도로 쪽에 새로 생긴 구로시로 라멘맛집 다녀왔습니다 ㅋㅋㅋ<br> 면 탱글 쫄깃 국물 시원하고
				같이 간 친구는 추가라멘 시켰어요
			</div>

			<!-- 장소 카드 -->
			<div class="location-card">
				<div class="location-info">
					<img src="https://via.placeholder.com/50">
					<div>
						<div style="font-weight: bold;">구로시로</div>
						<div style="font-size: 12px; color: #777;">광주 남구</div>
					</div>
				</div>
				<button>&rsaquo;</button>
			</div>

			<!-- 댓글 입력 -->
			<div class="comment-input">
				<input type="text" placeholder="여기에 입력하세요">
				<button>
					<i class="bi bi-send"></i>
				</button>
			</div>

			<!-- 댓글 목록 -->
			<div class="comments">

				<div class="comment">
					<img
						src="https://search.pstatic.net/common/?autoRotate=true&type=w560_sharpen&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20250724_184%2F1753329591483vtYsm_JPEG%2F%25C1%25A6%25B8%25F1%25C0%25BB-%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4_-001.jpg"
						class="comment-avatar">
					<div class="comment-body">
						<strong>user2</strong>
						<p>다음주에 가봐야겠네</p>
					</div>
					<i class="bi bi-heart"></i>
				</div>

				<div class="comment">
					<img
						src="https://search.pstatic.net/common/?autoRotate=true&type=w560_sharpen&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20250724_184%2F1753329591483vtYsm_JPEG%2F%25C1%25A6%25B8%25F1%25C0%25BB-%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4_-001.jpg"
						class="comment-avatar">
					<div class="comment-body">
						<strong>user7</strong>
						<p>와 라멘 진짜 맛있어보인다!</p>
					</div>
					<i class="bi bi-heart"></i>
				</div>

				<div class="comment">
					<img
						src="https://search.pstatic.net/common/?autoRotate=true&type=w560_sharpen&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20250724_184%2F1753329591483vtYsm_JPEG%2F%25C1%25A6%25B8%25F1%25C0%25BB-%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4_-001.jpg"
						class="comment-avatar">
					<div class="comment-body">
						<strong>user11</strong>
						<p>고기보소</p>
					</div>
					<i class="bi bi-heart"></i>
				</div>

			</div>

		</div>
		<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
</body>
</html>