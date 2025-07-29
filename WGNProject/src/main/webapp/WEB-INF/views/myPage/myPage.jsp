<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MyPage</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/myPage.css" />
</head>
<body>
	<div class="mobile-container">
		<div class="content">
			<h1>MyPage</h1>
				<div id="userInfoArea1">
					닉네임
					팔로우하기
				</div>
				<nav id="userInfoArea2" class="myPageBox">
					<span class="userInfo">게시글</span>
					<a class="userInfo">팔로워</a>
					<a class="userInfo">팔로잉</a>
					<span class="userInfo">게시글</span>
					<a class="userInfo">팔로워</a>
					<a class="userInfo">팔로잉</a>
				</nav>
				<nav id="menuArea" class="myPageBox">
					<button id="feed">게시글</button>
					<button id="map">지도</button>
					<button id="bookmark">북마크</button>
				</nav>
				<div id="resultArea" class="myPageBox">
					
				</div>
		</div>
		<%@ include file="/WEB-INF/views/common/bottomBar.jsp" %>
	</div>
	
	<script type="text/javascript">
		let feed = document.getElementById("feed");
		let map = document.getElementById("map");
		let bookmark = document.getElementById("bookmark");
		let resultArea = document.getElementById("resultArea");
		
		feed.addEventListener("click", () => {
			resultArea.innerHTML = "게시글";
		});
		
		map.addEventListener("click", () => {
			resultArea.innerHTML = "지도";
		});
		
		bookmark.addEventListener("click", () => {
			resultArea.innerHTML = "북마크";
		});
	</script>
</body>
</html>