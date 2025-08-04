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

</head>
<body>

	<aside class="side-bar">
		<section class="profile-top">
			<c:choose>
			    <c:when test="${not empty profile}">
			        <div class="profile-info">
			        	<img src="${profile.mb_img}" alt="프로필 사진" style="width: 70px; height: 70px";>
						<h5>${profile.nickname}</h5>
						<p>간단한 소개글을 적을 수 있습니다.</p>
					</div>
					<div class="profile-stats">
						<div class="profile-stat">
							<strong>${profile.follower}</strong> <span>팔로워</span>
						</div>
						<div class="profile-stat">
							<strong>${profile.following}</strong> <span>팔로잉</span>
						</div>
					</div>
			    </c:when>
			    <c:otherwise>
			        <p>로그인을 해주세요.</p>
			        <a href="member/login">로그인 하러가기</a>
			    </c:otherwise>
			</c:choose>
		</section>
		<hr class="divider">
		  <ul class="user-menu">
		    <li><a href="#">개인 정보 수정</a></li>
		    <li><a href="#">마이 피드 관리</a></li>
		    <li><a href="#">마이 댓글 관리</a></li>
		    <li><a href="#">마이 리뷰 관리</a></li>
		    <li><a href="${pageContext.request.contextPath}/member/logout">로그아웃</a></li>
		  </ul>
	</aside>
		
</body>
</html>