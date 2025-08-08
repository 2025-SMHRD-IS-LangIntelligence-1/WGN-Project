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
			<!-- 조건문 -->
			<c:choose>
				<!-- 참(로그인 된 상태) -->
			    <c:when test="${not empty profile}">
			    
			        <div class="profile-info">
			       		<div class="profile-img">
			        		<img src="${profile.mb_img}" alt="프로필 사진" style="width: 70px; height: 70px";>
			        	</div>
			        	<div class="profile-name">
							<h5>${profile.nickname}</h5>
						</div>
						<div class="profile-intro">
							<p>${profile.intro}</p>
						</div>
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
			    <!-- 거짓(로그인 안된 상태) -->
			    <c:otherwise>
			        <p>로그인을 해주세요.</p>
			        <a href="member/login">로그인 하러가기</a>
			    </c:otherwise>
			</c:choose>
		</section>
		<!-- 수평 구분선 -->
		<hr class="divider">
		  <ul class="user-menu">
		    <li><a href="#">좋아요 관리</a></li>
		    <li><a href="#">마이 댓글 관리</a></li>
		    <li><a href="#">마이 리뷰 관리</a></li>
		    <li><a href="${pageContext.request.contextPath}/member/logout">로그아웃</a></li>
		  </ul>
	</aside>
		
</body>
</html>