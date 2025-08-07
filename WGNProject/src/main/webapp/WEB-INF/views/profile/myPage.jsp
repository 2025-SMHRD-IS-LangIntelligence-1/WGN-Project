<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1">
<title>Profile</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/profile.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/feed.css" />
</head>
<body>
	<div class="mobile-container">
		<%@ include file="/WEB-INF/views/common/topBar.jsp"%>

		<!-- 모달창 -->
		<div id="profileModal" class="modal">
			<div class="modal-content">
				<span class="close">&times;</span>
				<form action="${pageContext.request.contextPath}/profile/update"
					method="post" enctype="multipart/form-data">
					<label>프로필 사진</label> <input type="file" name="file"
						value="${profile.mb_img}" accept="image/*" /> <label>닉네임</label>
					<input type="text" name="nickname" value="${profile.nickname}" />
					<label>소개글</label>
					<textarea name="intro">${profile.intro}</textarea>
					<button id="submitBtn" type="submit">저장</button>
				</form>
			</div>
		</div>

		<div class="content">

			<!-- 프로필 영역 -->
			<div class="profile">

				<!-- 프로필 상단: 사진 + 통계 -->
				<div class="profile-top">
					<img src="${profile.mb_img}" alt="프로필 사진">
					<div class="profile-stats">
						<div class="profile-stat">
							<strong>${profile.feed_num}</strong> <span>게시물</span>
						</div>
						<div class="profile-stat">
							<strong>${profile.follower}</strong> <span>팔로워</span>
						</div>
						<div class="profile-stat">
							<strong>${profile.following}</strong> <span>팔로잉</span>
						</div>
					</div>
				</div>
				<hr class="profile-divider">
				<!-- 닉네임/소개 -->
				<div class="profile-info">
					<h5>${profile.nickname}</h5>
					<p>${profile.intro}</p>
				</div>
				<div class="profile-info">

					<c:choose>
						<c:when test="${profile.mb_id ne sessionScope.member.mb_id}">
							<form action="${pageContext.request.contextPath}/member/follow"
								method="post">
								<input type="hidden" name="following_id" value="${member.mb_id}" />
								<c:choose>
									<c:when test="${isFollowing}">
										<button class="my-follow-btn following"
											data-following-id="${mb_id}" data-followed="true">팔로잉</button>
									</c:when>
									<c:otherwise>
										<button class="my-follow-btn" data-following-id="${mb_id}"
											data-followed="false">팔로우</button>
									</c:otherwise>
								</c:choose>
							</form>
						</c:when>
						<c:when test="${profile.mb_id eq sessionScope.member.mb_id}">
							<div class="btn-wrapper">
								<button class="follow-btn" id="profile-update-btn" type="submit">프로필
									수정</button>
							</div>
						</c:when>
					</c:choose>

				</div>

			</div>

			<!-- 탭 -->
			<div class="profile-tabs">
				<a href="#" class="tab active" id="tab-posts"> <i
					class="bi bi-grid-3x3-gap-fill"></i> <span>게시글</span>
				</a> <a href="#" class="tab" id="tab-map"> <i class="bi bi-map"></i>
					<span>지도</span>
				</a>
			</div>

			<!-- 게시글 섹션 -->
			<div id="posts-section">
				<div class="image-grid">
					<c:forEach var="feed" items="${feedDTOList}">
						<div class="cell"
							onclick="window.location='${pageContext.request.contextPath}/feed?feed_idx=${feed.feed_idx}'">
							<img src="${feed.imageUrls[0]}" alt="대표 이미지">
						</div>
					</c:forEach>
				</div>
			</div>

			<!-- 지도 섹션 (처음엔 비워둠) -->
			<!-- 지도 섹션 -->
			<div id="map-section" style="display: none;">
				<div id="map"
					style="width: 100%; height: auto; aspect-ratio: 16/9; max-height: 70vh;"></div>

				<!-- 지도 하단 탭 -->
				<div class="ranking-tabs">
					<ul class="nav nav-tabs" id="rankingTab" role="tablist">
						<li class="nav-item" style="width: 50%">
							<button class="nav-link active w-100" data-bs-toggle="tab"
								data-bs-target="#rank-content" type="button" role="tab">랭킹</button>
						</li>
						<li class="nav-item" style="width: 50%">
							<button class="nav-link w-100" data-bs-toggle="tab"
								data-bs-target="#wish-content" type="button" role="tab">찜</button>
						</li>
					</ul>
					<div class="tab-content" id="rankingTabContent">

						<!-- 랭킹 탭 -->
						<div class="tab-pane fade show active p-2" id="rank-content"
							role="tabpanel">
							<div id="rank-list" class="list-group">

								<c:if test="${not empty myfavoriteres}">
									<c:forEach var="favoriteres" items="${myfavoriteres}"
										varStatus="status">
										<c:choose>
											<c:when test="${status.index lt 3}">
												<!-- 1~3위: 메달 붙여서 출력 -->
												<a href="${pageContext.request.contextPath}/restaurant?res_idx=${favoriteres.res_idx}"
												style="text-decoration: none; color: inherit;">
												<div class="list-group-item d-flex align-items-center">
												
													<img src="${favoriteres.res_thumbnail}"
														class="rounded me-2"
														style="width: 60px; height: 60px; object-fit: cover;">
													<div class="flex-fill">
														<h6 class="mb-0">${favoriteres.res_name}</h6>
														<small class="text-muted">${favoriteres.res_addr}</small>
														<div class="mt-1">
															<span class="badge bg-warning text-dark">${favoriteres.fav_rating}</span>
														</div>
													</div>
													<div style="font-size: 24px; margin-left: 8px;">
														<c:choose>
															<c:when test="${status.index == 0}">
																<div style="font-size: 24px; margin-left: 8px;">🥇</div>
															</c:when>
															<c:when test="${status.index == 1}">
																<div style="font-size: 24px; margin-left: 8px;">🥈</div>
															</c:when>
															<c:when test="${status.index == 2}">
																<div style="font-size: 24px; margin-left: 8px;">🥉</div>
															</c:when>
														</c:choose>
													</div>

												</div>
												</a>
											</c:when>

											<c:otherwise>
												<!-- 4위부터: 숨겨진 영역 -->
												<div class="list-group-item d-flex align-items-center"
													style="display: none;" data-more="true">
													<img src="${favoriteres.res_thumbnail}"
														class="rounded me-2"
														style="width: 60px; height: 60px; object-fit: cover;">
													<div class="flex-fill">
														<h6 class="mb-0">${favoriteres.res_name}</h6>
														<small class="text-muted">${favoriteres.res_addr}</small>
														<div class="mt-1">
															<span class="badge bg-warning text-dark">4</span>
														</div>
													</div>
												</div>
											</c:otherwise>
										</c:choose>
									</c:forEach>

									<!-- 더보기 버튼 -->
									<c:if test="${fn:length(myfavoriteres) > 3}">
										<div class="text-center mt-2">
											<button class="btn btn-outline-secondary btn-sm"
												onclick="toggleFavorites()">더보기</button>
										</div>
									</c:if>
								</c:if>

							</div>
						</div>

						<!-- 찜 탭 -->
					
						<div class="tab-pane fade p-2" id="wish-content" role="tabpanel">
							<div id="wish-list" class="list-group">
							<c:if test="${not empty mygoingres}">
									<c:forEach var="goingres" items="${mygoingres}"
										varStatus="status">
										<c:choose>
											<c:when test="${status.index lt 3}">
												<a href="${pageContext.request.contextPath}/restaurant?res_idx=${goingres.res_idx}"
												style="text-decoration: none; color: inherit;">
												<div class="list-group-item d-flex align-items-center">
												
													<img src="${goingres.res_thumbnail}"
														class="rounded me-2"
														style="width: 60px; height: 60px; object-fit: cover;">
													<div class="flex-fill">
														<h6 class="mb-0">${goingres.res_name}</h6>
														<small class="text-muted">${goingres.res_addr}</small>
														
													</div>
												</div>
												</a>
											</c:when>

											<c:otherwise>
												<!-- 4위부터: 숨겨진 영역 -->
												<div class="list-group-item d-flex align-items-center"
													style="display: none;" data-more="true">
													<img src="${goingres.res_thumbnail}"
														class="rounded me-2"
														style="width: 60px; height: 60px; object-fit: cover;">
													<div class="flex-fill">
														<h6 class="mb-0">${goingres.res_name}</h6>
														<small class="text-muted">${goingres.res_addr}</small>
														<div class="mt-1">
															<span class="badge bg-warning text-dark">4</span>
														</div>
													</div>
												</div>
											</c:otherwise>
										</c:choose>
									</c:forEach>

									<!-- 더보기 버튼 -->
									<c:if test="${fn:length(mygoingres) > 3}">
										<div class="text-center mt-2">
											<button class="btn btn-outline-secondary btn-sm"
												onclick="toggleFavorites()">더보기</button>
										</div>
									</c:if>
								</c:if>
							</div>
						</div>
						
					</div>
				</div>

			</div>
		</div>
	</div>


	<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4307aaa155e95c89c9a2cbb564db3cd3"></script>
	<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/myPage.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/feed.js"></script>
	<script>
	var rankData = [
		<c:forEach var="favoriteres" items="${myfavoriteres}" varStatus="status">
			{
				res_idx: ${favoriteres.res_idx},
				name: "${favoriteres.res_name}",
				lat: ${favoriteres.lat},
				lon: ${favoriteres.lon}
			}<c:if test="${!status.last}">,</c:if>
		</c:forEach>
	];
	
	var goingData = [
		<c:forEach var="goingres" items="${mygoingres}" varStatus="status">
		{
			res_idx: ${goingres.res_idx},
			name: "${goingres.res_name}",
			lat: ${goingres.lat},
			lon: ${goingres.lon}
		}<c:if test="${!status.last}">,</c:if>
	</c:forEach>
	];
	</script>
</body>
</html>
