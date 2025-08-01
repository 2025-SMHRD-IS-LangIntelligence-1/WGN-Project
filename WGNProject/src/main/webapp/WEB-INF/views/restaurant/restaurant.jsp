<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/restaurant.css" />
</head>
<body>

<div class="mobile-container">
<!-- 식당 기본 정보 -->
<div class="restaurant-info">
  <h2>구로시로 <i class="bi bi-star-fill text-warning"></i></h2>
  <div>광주 광산구 구로시로</div>
  <div class="rating">4.0 (32 리뷰)</div>
</div>

<!-- 영업 정보 -->
<div class="detail-section">
  <div class="detail-row"><span><i class="bi bi-clock"></i> 영업시간</span><span>11:00 ~ 20:30</span></div>
  <div class="detail-row"><span><i class="bi bi-telephone"></i> 전화번호</span><span>062-611-4141</span></div>
  <div class="detail-row"><span><i class="bi bi-geo-alt"></i> 주소</span><span>광주 광산구</span></div>
</div>

<!-- 메뉴 -->
<div class="menu-section">
  <div class="menu-item"><span>도리파이탄</span><span>13,000원</span></div>
  <div class="menu-item"><span>쇼유라멘</span><span>12,000원</span></div>
  <div class="menu-item"><span>시오라멘</span><span>12,000원</span></div>
</div>

<!-- 평점 -->
<div class="review-score">
  <div>평균 평점: <span class="score">4.5 / 5</span></div>
  <div style="margin-top:8px; color:#888;">친절해요 👍, 맛있어요 😋</div>
</div>

<!-- 리뷰 -->
<div class="review-section">
  <h5>리뷰</h5>
  <div class="review-card">
    <div class="d-flex align-items-center">
      <div class="review-img"></div>
      <div>
        <div class="review-user">UserA</div>
        <div class="review-content">면발이 탱탱하고 국물이 끝내줘요!</div>
      </div>
    </div>
  </div>
  <div class="review-card">
    <div class="d-flex align-items-center">
      <div class="review-img"></div>
      <div>
        <div class="review-user">UserB</div>
        <div class="review-content">서비스도 좋고 가성비 최고입니다.</div>
      </div>
    </div>
  </div>
</div>
</div>

</body>
</html>