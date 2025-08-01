<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
</head>
<body>

	<div id="side-bar">
		<div class="profile-top">
			<!-- 닉네임/소개 -->
			<div class="profile-info">
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
		</div>
	<hr class="profile-divider">
	  <ul>
	    <li><a href="#">홈</a></li>
	    <li><a href="#">소개</a></li>
	    <li><a href="#">서비스</a></li>
	    <li><a href="#">연락처</a></li>
	  </ul>
	</div>
		
</body>
</html>