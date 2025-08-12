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

<script src="<c:url value='/resources/js/sidebar.js'/>"></script>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
	rel="stylesheet">

</head>
<!--
c:choose : 조건문
c:when : 참
c:otherwise : 거짓
-->
<body>

	<%-- 로그인 여부 플래그 --%>
	<c:set var="isLoggedIn" value="${not empty sessionScope.member}" />

	<%-- ✅ 로그인한 경우에만 왼쪽 패널들 렌더링 --%>
	<c:if test="${isLoggedIn}">
		<!-- 왼쪽 패널 -->
		<aside class="left-panel" data-panel="likes">
			<div class="left-panel-content">
				<h3>좋아요 관리</h3>
				왜 글자가 안뜰까 죽여버리겠어
			</div>
		</aside>

		<aside class="left-panel" data-panel="comments">
			<div class="left-panel-content">
				<h3>마이 댓글 관리</h3>
			</div>
		</aside>

		<aside class="left-panel" data-panel="reviews">
			<div class="left-panel-content">
				<h3>마이 리뷰 관리</h3>
			</div>
		</aside>
	</c:if>

	<!-- 오른쪽 사이드바 -->
	<aside class="side-bar">
		<section class="sidebar-profile-top">
			<c:choose>
				<%-- ✅ 로그인 + 프로필 있을 때만 프로필 표시 --%>
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
				<%-- ✅ 로그아웃(혹은 프로필 없음) → 로그인 안내만 표시 --%>
				<c:otherwise>
					<div class="login-prompt">
						<p>로그인을 해주세요.</p>
						<a href="<c:url value='/member/login'/>">로그인</a>
					</div>
				</c:otherwise>
			</c:choose>
		</section>

		<%-- ✅ 로그인한 경우에만 메뉴/구분선 렌더링 --%>
		<c:if test="${isLoggedIn}">
			<hr class="divider">

<<<<<<< HEAD
			<ul class="user-menu">
				<li><a href="#" data-target="likes">피드 좋아요 관리</a></li>
				<li><a href="#" data-target="comments">마이 댓글달기 관리</a></li>
				<li><a href="#" data-target="reviews">마이 리뷰작성 관리</a></li>
			</ul>

			<hr class="menu-sep">

			<ul class="user-menu">
				<li><a href="<c:url value='/member/logout'/>">로그아웃</a></li>
			</ul>
		</c:if>
=======
		<ul class="user-menu" id="user-menu">
			<li><a href="#" data-target="likes">피드 좋아요 관리</a></li>
			<li><a href="#" data-target="comments">마이 댓글달기 관리</a></li>
			<li><a href="#" data-target="reviews">마이 리뷰작성 관리</a></li>
			<li><a href="${pageContext.request.contextPath}/member/logout">로그아웃</a></li>
		</ul>
>>>>>>> 256e671a5886b5c93342ad8327dc320402aaeb2e
	</aside>

</body>
</html>