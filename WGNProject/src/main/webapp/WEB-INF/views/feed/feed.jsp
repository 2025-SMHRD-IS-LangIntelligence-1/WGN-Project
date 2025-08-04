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
						<form action="${pageContext.request.contextPath}/member/follow"
							method="post">
							<input type="hidden" name="following_id" value="${feed.mb_id}" />
							<c:choose>
								<c:when test="${isFollowing}">
									<button class="my-follow-btn following"
										data-following-id="${feedOwnerId}" data-followed="true">팔로잉</button>
								</c:when>
								<c:otherwise>
									<button class="my-follow-btn"
										data-following-id="${feedOwnerId}" data-followed="false">팔로우</button>
								</c:otherwise>
							</c:choose>
						</form>
					</c:when>
					<c:when test="${feed.mb_id eq sessionScope.member.mb_id}">
						<div class="btn-wrapper">
							<button class="follow-btn">수정</button>
							<button class="follow-btn">삭제</button>
						</div>
					</c:when>
				</c:choose>
			</div>

			<!-- 게시물 이미지 -->
			<div id="carousel1" class="carousel slide" data-bs-touch="true"
				data-bs-interval="false" data-wrap="false">

				<div class="carousel-inner">
					<c:forEach var="imgUrl" items="${feed.imageUrls}"
						varStatus="status">
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
					<div class="location-info"  onclick="window.location='${pageContext.request.contextPath}/restaurant'">
						<img src="${resInfo.res_thumbnail}">
						<div>
							<div style="font-weight: bold;">${resInfo.res_name}</div>
							<div style="font-size: 12px; color: #777;">${resInfo.res_addr}</div>
						</div>
					</div>
					<button>&rsaquo;</button>
				</div>

				<!-- 댓글 입력 -->
				<form action="${pageContext.request.contextPath}/feed/comment"
					method="post">
					<div class="comment-input">
						<input type="hidden" name="feed_idx" value="${feed.feed_idx}" />
						<input type="text" name="cmt_content" placeholder="여기에 입력하세요">
						<button type="submit">
							<i class="bi bi-send"></i>
						</button>
					</div>
				</form>

				<!-- 댓글 목록 -->
				<div class="comments">
					<div class="comments">
						<c:forEach var="comment" items="${comments}">
							<div class="comment">
								<img src="" class="comment-avatar">
								<div class="comment-body">
									<!-- 작성자 닉네임 -->
									<strong>${comment.mb_nick}</strong>
									<!-- 댓글 내용 -->
									<p>${comment.cmt_content}</p>
								</div>
								<i class="bi bi-heart"></i>
							</div>
						</c:forEach>
					</div>


				</div>

			</div>
	<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		contextPath = "${pageContext.request.contextPath}"
	</script>

</body>
</html>