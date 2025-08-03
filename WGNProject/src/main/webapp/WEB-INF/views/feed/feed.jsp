<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1">
<title>Feed</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/feed.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/home.css" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body>
	<div class="mobile-container">
		<%@ include file="/WEB-INF/views/common/topBar.jsp"%>
		<div class="content">

			<!-- 상단 프로필 -->
			<div class="post-header">
				<div class="post-user">
					<img
						src="https://search.pstatic.net/common/?autoRotate=true&type=w560_sharpen&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20250724_184%2F1753329591483vtYsm_JPEG%2F%25C1%25A6%25B8%25F1%25C0%25BB-%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4_-001.jpg">
					<div class="post-user-info">
						<span><b>${feed.mb_nick}</b></span> <span
							style="font-size: 12px; color: #888;">광주 ·
							${feed.created_at}</span>
					</div>
				</div>
				<c:choose>
				    <c:when test="${feed.mb_id ne sessionScope.member.mb_id}">
				        <button class="follow-btn">팔로우</button>
				    </c:when>
				    <c:when test="${feed.mb_id eq sessionScope.member.mb_id}">
				        <div class="btn-wrapper">
				        	<button class="follow-btn">수정</button><button class="follow-btn">삭제</button>
				        </div>
				    </c:when>
				</c:choose>
			</div>

			<!-- 게시물 이미지 -->
			<div id="carousel1" class="carousel slide" data-bs-touch="true" data-bs-interval="false" data-wrap="false">
				
				<div class="carousel-inner">
					<c:forEach var="imgUrl" items="${feed.imageUrls}" varStatus="status">
						<div class="carousel-item ${status.first ? 'active' : ''}">
							<img src="${imgUrl}" class="d-block w-100">
						</div>
					</c:forEach>
				
				<!-- 좌우 버튼 -->
				<button class="carousel-control-prev" type="button"
					data-bs-target="#carousel1" data-bs-slide="prev">
					<span class="carousel-control-prev-icon"></span>
				</button>
				<button class="carousel-control-next" type="button"
					data-bs-target="#carousel1" data-bs-slide="next">
					<span class="carousel-control-next-icon"></span>
				</button>
			</div>

			<!-- 본문 내용 -->
			<div class="post-text">${feed.feed_content}</div>

			<!-- 장소 카드 -->
			<div class="location-card">
				<div class="location-info">
					<img src="${resInfo.res_thumbnail}">
					<div>
						<div style="font-weight: bold;">${resInfo.res_name}</div>
						<div style="font-size: 12px; color: #777;">${resInfo.res_addr}</div>
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
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script>
    	const contextPath = '${pageContext.request.contextPath}';
	</script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body>
</html>