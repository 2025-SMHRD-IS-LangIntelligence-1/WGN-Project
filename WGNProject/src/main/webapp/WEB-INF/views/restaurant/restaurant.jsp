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
  <h5 class="section-title d-flex justify-content-between align-items-center">
    정보
    <i class="bi bi-chevron-down" id="toggleArrow" style="cursor: pointer;"></i>
  </h5>

  <!-- 오늘 요일만 표시 -->
  <div id="todaySchedule">
    <c:forEach var="time" items="${res_time}">
      <c:if test="${fn:contains(time.weekday, todayKor)}">
        <div class="review-card d-flex justify-content-between border-0">
          <span><i class="bi bi-clock"></i> 영업시간</span>
          <span>${time.weekday}</span>
        </div>

        <c:if test="${not empty time.last_time}">
          <div class="review-card border-0 text-end">
            <span class="sub-info">${time.last_time}</span>
          </div>
        </c:if>

        <c:if test="${not empty time.break_time}">
          <div class="review-card border-0 text-end">
            <span class="sub-info">${time.break_time}</span>
          </div>
        </c:if>
      </c:if>
    </c:forEach>
  </div>

  <!-- 전체 요일 영업시간 (초기엔 숨김) -->
  <div id="fullSchedule" style="display: none;">
    <c:forEach var="time" items="${res_time}">
      <div class="review-card d-flex justify-content-between">
        <span>영업시간</span>
        <span>${time.weekday}</span>
      </div>

      <c:if test="${not empty time.last_time}">
        <div class="review-card border-0 text-end">
          <span class="sub-info">${time.last_time}</span>
        </div>
      </c:if>

      <c:if test="${not empty time.break_time}">
        <div class="review-card border-0 text-end">
          <span class="sub-info">${time.break_time}</span>
        </div>
      </c:if>
    </c:forEach>
  </div>
  
  <div class="review-card d-flex justify-content-between"><span><i class="bi bi-telephone"></i> 전화번호</span><span>${res.res_tel}</span></div>
  <div class="review-card d-flex justify-content-between"><span><i class="bi bi-geo-alt"></i> 주소</span><span>${res.res_addr }</span></div>



</div>

<!-- 메뉴 섹션 -->
<!-- 메뉴 섹션 -->
<div class="card-section" id="menu-section">
  <h5 class="section-title">메뉴</h5>

  <c:forEach var="menu" items="${res_menu}">
    <div class="review-card d-flex justify-content-between">
      <span>${menu.menu_name}</span>
      <span>${menu.menu_price}</span>
    </div>
  </c:forEach>
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

  <!-- 리뷰 탭 메뉴 -->
  <div class="review-tab-buttons d-flex mb-3">
    <button class="review-tab active" data-target="user-reviews">사용자 리뷰</button>
    <button class="review-tab" data-target="other-reviews">타사이트 리뷰</button>
  </div>

<!-- 사용자 리뷰 -->
<div id="user-reviews" class="review-tab-content">
  <c:forEach var="review" items="${res_review}">
    <c:if test="${!fn:startsWith(review.mb_id, 'naver') and !fn:startsWith(review.mb_id, 'kakao')}">
      <div class="review-card d-flex align-items-center">
        <div class="review-img"></div>
        <div>
          <div class="review-user">${review.mb_id}</div>
          <div class="review-content">${review.review_content}</div>
        </div>
      </div>
    </c:if>
  </c:forEach>
</div>

