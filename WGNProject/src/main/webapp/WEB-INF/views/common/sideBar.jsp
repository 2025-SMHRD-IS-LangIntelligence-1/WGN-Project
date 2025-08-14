<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>sideBar</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/sidebar.css" />

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
	rel="stylesheet">

<!-- sidebar.js는 DOMContentLoaded 이벤트로 동작하므로 head에 있어도 됩니다 -->
<script src="<c:url value='/resources/js/sidebar.js'/>"></script>
</head>

<body>
	<%-- 로그인 여부 플래그 --%>
	<c:set var="isLoggedIn" value="${not empty sessionScope.member}" />

	<!-- 오른쪽 사이드바 -->
	<aside class="side-bar">
		<section class="sidebar-profile-top">
			<c:choose>
				<%-- 로그인 + 프로필 있을 때만 프로필 표시 --%>
				<c:when test="${isLoggedIn and not empty profile}">
					<div class="sidebar-profile-info">
						<div class="sidebar-profile-img">
							<img src="${profile.mb_img}" alt="프로필 사진">
						</div>
						<div class="sidebar-profile-name">
							<h5>${profile.nickname}</h5>
						</div>
						<div class="sidebar-profile-intro">
							<p>${profile.intro}</p>
						</div>
					</div>
				</c:when>
				<%-- 로그아웃(혹은 프로필 없음) → 로그인 안내만 표시 --%>
				<c:otherwise>
					<div class="login-prompt">
						<p>로그인을 해주세요.</p>
						<a href="<c:url value='/member/login'/>">로그인</a>
					</div>
				</c:otherwise>
			</c:choose>
		</section>

		<%-- 로그인한 경우에만 메뉴/구분선 렌더링 --%>
		<c:if test="${isLoggedIn}">
			<hr class="divider">

			<ul class="user-menu">
				<li><a href="#" data-target="likes">피드 좋아요 관리</a></li>
				<li><a href="#" data-target="comments">마이 댓글 관리</a></li>
				<li><a href="#" data-target="reviews">마이 음식점 리뷰 관리</a></li>
			</ul>

			<hr class="menu-sep">

			<ul class="user-menu">
				<li><a href="<c:url value='/member/logout'/>">로그아웃</a></li>
			</ul>
		</c:if>
	</aside>

	<!-- 큰 모달 컨테이너 (없어도 JS가 동적 생성하지만, 넣어두면 즉시 사용 가능) -->
	<div id="bigModal" class="big-modal" aria-hidden="true" role="dialog"
		aria-modal="true">
		<div class="big-modal__dialog" role="document">
			<div class="big-modal__header">
				<h3 class="big-modal__title" id="bigModalTitle"></h3>
				<button type="button" class="big-modal__close" aria-label="닫기">&times;</button>
			</div>
			<div class="big-modal__body" id="bigModalBody">
				<!-- JS가 내용 주입 -->
			</div>
		</div>
	</div>
	<script>
		const mb_id = "${sessionScope.member != null ? sessionScope.member.mb_id : ''}";
		const contextPath = "${pageContext.request.contextPath}";
	</script>
</body>
</html>
