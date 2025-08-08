<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet">
</head>
<body>
	<div class="mobile-container">
		<%@ include file="/WEB-INF/views/common/topBar.jsp"%>
		<div class="content">

			<!-- 상단 프로필 -->
			<div class="post-header">
				<div class="post-user">
					<img src="${profile.mb_img}">
					<div class="post-user-info">
						<span><b>${feed.mb_nick}</b></span> <span
							style="font-size: 12px; color: #888;">광주 · <fmt:formatDate
								value="${feed.created_at}" pattern="yyyy-MM-dd HH:mm" /></span>
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
										data-following-id="${feedOwnerProfile.mb_id}"
										data-followed="true">팔로잉</button>
								</c:when>
								<c:otherwise>
									<button class="my-follow-btn"
										data-following-id="${feedOwnerProfile.mb_id}"
										data-followed="false">팔로우</button>
								</c:otherwise>
							</c:choose>
						</form>
					</c:when>
					<c:when test="${feed.mb_id eq sessionScope.member.mb_id}">
						<div class="btn-wrapper">
							<form action="${pageContext.request.contextPath}/feed/delete"
								method="post">
								<input type="hidden" name="feed_idx" value="${feed.feed_idx}">
								<button class="follow-btn edit-btn" type="submit">수정</button>
								<button class="follow-btn delete-btn" type="submit">삭제</button>
							</form>
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

				<!-- 좋아요 / 댓글 수 / 평점 -->
				<div
					class="post-info d-flex align-items-center justify-content-between"
					data-feed-idx="${feed.feed_idx}">

					<div>
						<span class="clickable-heart"> <i class="bi bi-heart"></i>
						</span> <span class="like-count">${feed.feed_likes}</span> <i
							class="bi bi-chat-square-dots"
							style="font-size: 20px; margin-left: 10px;"></i> <span>${commentsCount}</span>
						<!-- 댓글 수 있으면 넣기 -->
					</div>

					<div class="rating-box">
						<i class="bi bi-star"></i>
						${feed.ratings != null ? feed.ratings : '없음'}</div>

				</div>



				<!-- 본문 내용 -->
				<div class="post-text">${feed.feed_content}</div>

				<!-- 장소 카드 -->
				<div class="location-card">
					<div class="location-info"
						onclick="window.location='${pageContext.request.contextPath}/restaurant?res_idx=${resInfo.res_idx}'">
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
								<img src="${comment.mb_img}" class="comment-avatar">
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
	<script src="${pageContext.request.contextPath}/resources/js/feed.js"></script>

</body>
</html>