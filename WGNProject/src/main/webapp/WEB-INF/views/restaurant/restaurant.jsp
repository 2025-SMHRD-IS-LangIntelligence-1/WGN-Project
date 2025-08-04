<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1">
  <title>Restaurant</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/restaurant.css" />
</head>
<body>
<div class="mobile-container">
  <%@ include file="/WEB-INF/views/common/topBar.jsp"%>

  <!-- 대표 이미지 -->
  <div class="hero-img" id="heroImg" style="background-image:url('https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340');"></div>

  <!-- 기본 정보 -->
  <div class="restaurant-info">
    <h2>구로시로 <i class="bi bi-star-fill text-warning"></i></h2>
    <div>광주 광산구 구로시로</div>
    <div class="rating">4.0 (32 리뷰)</div>
  </div>

  <!-- 탭 -->
  <div class="restaurant-tabs-wrapper">
    <div class="restaurant-tabs" id="restaurantTabs">
      <a href="#info-section" class="tab-link active">정보</a>
      <a href="#menu-section" class="tab-link">메뉴</a>
      <a href="#rating-section" class="tab-link">평점</a>
      <a href="#review-section" class="tab-link">리뷰</a>
    </div>
  </div>

  <!-- 정보 -->
  <div class="card-section" id="info-section">
    <h5 class="section-title">정보</h5>
    <div class="review-card d-flex justify-content-between"><span><i class="bi bi-clock"></i> 영업시간</span><span>11:00 ~ 20:30</span></div>
    <div class="review-card d-flex justify-content-between"><span><i class="bi bi-telephone"></i> 전화번호</span><span>062-611-4141</span></div>
    <div class="review-card d-flex justify-content-between"><span><i class="bi bi-geo-alt"></i> 주소</span><span>광주 광산구</span></div>
  </div>

  <!-- 메뉴 -->
  <div class="card-section" id="menu-section">
    <h5 class="section-title">메뉴</h5>
    <div class="review-card d-flex justify-content-between"><span>도리파이탄</span><span>13,000원</span></div>
    <div class="review-card d-flex justify-content-between"><span>쇼유라멘</span><span>12,000원</span></div>
    <div class="review-card d-flex justify-content-between"><span>시오라멘</span><span>12,000원</span></div>
  </div>

  <!-- 평점 -->
  <div class="card-section" id="rating-section">
    <h5 class="section-title">평점</h5>
    <div class="review-card d-flex justify-content-between align-items-center"><span>네이버 평점</span><span style="color: green; font-size: 18px;">★★★★☆</span></div>
    <div class="review-card d-flex justify-content-between align-items-center"><span>와구냠 평점</span><span style="color: orange; font-size: 18px;">★★★★☆</span></div>
    <div class="mt-3 text-center">
      <img src="${pageContext.request.contextPath}/resources/img/wordcloud_sample.png" alt="워드 클라우드" class="img-fluid" style="max-width: 100%; border-radius: 10px;">
    </div>
  </div>

  <!-- 리뷰 -->
  <div class="card-section" id="review-section">
    <h5 class="section-title">리뷰</h5>
    <div class="review-card d-flex align-items-center">
      <div class="review-img"></div>
      <div><div class="review-user">UserA</div><div class="review-content">면발이 탱탱하고 국물이 끝내줘요!</div></div>
    </div>
    <div class="review-card d-flex align-items-center">
      <div class="review-img"></div>
      <div><div class="review-user">UserB</div><div class="review-content">서비스도 좋고 가성비 최고입니다.</div></div>
    </div>
  </div>

  <%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
</div>

<!-- 이미지 확대 레이어 -->
<div id="fullHero" class="full-hero" style="display:none;">
  <button class="close-btn" onclick="closeHero()">×</button>
  <div class="full-hero-img" style="background-image:url('https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340');"></div>
  <div class="restaurant-info">
    <h2>구로시로 <i class="bi bi-star-fill text-warning"></i></h2>
    <div>광주 광산구 구로시로</div>
    <div class="rating">4.0 (32 리뷰)</div>
  </div>
</div>

<!-- 스크립트 -->
<script>
  // 탭 이동 + active
  document.querySelectorAll('.tab-link').forEach(link => {
    link.addEventListener('click', function(e) {
      e.preventDefault();
      document.querySelectorAll('.tab-link').forEach(l => l.classList.remove('active'));
      this.classList.add('active');
      const targetId = this.getAttribute('href');
      const target = document.querySelector(targetId);
      if (target) {
        const offsetTop = target.offsetTop - 70;
        window.scrollTo({ top: offsetTop, behavior: 'smooth' });
      }
    });
  });

  // 탭 고정
  document.addEventListener("DOMContentLoaded", () => {
    const tab = document.getElementById("restaurantTabs");
    const tabOffsetTop = tab.offsetTop;
    window.addEventListener("scroll", () => {
      if (window.scrollY >= tabOffsetTop - 60) {
        tab.classList.add("fixed");
      } else {
        tab.classList.remove("fixed");
      }
    });
  });

  // 이미지 확대
  const heroImg = document.getElementById('heroImg');
  const fullHero = document.getElementById('fullHero');
  heroImg.addEventListener('click', () => {
    fullHero.style.display = 'flex';
    document.body.style.overflow = 'hidden';
  });
  function closeHero() {
    fullHero.style.display = 'none';
    document.body.style.overflow = '';
  }
  window.addEventListener('scroll', () => {
    if (fullHero.style.display === 'flex') closeHero();
  });
</script>
</body>
</html>
