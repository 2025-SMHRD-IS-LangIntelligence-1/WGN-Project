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

</head>
<!--
c:choose : 조건문
c:when : 참
c:otherwise : 거짓
-->
<body>

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

	<!-- 오른쪽 사이드바 -->
	<aside class="side-bar">
		<section class="sidebar-profile-top">
			<c:choose>
				<c:when test="${not empty profile}">
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
				<c:otherwise>
					<div class="login-prompt">
						<p>로그인을 해주세요.</p>
						<a href="member/login">로그인 하러가기</a>
					</div>
				</c:otherwise>
			</c:choose>
		</section>

		<hr class="divider">

		<ul class="user-menu" id="user-menu">
			<li><a href="#" data-target="likes">피드 좋아요 관리</a></li>
			<li><a href="#" data-target="comments">마이 댓글달기 관리</a></li>
			<li><a href="#" data-target="reviews">마이 리뷰작성 관리</a></li>
			<li><a href="${pageContext.request.contextPath}/member/logout">로그아웃</a></li>
		</ul>
	</aside>
	<!-- 로그아웃 글자 숨기기 구분 -->
	<body class="${empty sessionScope.member ? 'logged-out' : 'logged-in'}">

<script>
document.addEventListener('DOMContentLoaded', () => {
  // 요소들 직접 잡기
  const sideBar      = document.querySelector('.side-bar');
  const topbarIcon   = document.querySelector('.top-bar i') || document.querySelector('#top-bar i');

  const linkLikes    = document.querySelector('.user-menu a[data-target="likes"]');
  const linkComments = document.querySelector('.user-menu a[data-target="comments"]');
  const linkReviews  = document.querySelector('.user-menu a[data-target="reviews"]');

  const panelLikes    = document.querySelector('.left-panel[data-panel="likes"]');
  const panelComments = document.querySelector('.left-panel[data-panel="comments"]');
  const panelReviews  = document.querySelector('.left-panel[data-panel="reviews"]');
  
  const allComments = document.querySelectorAll('.comment');

  if (!sideBar) return;

  // 모두 닫기 (단순 버전)
  function closeAllPanels() {
    panelLikes?.classList.remove('show');
    panelComments?.classList.remove('show');
    panelReviews?.classList.remove('show');
  }

  // 하나만 열기
  function openOnly(panel) {
    closeAllPanels();
    panel?.classList.add('show');
  }

  // 각 메뉴에 직접 바인딩
  linkLikes?.addEventListener('click', (e) => {
    e.preventDefault();
    if (panelLikes?.classList.contains('show')) {
      panelLikes.classList.remove('show');
    } else {
      // 사이드바 닫혀있다면 열어두고
      if (!sideBar.classList.contains('active')) sideBar.classList.add('active');
      openOnly(panelLikes);
    }
  });

  linkComments?.addEventListener('click', (e) => {
    e.preventDefault();
    if (panelComments?.classList.contains('show')) {
      panelComments.classList.remove('show');
    } else {
      if (!sideBar.classList.contains('active')) sideBar.classList.add('active');
      openOnly(panelComments);
    }
  });

  linkReviews?.addEventListener('click', (e) => {
    e.preventDefault();
    if (panelReviews?.classList.contains('show')) {
      panelReviews.classList.remove('show');
    } else {
      if (!sideBar.classList.contains('active')) sideBar.classList.add('active');
      openOnly(panelReviews);
    }
  });

  // 상단바 아이콘 클릭 뒤, 사이드바가 닫혀 있으면 패널도 닫기
  topbarIcon?.addEventListener('click', () => {
    // 초보 느낌: rAF 대신 setTimeout(0)
    setTimeout(() => {
      if (!sideBar.classList.contains('active')) {
        closeAllPanels();
      }
    }, 0);
  });

  // 사이드바 바깥 클릭하면 닫기 + 패널 닫기 (간단 click 사용)
  document.addEventListener('click', (e) => {
    if (!sideBar.classList.contains('active')) return;

    const insideSidebar = e.target.closest('.side-bar');
    const onToggleIcon  = e.target.closest('.top-bar i') || e.target.closest('#top-bar i');

    if (insideSidebar || onToggleIcon) return;

    sideBar.classList.remove('active');
    closeAllPanels();
  });

  // ESC로 패널 닫기
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeAllPanels();
  });
});
</script>

</body>
</html>