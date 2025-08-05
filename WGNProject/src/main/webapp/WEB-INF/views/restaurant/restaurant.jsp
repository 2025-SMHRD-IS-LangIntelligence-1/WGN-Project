<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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


<!-- 이미지 영역 -->
<div class="image-grid">
  <div class="main-image" style="background-image: url('${res_main_img.res_img_url}');" data-url="${res_main_img.res_img_url}"></div>
  <div class="sub-images">
    <c:forEach var="img" items="${res_sub_img_list}" varStatus="status">
      <div class="sub-image" style="background-image: url('${img.res_img_url}');" data-url="${img.res_img_url}"></div>
    </c:forEach>
  </div>
</div>

<!-- 기본 정보 -->
<div class="restaurant-info">
  <h2>${res.res_name } <i class="bi bi-star-fill text-warning"></i></h2>
  <div>${res.res_addr }</div>
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
</div>

<!-- 리뷰 -->
<div class="card-section" id="review-section">
  <h5 class="section-title">리뷰</h5>
  <div class="mt-3 text-center">
    <img src="${pageContext.request.contextPath}/resources/img/wordcloud_sample.png" alt="워드 클라우드" class="img-fluid" style="max-width: 100%; border-radius: 10px;">
  </div>
  <div class="review-card d-flex align-items-center">
    <div class="review-img"></div>
    <div><div class="review-user">UserA</div><div class="review-content">면발이 탱탱하고 국물이 끝내줘요!</div></div>
  </div>
  <div class="review-card d-flex align-items-center">
    <div class="review-img"></div>
    <div><div class="review-user">UserB</div><div class="review-content">서비스도 좋고 가성비 최고입니다.</div></div>
  </div>
</div>

<!-- 모달 전체 화면 이미지 뷰어 -->
<div id="imageModal" class="full-hero">
  <button class="close-btn" onclick="closeModal()">×</button>
  <button class="nav-btn prev" onclick="prevImage()">‹</button>
  <img id="modalImageTag" class="full-hero-img" src="" alt="확대 이미지" />
  <button class="nav-btn next" onclick="nextImage()">›</button>
</div>


  <%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
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


  
  //이미지
  
const images = [];
let currentIndex = 0;

// DOM 로드 후 이미지 수집 및 클릭 이벤트 연결
document.addEventListener('DOMContentLoaded', () => {
  const main = document.querySelector('.main-image');
  const thumbs = document.querySelectorAll('.sub-image');

  // 이미지 URL 추출 함수
  function extractUrl(el) {
    const bg = getComputedStyle(el).backgroundImage;
    const match = bg.match(/url\("?(.+?)"?\)/);
    return match ? match[1] : '';
  }

  // 이미지 배열에 push
  if (main) {
    const url = extractUrl(main);
    images.push(url);
    console.log("✅ 메인 이미지 URL:", url);
  }

  thumbs.forEach((thumb, i) => {
    const url = extractUrl(thumb);
    images.push(url);
    console.log(`✅ 썸네일 ${i + 1} URL:`, url);
  });

  // 이미지 클릭 이벤트 등록
  document.querySelectorAll('.main-image, .sub-image').forEach((img, idx) => {
    img.addEventListener('click', () => openModal(idx));
  });

  // 스와이프 설정
  setupTouchEvents();
});

// 모달 열기
function openModal(index) {
  currentIndex = index;
  console.log("🔍 openModal 호출됨 - index:", index, "| 이미지 URL:", images[currentIndex]);
  updateModalImage();
  document.getElementById('imageModal').style.display = 'flex';
  document.body.style.overflow = 'hidden';
}

// 모달 닫기
function closeModal() {
  console.log("🧹 모달 닫기");
  document.getElementById('imageModal').style.display = 'none';
  document.body.style.overflow = '';
}

// 이미지 업데이트
function updateModalImage() {
  const imgEl = document.getElementById('modalImageTag');
  const currentUrl = images[currentIndex];
  imgEl.src = currentUrl;
  console.log("🖼️ 모달 이미지 업데이트 - index:", currentIndex, "| URL:", currentUrl);

  document.querySelector('.nav-btn.prev').disabled = currentIndex === 0;
  document.querySelector('.nav-btn.next').disabled = currentIndex === images.length - 1;
}

// 이전 이미지
function prevImage() {
  if (currentIndex > 0) {
    currentIndex--;
    console.log("◀ 이전 이미지로 - index:", currentIndex);
    updateModalImage();
  }
}

// 다음 이미지
function nextImage() {
  if (currentIndex < images.length - 1) {
    currentIndex++;
    console.log("▶ 다음 이미지로 - index:", currentIndex);
    updateModalImage();
  }
}

// 모바일 터치 스와이프
function setupTouchEvents() {
  const modal = document.getElementById('modalImage');
  let startX = 0;
  let endX = 0;

  modal.addEventListener('touchstart', e => {
    startX = e.touches[0].clientX;
  });

  modal.addEventListener('touchend', e => {
    endX = e.changedTouches[0].clientX;
    handleSwipe();
  });

  function handleSwipe() {
    const diff = endX - startX;
    if (Math.abs(diff) > 50) {
      if (diff > 0) {
        prevImage();
      } else {
        nextImage();
      }
    }
  }
}

</script>
</body>
</html>
