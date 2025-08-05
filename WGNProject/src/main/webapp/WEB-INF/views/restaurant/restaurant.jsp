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

<c:set var="timeCount" value="${fn:length(res_time)}" />

<div class="card-section" id="info-section">
  <h5 class="section-title">정보</h5>

  <!-- 오늘 요일 표시 -->
  <div id="todaySchedule">

    
<c:if test="${not empty singleTime}">
  <div class="review-card d-flex justify-content-between border-0 align-items-center">
    <span><i class="bi bi-clock"></i> 영업시간</span>
    <span class="d-flex align-items-center">${singleTime.weekday}</span>
  </div>
  <c:if test="${not empty singleTime.last_time}">
    <div class="review-card border-0 text-end">
      <span class="sub-info">${singleTime.last_time}</span>
    </div>
  </c:if>
  <c:if test="${not empty singleTime.break_time}">
    <div class="review-card border-0 text-end">
      <span class="sub-info">${singleTime.break_time}</span>
    </div>
  </c:if>
</c:if>

<!-- 2. 오늘 요일 포함된 항목 -->
<c:forEach var="time" items="${todayTimes}">
  <div class="review-card d-flex justify-content-between border-0 align-items-center">
    <span><i class="bi bi-clock"></i> 영업시간</span>
    <span class="d-flex align-items-center">
      ${time.weekday}
      <i class="bi bi-chevron-down ms-2" id="toggleArrow" style="cursor: pointer;"></i>
    </span>
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

<!-- 3. 나머지 전체 요일 (접기용) -->
<div id="fullSchedule" style="display:none;">
  <c:forEach var="time" items="${otherTimes}">
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
<script
		src="${pageContext.request.contextPath}/resources/js/restaurant.js">
</script>

</body>
</html>
