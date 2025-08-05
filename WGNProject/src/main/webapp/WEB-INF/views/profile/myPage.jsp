<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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

				<form action="${pageContext.request.contextPath}/profile/update}" method="post">
					<label>프로필 사진</label>
					<input type="file" name="profileImgUrl" value="${profile.mb_img}" />
					<label>닉네임</label>
					<input type="text" name="intro" value="${profile.nickname}" />
					<label>소개글</label>
					<textarea name="intro">${profile.intro}</textarea>
					<button type="submit">저장</button>
				</form>
				
			</div>
		</div>

		<div class="content">

			<!-- 프로필 영역 -->
			<div class="profile">

				<!-- 프로필 상단: 사진 + 통계 -->
				<div class="profile-top">
					<img
						src="${profile.mb_img}"
						alt="프로필 사진">
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
					<p>간단한 소개글을 적을 수 있습니다.</p>
				</div>
				<div class="profile-info">

					<c:choose>
						<c:when test="${profile.nickname ne sessionScope.member.mb_nick}">
							<form action="${pageContext.request.contextPath}/member/follow"
								method="post">
								<input type="hidden" name="following_id" value="${member.mb_id}" />
								<c:choose>
									<c:when test="${isFollowing}">
										<button class="my-follow-btn following"
											data-following-id="${mb_id}" data-followed="true">팔로잉</button>
									</c:when>
									<c:otherwise>
										<button class="my-follow-btn"
											data-following-id="${mb_id}" data-followed="false">팔로우</button>
									</c:otherwise>
								</c:choose>
							</form>
						</c:when>
						<c:when test="${profile.nickname eq sessionScope.member.mb_nick}">
							<div class="btn-wrapper">
								<form action="${pageContext.request.contextPath}/feed/edit"
									method="post">
									<button class="follow-btn profile-edit-btn" type="submit">프로필 수정</button>
								</form>
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

								<!-- 1위 -->
								<div class="list-group-item d-flex align-items-center">
									<img
										src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340"
										class="rounded me-2"
										style="width: 60px; height: 60px; object-fit: cover;">
									<div class="flex-fill">
										<h6 class="mb-0">해물짬뽕 전문점</h6>
										<small class="text-muted">광주광역시 북구</small>
										<div class="mt-1">
											<span class="badge bg-warning text-dark">4.8</span>
										</div>
									</div>
									<div style="font-size: 24px; margin-left: 8px;">🥇</div>
								</div>

								<!-- 2위 -->
								<div class="list-group-item d-flex align-items-center">
									<img
										src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340"
										class="rounded me-2"
										style="width: 60px; height: 60px; object-fit: cover;">
									<div class="flex-fill">
										<h6 class="mb-0">편육</h6>
										<small class="text-muted">광주광역시 북구</small>
										<div class="mt-1">
											<span class="badge bg-warning text-dark">4.5</span>
										</div>
									</div>
									<div style="font-size: 24px; margin-left: 8px;">🥈</div>
								</div>

								<!-- 3위 -->
								<div class="list-group-item d-flex align-items-center">
									<img
										src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340"
										class="rounded me-2"
										style="width: 60px; height: 60px; object-fit: cover;">
									<div class="flex-fill">
										<h6 class="mb-0">조개찜 전문점</h6>
										<small class="text-muted">광주광역시 북구</small>
										<div class="mt-1">
											<span class="badge bg-warning text-dark">4.3</span>
										</div>
									</div>
									<div style="font-size: 24px; margin-left: 8px;">🥉</div>
								</div>

							</div>
						</div>

						<!-- 찜 탭 -->
						<div class="tab-pane fade p-2" id="wish-content" role="tabpanel">
							<div id="wish-list" class="list-group">

								<!-- 찜 1 -->
								<div class="list-group-item d-flex align-items-center">
									<img
										src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340"
										class="rounded me-2"
										style="width: 60px; height: 60px; object-fit: cover;">
									<div class="flex-fill">
										<h6 class="mb-0">내가 찜한 가게 1</h6>
										<small class="text-muted">광주 남구</small>
									</div>
								</div>

								<!-- 찜 2 -->
								<div class="list-group-item d-flex align-items-center">
									<img
										src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340"
										class="rounded me-2"
										style="width: 60px; height: 60px; object-fit: cover;">
									<div class="flex-fill">
										<h6 class="mb-0">내가 찜한 가게 2</h6>
										<small class="text-muted">광주 서구</small>
									</div>
								</div>

							</div>
						</div>
					</div>
				</div>

			</div>
		</div>

			<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
		</div>
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script
			src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

		<script type="text/javascript"
			src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4307aaa155e95c89c9a2cbb564db3cd3"></script>
		<script
			src="${pageContext.request.contextPath}/resources/js/myPage.js"></script>
		<script src="${pageContext.request.contextPath}/resources/js/feed.js"></script>
</body>
</html>
