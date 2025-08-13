<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>addFeed</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet"
   href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
   href="${pageContext.request.contextPath}/resources/css/addFeed.css" />
</head>

<body>

   <%@ include file="/WEB-INF/views/common/topBar.jsp"%>

   <div class="mobile-container">
      <div class="content">
         <form action="<c:url value='/feed/upload'/>" method="post"
            enctype="multipart/form-data">
            <div class="add-box">
               <!-- 상단 닫기 및 제출 버튼 -->
               <div class="add-box-header">
                  <button class="close-btn" type="button">✕</button>
                  <button class="submit-btn" type="submit" disabled>게시하기</button>
               </div>

               <!-- 파일 업로드 영역 -->
               <div class="upload-wrapper">
                  <!-- 업로드 버튼 영역 -->
                  <div class="upload-box-container">
                     <label for="file-upload" class="upload-box"> <i
                        class="bi bi-camera"></i> <span>사진</span>
                     </label> <input type="file" name="files" id="file-upload"
                        class="file-upload" accept="image/*" hidden multiple>
                  </div>
                     <!-- 안내 문구 -->
                     <p class="upload-limit-text">최대 5장까지 업로드할 수 있습니다.</p>

                     <!-- 프리뷰 -->
                     <div id="preview-container" class="preview-container"></div>
            

                  <!-- 에러 메시지 -->
                  <span id="fileError" class="text-danger"
                     style="display: none; font-size: 13px;">사진을 선택해주세요.</span>
               </div>



               <!-- 피드 내용 입력 -->
               <textarea name="feed_content" id="feed_content" class="desc-text"
                  rows="3" placeholder="내용을 작성해주세요"></textarea>
               <span id="contentError" class="text-danger"
                  style="display: none; font-size: 13px;">내용을 입력해주세요.</span>
            </div>

            <!-- 구분선 -->
            <div class="section_divider"></div>

            <div class="rating-wrapper">
               <span class="rating-title">별점</span>
               <div class="star-input">
                  <input type="radio" id="star5" name="ratings" value="5" /> <label
                     for="star5" title="5 stars">★</label> <input type="radio"
                     id="star4" name="ratings" value="4" /> <label for="star4"
                     title="4 stars">★</label> <input type="radio" id="star3"
                     name="ratings" value="3" /> <label for="star3" title="3 stars">★</label>
                  <input type="radio" id="star2" name="ratings" value="2" /> <label
                     for="star2" title="2 stars">★</label> <input type="radio"
                     id="star1" name="ratings" value="1" /> <label for="star1"
                     title="1 star">★</label>
               </div>
            </div>

            <span id="ratingError" class="text-danger"
               style="display: none; font-size: 13px;">별점을 선택해주세요.</span>

            <!-- 랭킹 등록 -->
            <div class="favorite-wrapper">
               <span class="favorite-title"> 내 랭킹 등록하기 </span>
               <div class="favorite-input">

                  <div id="rankToggleWrapper">
                     <label class="switch-toggle"> <input type="checkbox"
                        id="rank_toggle" name="rank_toggle"> <span
                        class="slider"> <span class="label-on">ON</span> <span
                           class="label-off">OFF</span>
                     </span>
                     </label>
                  </div>

                  <span id="duplicateFavoriteMsg" class="text-danger"
                     style="display: none; font-size: 13px; margin-left: 10px;">이미
                     등록한 음식점입니다.</span>
               </div>
            </div>
      </div>
      <!-- 음식점 검색 -->
      <input type="text" class="search_input" placeholder="음식점을 입력하세요">
      <input type="hidden" name="res_idx" id="selectedResIdx"> <span
         id="resError" class="text-danger"
         style="display: none; font-size: 13px;">음식점을 선택해주세요.</span>
      <!-- 검색 결과 리스트 -->
      <div class="search-list"></div>
      </form>
   </div>
   </div>

   <!-- 게시 중 모달 -->
   <div id="postingModal" class="modal-backdrop" style="display: none;">
      <div class="modal-content">
         <span class="loader"></span>
         <p>게시 중입니다...</p>
      </div>
   </div>

   <%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>

   <!-- jQuery 및 JS 연결 -->
   <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
   <script>
      const contextPath = '${pageContext.request.contextPath}';
   </script>
   <script
      src="${pageContext.request.contextPath}/resources/js/addFeed.js"></script>

</body>
</html>
