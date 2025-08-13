<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1">
<title>Restaurant</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/restaurant.css" />
</head>
<body>
	<div class="mobile-container">
		<%@ include file="/WEB-INF/views/common/topBar.jsp"%>


		<!-- 이미지 영역 -->
		<div class="image-grid">
			<div class="main-image"
				style="background-image: url('${res_main_img.res_img_url}');"
				data-url="${res_main_img.res_img_url}"></div>
			<div class="sub-images">
				<c:forEach var="img" items="${res_sub_img_list}" varStatus="status">
					<div class="sub-image"
						style="background-image: url('${img.res_img_url}');"
						data-url="${img.res_img_url}"></div>
				</c:forEach>
			</div>
		</div>

		<!-- 기본 정보 -->
		<div class="restaurant-info">
			<h2 class="d-flex align-items-center">
				${res.res_name}

				<!-- 아이콘 + 말풍선 묶음 -->
				<span id="restaurantIconGroup"
					class="ms-2 d-inline-flex align-items-center gap-1 position-relative"
					style="cursor: pointer;" data-res-idx="${res.res_idx}"
					data-mb-id="${sessionScope.member.mb_id}">
					<div id="goingIconGroup" class="icon-outline-group">
						<i class="bi bi-person-walking icon-outline"></i> <i
							class="fas fa-store icon-outline"></i>
					</div>

					<div id="iconTooltip" class="icon-tooltip-inline"
						style="display: none;">
						이모티콘 클릭 시 찜 등록!
						<button class="close-tooltip">&times;</button>
					</div>
				</span>
			</h2>

			<div>${res.res_addr}</div>
			<div class="rating text-warning fw-bold">4.0 (32 리뷰)</div>
		</div>

		<!-- 탭 -->
		<div class="restaurant-tabs-wrapper">
			<div class="restaurant-tabs" id="restaurantTabs">
				<a href="#info-section" class="tab-link active">정보</a> <a
					href="#menu-section" class="tab-link">메뉴</a> <a
					href="#rating-section" class="tab-link">평점</a> <a
					href="#review-section" class="tab-link">리뷰</a>
			</div>
		</div>

		<c:set var="timeCount" value="${fn:length(res_time)}" />
		<div class="card-section" id="info-section">
			<div class="card-section" id="real-info-section">
				<h5 class="section-title">정보</h5>

				<!-- 오늘 요일 표시 -->
				<div id="todaySchedule">


					<c:if test="${not empty singleTime}">
						<div
							class="review-card d-flex justify-content-between border-0 align-items-center">
							<span><i class="bi bi-clock"></i> 영업시간</span> <span
								class="d-flex align-items-center">${singleTime.weekday}</span>
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
						<div
							class="review-card d-flex justify-content-between border-0 align-items-center">
							<span><i class="bi bi-clock"></i> 영업시간</span> <span
								class="d-flex align-items-center"> ${time.weekday} <i
								class="bi bi-chevron-down ms-2" id="toggleArrow"
								style="cursor: pointer;"></i>
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
					<div id="fullSchedule" style="display: none;">
						<c:forEach var="time" items="${otherTimes}">
							<div class="review-card d-flex justify-content-between">
								<span>영업시간</span> <span>${time.weekday}</span>
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
				</div>
				<div class="review-card d-flex justify-content-between">
					<span><i class="bi bi-telephone"></i> 전화번호</span><span>${res.res_tel}</span>
				</div>

				<!-- 주소 -->
				<div
					class="review-card d-flex justify-content-between align-items-center border-0">
					<span><i class="bi bi-geo-alt"></i> 주소</span> <span>${res.res_addr}</span>
				</div>

				<!-- 지도 보기 버튼 -->
				<div class="text-end mt-2">
					<button class="btn btn-sm toggle-map-btn" onclick="toggleMap()"
						id="mapToggleBtn">지도 보기</button>
				</div>

				<!-- 지도 영역 -->
				<div id="map-section" style="display: none;">
					<div id="map" style="width: 100%; height: 400px; margin-top: 10px;"></div>
				</div>
			</div>
			<!-- 메뉴 섹션 -->

			<div class="card-section" id="menu-section">
				<h5 class="section-title">메뉴</h5>

				<c:forEach var="menu" items="${res_menu}">
					<div class="review-card d-flex justify-content-between">
						<span>${menu.menu_name}</span> <span>${menu.menu_price}</span>
					</div>
				</c:forEach>
			</div>

			<!-- 평점 -->
			<div class="card-section" id="rating-section">
				<h5 class="section-title">평점</h5>
				<div
					class="review-card d-flex justify-content-between align-items-center">
					<span>와구냠 평점</span> <span style="color: orange; font-size: 18px;">
						${data.wgn_ratings} &nbsp; <c:choose>
							<c:when test="${data.wgn_ratings >= 5}">★★★★★</c:when>
							<c:when test="${data.wgn_ratings >= 4}">★★★★☆</c:when>
							<c:when test="${data.wgn_ratings >= 3}">★★★☆☆</c:when>
							<c:when test="${data.wgn_ratings >= 2}">★★☆☆☆</c:when>
							<c:when test="${data.wgn_ratings >= 1}">★☆☆☆☆</c:when>
							<c:otherwise>☆☆☆☆☆</c:otherwise>
						</c:choose>
					</span>
				</div>
				<div
					class="review-card d-flex justify-content-between align-items-center">
					<span>플랫폼 평점</span> <span style="color: green; font-size: 18px;">
						${data.res_ratings} &nbsp; <c:choose>
							<c:when test="${data.res_ratings >= 5}">★★★★★</c:when>
							<c:when test="${data.res_ratings >= 4}">★★★★☆</c:when>
							<c:when test="${data.res_ratings >= 3}">★★★☆☆</c:when>
							<c:when test="${data.res_ratings >= 2}">★★☆☆☆</c:when>
							<c:when test="${data.res_ratings >= 1}">★☆☆☆☆</c:when>
							<c:otherwise>☆☆☆☆☆</c:otherwise>
						</c:choose>
					</span>
				</div>
			</div>

			<!-- 워드클라우드 -->
			<div class="container mt-4">
				<!-- 탭 버튼 -->
				<ul class="nav nav-tabs" id="ratingTab" role="tablist">
					<li class="nav-item" role="presentation">
						<button class="nav-link active" id="wgn-tab" data-bs-toggle="tab"
							data-bs-target="#wgn" type="button" role="tab"
							aria-controls="wgn" aria-selected="true">와구냠 키워드</button>
					</li>
					<li class="nav-item" role="presentation">
						<button class="nav-link" id="platform-tab" data-bs-toggle="tab"
							data-bs-target="#platform" type="button" role="tab"
							aria-controls="platform" aria-selected="false">플랫폼 키워드</button>
					</li>
				</ul>

				<!-- 탭 컨텐츠 -->
				<div class="tab-content p-3 border border-top-0"
					id="ratingTabContent">

					<!-- 와구냠 탭 -->
					<div class="tab-pane fade show active" id="wgn" role="tabpanel"
						aria-labelledby="wgn-tab">

						<div class="wordcloud-row">
							<div>
								<h5>긍정적인 리뷰 키워드</h5>
								<c:choose>
									<c:when test="${not empty data.wgn_positive_wc}">
										<img src="data:image/png;base64,${data.wgn_positive_wc}"
											alt="와구냠 긍정 워드클라우드" class="img-fluid" />
									</c:when>
									<c:otherwise>
										<p>아직 키워드가 없습니다.</p>
									</c:otherwise>
								</c:choose>
							</div>

							<div>
								<h5>부정적인 리뷰 키워드</h5>
								<c:choose>
									<c:when test="${not empty data.wgn_negative_wc}">
										<img src="data:image/png;base64,${data.wgn_negative_wc}"
											alt="와구냠 부정 워드클라우드" class="img-fluid" />
									</c:when>
									<c:otherwise>
										<p>아직 키워드가 없습니다.</p>
									</c:otherwise>
								</c:choose>
							</div>
						</div>

					</div>

					<!-- 플랫폼 탭 -->
					<div class="tab-pane fade" id="platform" role="tabpanel"
						aria-labelledby="platform-tab">

						<div class="wordcloud-row">
							<div>
								<h5>긍정적인 리뷰 키워드</h5>
								<c:choose>
									<c:when test="${not empty data.nk_positive_wc}">
										<img src="data:image/png;base64,${data.nk_positive_wc}"
											alt="플랫폼 긍정 워드클라우드" class="img-fluid" />
									</c:when>
									<c:otherwise>
										<p>아직 키워드가 없습니다.</p>
									</c:otherwise>
								</c:choose>
							</div>

							<div>
								<h5>부정적인 리뷰 키워드</h5>
								<c:choose>
									<c:when test="${not empty data.nk_negative_wc}">
										<img src="data:image/png;base64,${data.nk_negative_wc}"
											alt="플랫폼 부정 워드클라우드" class="img-fluid" />
									</c:when>
									<c:otherwise>
										<p>아직 키워드가 없습니다.</p>
									</c:otherwise>
								</c:choose>
							</div>
						</div>

					</div>

				</div>
			</div>


			<!-- 리뷰 -->
			<div class="card-section" id="review-section">
				<h5 class="section-title mb-2">리뷰</h5>

				<c:choose>
					<c:when test="${not empty sessionScope.member.mb_id}">
						<!-- 리뷰 탭 메뉴 -->
						<div class="review-tab-buttons d-flex mb-3">
							<button class="review-tab active" data-target="user-reviews">사용자
								리뷰</button>
							<button class="review-tab" data-target="other-reviews">타사이트
								리뷰</button>
						</div>

						<!-- 사용자 리뷰 탭 내용 -->
						<div id="user-reviews" class="review-tab-content">
							<!-- 사용자 리뷰 상단 : 작성 버튼 -->
							<div
								class="d-flex justify-content-between align-items-center mb-2">
								<strong>사용자 리뷰</strong>
								<button id="toggleReviewBtn">리뷰 작성</button>
							</div>

							<!-- 리뷰 작성 폼 -->
							<div id="reviewFormContainer" style="display: none;" class="mb-4">
								<form id="reviewForm"
									action="${pageContext.request.contextPath}/restaurant/insertReview?res_idx=${res.res_idx}"
									method="post" enctype="multipart/form-data">

									<!-- 별점 -->
									<div class="mb-2" style="margin: 5px">
										<div class="favorite-wrapper">
											<span class="favorite-title"> 별점 </span>
											<div id="ratingForm" style="font-size: 24px;">
												<input type="radio" id="star5" name="ratings" value="5"><label
													for="star5">★</label> <input type="radio" id="star4"
													name="ratings" value="4"><label for="star4">★</label>
												<input type="radio" id="star3" name="ratings" value="3"><label
													for="star3">★</label> <input type="radio" id="star2"
													name="ratings" value="2"><label for="star2">★</label>
												<input type="radio" id="star1" name="ratings" value="1"><label
													for="star1">★</label>
											</div>
										</div>
										<span id="ratingError" class="text-danger"
											style="font-size: 13px; display: none;">별점을 선택해주세요.</span>
										<div class="favorite-wrapper" style="margin: 10px 0px">
											<span class="favorite-title"> 내 랭킹 등록하기 </span>
											<div class="favorite-input">

												<div id="rankToggleWrapper">
													<label class="switch-toggle"> <input
														type="checkbox" id="rank_toggle" name="rank_toggle">
														<span class="slider"> <span class="label-on">ON</span>
															<span class="label-off">OFF</span>
													</span>
													</label>
												</div>

												<span id="duplicateFavoriteMsg" class="text-danger"
													style="display: none; font-size: 13px; margin-left: 10px;">이미
													등록한 음식점입니다.</span>
											</div>
										</div>

									</div>

									<!-- 리뷰 내용 -->
									<div class="mb-2">
										<textarea name="review_content" id="reviewContent"
											class="form-control" rows="3" maxlength="300"
											placeholder="리뷰를 작성해주세요. (최대 300자)"></textarea>
										<span id="contentError" class="text-danger"
											style="font-size: 13px; display: none;">리뷰 내용을 작성해주세요.</span>
									</div>

									<!-- 이미지 -->
									<label
										style="font-size: 15px; color: #333; margin-right: 10px; white-space: nowrap; font-weight: bold;"
										class="mb-2">이미지 첨부</label> <input type="file"
										name="review_file" class="form-control mb-2" accept="image/*">

									<!-- 버튼 -->
									<div class="text-end">
										<button type="submit" id="toggleReviewBtn">리뷰 등록</button>
									</div>
								</form>
							</div>

							<!-- 사용자 리뷰 리스트 -->
							<c:set var="userCount" value="0" />
							<c:forEach var="review" items="${res_review}">
								<c:if
									test="${!fn:startsWith(review.mb_id, 'naver') and !fn:startsWith(review.mb_id, 'kakao')}">
									<c:choose>
										<c:when test="${userCount < 3}">
											<div class="review-card d-flex align-items-start user-review">
										</c:when>
										<c:otherwise>
											<div
												class="review-card d-flex align-items-start user-review d-none">
										</c:otherwise>
									</c:choose>
									<div class="review-img me-2">
										<img src="${review.mb_img}" class="rounded-circle" width="40"
											height="40" />
									</div>
									<div style="flex-grow: 1;">
										<div
											class="d-flex justify-content-between align-items-center mb-1">
											<div class="review-user">${review.mb_nick}</div>
											<div style="color: #FFC107; font-size: 14px;">★
												${review.ratings}</div>
										</div>
										<div class="review-content">${review.review_content}</div>
										<c:if test="${not empty review.img_link}">
											<div class="mt-2">
												<img src="${review.img_link}"
													style="width: 80px; height: 80px; object-fit: cover; border-radius: 6px; cursor: pointer;"
													onclick="openImageModal('${review.img_link}')" />
											</div>
										</c:if>
									</div>
						</div>
						<c:set var="userCount" value="${userCount + 1}" />
						</c:if>
						</c:forEach>

						<c:if test="${userCount > 3}">
							<div class="text-end mt-2">
								<button id="toggle-user" class="btn btn-sm"
									style="color: #FFC107;">사용자 리뷰 더보기</button>
							</div>
						</c:if>
			</div>

			<!-- 타사이트 리뷰 탭 내용 -->
			<div id="other-reviews" class="review-tab-content"
				style="display: none;">
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
									<div
										class="review-card d-flex align-items-center naver-review d-none">
								</c:otherwise>
							</c:choose>
							<div class="review-img">
								<img
									src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxNzA4MTBfMjkg%2FMDAxNTAyMzQ1NjgxMTcx.HN5OduMJB4wLP2Ryov53lcBW-UhIkXLXZdd_SRReFAgg.mL_h394FDyN7gsATSeFOYSoDYWMPnuLPSfcLkquAIdMg.PNG.baroniter%2Fnaver_pay_img_04.png&type=a340">
							</div>
							<div>
								<div class="review-user">네이버 리뷰</div>
								<div class="review-content">${review.review_content}</div>
							</div>
				</div>
				<c:set var="naverCount" value="${naverCount + 1}" />
				</c:if>
				</c:forEach>
				<c:if test="${naverCount > 3}">
					<div class="text-end mt-2">
						<button id="toggle-naver" class="btn btn-sm"
							style="color: #FFC107;">네이버 리뷰 더보기</button>
					</div>
				</c:if>
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
								<div
									class="review-card d-flex align-items-center kakao-review d-none">
							</c:otherwise>
						</c:choose>
						<div class="review-img">
							<img
								src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2F20150501_131%2Fk2pluie_1430465036248TzXj6_JPEG%2F%25C4%25AB%25C4%25AB%25BF%25C0%25C5%25E5_%25C4%25AB%25C4%25AB%25BF%25C0%25BD%25BA%25C5%25E4%25B8%25AE_%25B7%25CE%25B0%25ED3.jpeg&type=a340">
						</div>
						<div>
							<div class="review-user">카카오 리뷰</div>
							<div class="review-content">${review.review_content}</div>
						</div>
			</div>
			<c:set var="kakaoCount" value="${kakaoCount + 1}" />
			</c:if>
			</c:forEach>
			<c:if test="${kakaoCount > 3}">
				<div class="text-end mt-2">
					<button id="toggle-kakao" class="btn btn-sm"
						style="color: #FFC107;">카카오 리뷰 더보기</button>
				</div>
			</c:if>
		</div>
	</div>
	</c:when>
	<c:otherwise>
		<div class="text-center py-4">
			<p class="text-muted mb-2">리뷰를 보시려면 로그인이 필요합니다.</p>
			<a href="${pageContext.request.contextPath}/member/login"
				class="btn btn-warning btn-sm">로그인 하러 가기</a>
		</div>
	</c:otherwise>
	</c:choose>
	</div>



	<!-- 모달 전체 화면 이미지 뷰어 -->
	<div id="imageModal" class="modal"
		style="display: none; position: fixed; z-index: 9998; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, .8); justify-content: center; align-items: center;">
		<!-- 이전/다음/닫기 버튼 -->
		<button type="button" id="galleryPrev" class="nav-btn prev"
			style="position: absolute; left: 14px; top: 50%; transform: translateY(-50%); border: none; background: transparent; font-size: 42px; color: #fff; cursor: pointer;">‹</button>
		<img id="modalImageTag"
			style="max-width: 90%; max-height: 90%; border-radius: 10px;" />
		<button type="button" id="galleryNext" class="nav-btn next"
			style="position: absolute; right: 14px; top: 50%; transform: translateY(-50%); border: none; background: transparent; font-size: 42px; color: #fff; cursor: pointer;">›</button>
		<button type="button" id="galleryClose"
			style="position: absolute; top: 20px; right: 30px; border: none; background: none; font-size: 32px; color: #fff; cursor: pointer;">×</button>
	</div>

	<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>

	<!-- 스크립트 -->

	<script>
		var reslat = "${res.lat}";
		var reslon = "${res.lon}";
		let res_idx = "${res.res_idx}";
		console.log(res_idx);
		let mb_id = "${sessionScope.member.mb_id}";
	</script>
	<script
		src="${pageContext.request.contextPath}/resources/js/restaurant.js">
		
	</script>
	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4307aaa155e95c89c9a2cbb564db3cd3"></script>

</body>
</html>