<!-- 타사이트 리뷰 -->
<!-- 타사이트 리뷰 -->
<div id="other-reviews" class="review-tab-content" style="display: none;">

  <!-- 네이버 리뷰 -->
  <div id="naver-reviews-wrapper">
    <c:set var="naverCount" value="0" />
    <c:forEach var="review" items="${res_review}">
      <c:if test="${fn:startsWith(review.mb_id, 'naver')}">
        <c:choose>
          <c:when test="${naverCount < 3}">
            <div class="review-card d-flex align-items-center naver-review">
          </c:when>
          <c:otherwise>
            <div class="review-card d-flex align-items-center naver-review d-none">
          </c:otherwise>
        </c:choose>
            <div class="review-img">
              <img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxNzA4MTBfMjkg%2FMDAxNTAyMzQ1NjgxMTcx.HN5OduMJB4wLP2Ryov53lcBW-UhIkXLXZdd_SRReFAgg.mL_h394FDyN7gsATSeFOYSoDYWMPnuLPSfcLkquAIdMg.PNG.baroniter%2Fnaver_pay_img_04.png&type=a340">
            </div>
            <div>
              <div class="review-user">네이버 리뷰</div>
              <div class="review-content">${review.review_content}</div>
            </div>
          </div>
        <c:set var="naverCount" value="${naverCount + 1}" />
      </c:if>
    </c:forEach>
    <div class="text-end mt-2">
      <button id="toggle-naver" class="btn btn-sm" style="color: #FFC107;">네이버 리뷰 더보기</button>
    </div>
  </div>

  <!-- 카카오 리뷰 -->
  <div id="kakao-reviews-wrapper" class="mt-4">
    <c:set var="kakaoCount" value="0" />
    <c:forEach var="review" items="${res_review}">
      <c:if test="${fn:startsWith(review.mb_id, 'kakao')}">
        <c:choose>
          <c:when test="${kakaoCount < 3}">
            <div class="review-card d-flex align-items-center kakao-review">
          </c:when>
          <c:otherwise>
            <div class="review-card d-flex align-items-center kakao-review d-none">
          </c:otherwise>
        </c:choose>
            <div class="review-img">
              <img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2F20150501_131%2Fk2pluie_1430465036248TzXj6_JPEG%2F%25C4%25AB%25C4%25AB%25BF%25C0%25C5%25E5_%25C4%25AB%25C4%25AB%25BF%25C0%25BD%25BA%25C5%25E4%25B8%25AE_%25B7%25CE%25B0%25ED3.jpeg&type=a340">
            </div>
            <div>
              <div class="review-user">카카오 리뷰</div>
              <div class="review-content">${review.review_content}</div>
            </div>
          </div>
        <c:set var="kakaoCount" value="${kakaoCount + 1}" />
      </c:if>
    </c:forEach>
    <div class="text-end mt-2">
      <button id="toggle-kakao" class="btn btn-sm" style="color: #FFC107;">카카오 리뷰 더보기</button>
    </div>
  </div>
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
  console.log("openModal 호출됨 - index:", index, "| 이미지 URL:", images[currentIndex]);
  updateModalImage();
  document.getElementById('imageModal').style.display = 'flex';
  document.body.style.overflow = 'hidden';
}

// 모달 닫기
function closeModal() {
  console.log("모달 닫기");
  document.getElementById('imageModal').style.display = 'none';
  document.body.style.overflow = '';
}

// 이미지 업데이트
function updateModalImage() {
  const imgEl = document.getElementById('modalImageTag');
  const currentUrl = images[currentIndex];
  imgEl.src = currentUrl;
  console.log("모달 이미지 업데이트 - index:", currentIndex, "| URL:", currentUrl);

  document.querySelector('.nav-btn.prev').disabled = currentIndex === 0;
  document.querySelector('.nav-btn.next').disabled = currentIndex === images.length - 1;
}

// 이전 이미지
function prevImage() {
  if (currentIndex > 0) {
    currentIndex--;
    console.log("이전 이미지로 - index:", currentIndex);
    updateModalImage();
  }
}

// 다음 이미지
function nextImage() {
  if (currentIndex < images.length - 1) {
    currentIndex++;
    console.log("다음 이미지로 - index:", currentIndex);
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
const arrow = document.getElementById('toggleArrow');
const fullBox = document.getElementById('fullSchedule');
const todayBox = document.getElementById('todaySchedule');
let isOpen = false;

arrow.addEventListener('click', () => {
  isOpen = !isOpen;
  fullBox.style.display = isOpen ? 'block' : 'none';
  todayBox.style.display = isOpen ? 'none' : 'block';

  arrow.classList.toggle('bi-chevron-down');
  arrow.classList.toggle('bi-chevron-up');
});

// 리뷰탭
document.querySelectorAll(".review-tab").forEach(button => {
	  button.addEventListener("click", () => {
	    // 탭 활성화 토글
	    document.querySelectorAll(".review-tab").forEach(btn => btn.classList.remove("active"));
	    button.classList.add("active");

	    // 컨텐츠 보이기 토글
	    const targetId = button.getAttribute("data-target");
	    document.querySelectorAll(".review-tab-content").forEach(content => {
	      content.style.display = "none";
	    });
	    document.getElementById(targetId).style.display = "block";
	  });
	});

// 카카오 네이버 더보기
document.addEventListener('DOMContentLoaded', function () {
  const toggleNaverBtn = document.getElementById('toggle-naver');
  const toggleKakaoBtn = document.getElementById('toggle-kakao');

  let naverExpanded = false;
  let kakaoExpanded = false;

  toggleNaverBtn.addEventListener('click', function () {
    const hiddenEls = document.querySelectorAll('.naver-review');
    naverExpanded = !naverExpanded;

    hiddenEls.forEach((el, idx) => {
      if (idx >= 3) {
        el.classList.toggle('d-none', !naverExpanded);
      }
    });

    this.textContent = naverExpanded ? '네이버 리뷰 접기' : '네이버 리뷰 더보기';
  });

  toggleKakaoBtn.addEventListener('click', function () {
    const hiddenEls = document.querySelectorAll('.kakao-review');
    kakaoExpanded = !kakaoExpanded;

    hiddenEls.forEach((el, idx) => {
      if (idx >= 3) {
        el.classList.toggle('d-none', !kakaoExpanded);
      }
    });

    this.textContent = kakaoExpanded ? '카카오 리뷰 접기' : '카카오 리뷰 더보기';
  });
});
</script>
</body>
</html>
