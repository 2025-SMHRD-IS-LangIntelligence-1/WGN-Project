<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
				<a href="/wgn/profile/${feed.mb_id}" class="post-user"
					style="display: flex; align-items: center; text-decoration: none; color: inherit;">
					<img src="${profile.mb_img}">
					<div class="post-user-info">
						<span><b>${feed.mb_nick}</b></span> <span
							style="font-size: 12px; color: #888;">광주 · <fmt:formatDate
								value="${feed.created_at}" pattern="yyyy-MM-dd HH:mm" /></span>
					</div>
				</a>
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
							<!-- 수정: 모달 오픈 -->
							<button type="button" class="follow-btn edit-btn"
								data-bs-toggle="modal" data-bs-target="#editFeedModal">
								수정</button>
							<form action="${pageContext.request.contextPath}/feed/delete"
								method="post">
								<input type="hidden" name="feed_idx" value="${feed.feed_idx}">
								<button class="follow-btn delete-btn" type="submit">삭제</button>
							</form>
						</div>
					</c:when>
				</c:choose>
			</div>

			<!-- 게시물 이미지 -->
			<div id="carousel1" class="carousel slide feed-carousel"
				data-bs-touch="true" data-bs-interval="false" data-wrap="false">

				<div class="carousel-inner">
					<c:forEach var="imgUrl" items="${feed.imageUrls}"
						varStatus="status">
						<div class="carousel-item ${status.first ? 'active' : ''}">
							<img src="${imgUrl}" class="d-block w-100" alt="피드 이미지">
						</div>
					</c:forEach>
				</div>

				<!-- 좌우 버튼은 carousel-inner 바깥(형제) -->
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

				<div class="post-info">
					<div class="post-info">
						<c:choose>
							<c:when test="${isLiking}">
								<span class="clickable-heart stats" data-is-liking="true">
									<i class="bi bi-heart-fill clicked stats"></i>
								</span>
							</c:when>
							<c:otherwise>
								<span class="clickable-heart stats" data-is-liking="false">
									<i class="bi bi-heart stats"></i>
								</span>
							</c:otherwise>
						</c:choose>

						<!-- 좋아요, 댓글 묶음 -->
						<span class="like-comment-group stats"> <span
							class="like-count">${feed.feed_likes}</span> <span>좋아요 · </span>
							<span class="comment-count">0</span> <span>댓글</span>
						</span>
					</div>


					<div class="rating-box">
						<i class="bi bi-star"></i> ${feed.ratings != null ? feed.ratings : '없음'}
					</div>

				</div>



				<!-- 본문 내용 -->
				<div class="post-text">${feed.feed_content}</div>

				<!-- 장소 카드 -->
				<div class="location-card"
					onclick="window.location='${pageContext.request.contextPath}/restaurant?res_idx=${resInfo.res_idx}'">
					<div class="location-info">

						<c:choose>
							<c:when test="${empty resInfo.res_thumbnail}">
								<img
									src="https://cdn-icons-png.flaticon.com/128/17797/17797745.png"
									alt="no image" loading="lazy">
							</c:when>
							<c:otherwise>
								<img src="${resInfo.res_thumbnail}" alt="${resInfo.res_name}"
									loading="lazy"
									onerror="this.onerror=null;this.src='https://cdn-icons-png.flaticon.com/128/17797/17797745.png';">
							</c:otherwise>
						</c:choose>
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
			<!-- Edit Feed Modal -->
			<div class="modal fade" id="editFeedModal" tabindex="-1"
				aria-labelledby="editFeedModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-dialog-centered">
					<form class="modal-content"
						action="${pageContext.request.contextPath}/feed/update"
						method="post" enctype="multipart/form-data">
						<div class="modal-header">
							<h5 class="modal-title" id="editFeedModalLabel">피드 수정</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal"
								aria-label="닫기"></button>
						</div>

						<div class="modal-body">
							<input type="hidden" name="feed_idx" value="${feed.feed_idx}" />

							<!-- 본문 -->
							<div class="mb-3">
								<label class="form-label">내용</label>
								<textarea name="feed_content" class="form-control" rows="5">${fn:escapeXml(feed.feed_content)}</textarea>
							</div>

							<div class="mb-3">
								<label class="form-label">별점</label>
								<div class="star-rating">
									<c:set var="curRating" value="${feed.ratings}" />
									<input type="radio" id="star5" name="ratings" value="5"
										${curRating==5 ? 'checked' : ''} /> <label for="star5"
										title="5 stars">★</label> <input type="radio" id="star4"
										name="ratings" value="4" ${curRating==4 ? 'checked' : ''} />
									<label for="star4" title="4 stars">★</label> <input
										type="radio" id="star3" name="ratings" value="3"
										${curRating==3 ? 'checked' : ''} /> <label for="star3"
										title="3 stars">★</label> <input type="radio" id="star2"
										name="ratings" value="2" ${curRating==2 ? 'checked' : ''} />
									<label for="star2" title="2 stars">★</label> <input
										type="radio" id="star1" name="ratings" value="1"
										${curRating==1 ? 'checked' : ''} /> <label for="star1"
										title="1 star">★</label>
								</div>
							</div>

							<!-- 이미지 편집 -->
							<div class="mb-3">
								<label class="form-label">이미지 편집</label>
								<div class="form-check">
									<input class="form-check-input" type="radio" name="imageMode"
										id="modeAppend" value="APPEND" checked> <label
										class="form-check-label" for="modeAppend">선택 삭제 + 추가
										업로드</label>
								</div>
								<div class="form-check">
									<input class="form-check-input" type="radio" name="imageMode"
										id="modeReplace" value="REPLACE_ALL"> <label
										class="form-check-label" for="modeReplace">모두 교체 (기존
										전부 삭제 후 새로 업로드)</label>
								</div>
							</div>

							<!-- 기존 이미지 목록 (선택 삭제용) -->
							<c:if test="${not empty feed.imageUrls}">
								<div class="mb-2">
									<small class="text-muted">기존 이미지 (삭제할 이미지를 체크하세요)</small>
									<div class="d-flex gap-2 flex-wrap mt-2">
										<c:forEach var="u" items="${feed.imageUrls}">
											<label class="position-relative"
												style="display: inline-block;"> <img src="${u}"
												style="width: 100px; height: 100px; object-fit: cover; border-radius: 8px;">
												<!-- 백엔드에서 URL 기준 삭제라면 delete_img_urls[] 로 전송 --> <input
												type="checkbox" name="delete_img_urls" value="${u}"
												class="form-check-input position-absolute"
												style="top: 6px; left: 6px; transform: scale(1.1);">
											</label>
										</c:forEach>
									</div>
								</div>
							</c:if>

							<!-- 새 이미지 업로드 -->
							<div class="mb-2">
								<label class="form-label">새 이미지 업로드</label> <input type="file"
									name="images" class="form-control" multiple accept="image/*" />
								<div class="form-text">
									• <b>선택 삭제 + 추가 업로드</b>: 체크한 것만 지우고 새 이미지를 추가합니다.<br> • <b>모두
										교체</b>: 기존 이미지는 전부 삭제되고, 업로드한 이미지로 대체됩니다.
								</div>
							</div>
						</div>

						<div class="modal-footer">
							<button type="submit" class="btn btn-yellow">저장</button>
							<button type="button" class="btn btn-light"
								data-bs-dismiss="modal">취소</button>
						</div>
					</form>
				</div>
			</div>
			<!-- 수정 중 모달(오버레이) -->
			<div id="updatingOverlay" class="updating-backdrop"
				style="display: none;" role="dialog" aria-live="polite"
				aria-busy="true" aria-label="수정 진행 중">
				<div class="updating-card">
					<span class="loader"></span>
					<p class="updating-text">수정 중입니다...</p>
				</div>
			</div>

		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		let contextPath = "${pageContext.request.contextPath}"
		const feedIdx = $
		{
			feed != null ? feed.feed_idx : 'null'
		};
		window.feedIdx = feedIdx;
	</script>
	<script src="${pageContext.request.contextPath}/resources/js/feed.js"></script>

</body>
</html>