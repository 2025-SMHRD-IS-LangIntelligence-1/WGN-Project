<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Profile</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/profile.css" />

</head>
<body>

		<%@ include file="/WEB-INF/views/common/topBar.jsp"%>
	<div class="content">

		<!-- 프로필 영역 -->
		<div class="profile">

			<!-- 프로필 상단: 사진 + 통계 -->
			<div class="profile-top">
				<img
					src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340"
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

			<!-- 닉네임/소개 -->
			<div class="profile-info">
				<h5>${profile.nickname}</h5>
				<p>간단한 소개글을 적을 수 있습니다.</p>
			</div>

		</div>

		<!-- 내 피드 3열 그리드 -->
		<div class="container-fluid grid-feed px-0">
			<div class="row g-1">
				<div class="col-4" onclick="window.location='post.html'">
					<img
						src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340">
				</div>
				<div class="col-4">
					<img
						src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340">
				</div>
				<div class="col-4">
					<img
						src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340">
				</div>
				<div class="col-4">
					<img
						src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340">
				</div>
				<div class="col-4">
					<img
						src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340">
				</div>
				<div class="col-4">
					<img
						src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340">
				</div>
				<div class="col-4">
					<img
						src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340">
				</div>
			</div>
		</div>
		</div>

		<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>


</body>
</html>