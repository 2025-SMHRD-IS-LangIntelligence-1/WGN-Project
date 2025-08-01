<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1">
<title>Profile</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/profile.css" />
</head>
<body>
	<div class="mobile-container">
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
			<hr class="profile-divider">
			<!-- 닉네임/소개 -->
			<div class="profile-info">
				<h5>${profile.nickname}</h5>
				<p>간단한 소개글을 적을 수 있습니다.</p>
			</div>

		</div>

		<!-- 탭 -->
		<div class="profile-tabs">
			<a href="#" class="tab active" id="tab-posts">
				<i class="bi bi-grid-3x3-gap-fill"></i>
            	<span>게시글</span>
        	</a>
        	<a href="#" class="tab" id="tab-map">
           		<i class="bi bi-map"></i>
            	<span>지도</span>
        	</a>
    	</div>

		<!-- 게시글 섹션 
		<div id="posts-section">
		  <div class="container-fluid grid-feed px-0">
		    <div class="row g-1">
		      <c:forEach var="feed" items="${feedList}">
		        <div class="col-4" onclick="window.location='/feed/feed?feed_idx=${feed.feed_idx}'" style="cursor:pointer;">
		          <img src="${feed.image_url}" alt="Feed Image" style="width:100%; height:auto;" />
		        </div>
		      </c:forEach>
		    </div>
		  </div>
		</div>-->

		<!-- 기존 게시글 섹션		-->
		<div id="posts-section">
		  <div class="container-fluid grid-feed px-0">
		    <div class="row g-1">
		      <div class="col-4" onclick="window.location='/feed/feedDetail?feed_idx=1'" style="cursor:pointer;">
		        <img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340">
		      </div>
		      <div class="col-4" onclick="window.location='/feed/feedDetail?feed_idx=2'" style="cursor:pointer;">
		        <img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340">
		      </div>
		      <div class="col-4" onclick="window.location='/feed/feedDetail?feed_idx=3'" style="cursor:pointer;">
		        <img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340">
		      </div>
		    </div>
		  </div>
		</div>

		


    	<!-- 지도 섹션 (처음엔 비워둠) -->
    	<!-- 지도 섹션 -->
<div id="map-section" style="display:none;">
    <div id="map" style="width:100%;height:auto;aspect-ratio:16/9;max-height:70vh;"></div>

<!-- 지도 하단 탭 -->
<div class="ranking-tabs">
    <ul class="nav nav-tabs" id="rankingTab" role="tablist">
        <li class="nav-item" style="width:50%">
            <button class="nav-link active w-100" data-bs-toggle="tab" data-bs-target="#rank-content" type="button" role="tab">랭킹</button>
        </li>
        <li class="nav-item" style="width:50%">
            <button class="nav-link w-100" data-bs-toggle="tab" data-bs-target="#wish-content" type="button" role="tab">찜</button>
        </li>
    </ul>
    <div class="tab-content" id="rankingTabContent">
        <!-- 랭킹 탭 -->
        <div class="tab-pane fade show active p-2" id="rank-content" role="tabpanel">
            <div id="rank-list" class="list-group">

                <!-- 1위 -->
                <div class="list-group-item d-flex align-items-center">
                    <img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340" class="rounded me-2" style="width:60px;height:60px;object-fit:cover;">
                    <div class="flex-fill">
                        <h6 class="mb-0">해물짬뽕 전문점</h6>
                        <small class="text-muted">광주광역시 북구</small>
                        <div class="mt-1">
                            <span class="badge bg-warning text-dark">4.8</span>
                        </div>
                    </div>
                    <div style="font-size:24px; margin-left:8px;">🥇</div>
                </div>

                <!-- 2위 -->
                <div class="list-group-item d-flex align-items-center">
                    <img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340" class="rounded me-2" style="width:60px;height:60px;object-fit:cover;">
                    <div class="flex-fill">
                        <h6 class="mb-0">편육</h6>
                        <small class="text-muted">광주광역시 북구</small>
                        <div class="mt-1">
                            <span class="badge bg-warning text-dark">4.5</span>
                        </div>
                    </div>
                    <div style="font-size:24px; margin-left:8px;">🥈</div>
                </div>

                <!-- 3위 -->
                <div class="list-group-item d-flex align-items-center">
                    <img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340" class="rounded me-2" style="width:60px;height:60px;object-fit:cover;">
                    <div class="flex-fill">
                        <h6 class="mb-0">조개찜 전문점</h6>
                        <small class="text-muted">광주광역시 북구</small>
                        <div class="mt-1">
                            <span class="badge bg-warning text-dark">4.3</span>
                        </div>
                    </div>
                    <div style="font-size:24px; margin-left:8px;">🥉</div>
                </div>

            </div>
        </div>

        <!-- 찜 탭 -->
        <div class="tab-pane fade p-2" id="wish-content" role="tabpanel">
            <div id="wish-list" class="list-group">

                <!-- 찜 1 -->
                <div class="list-group-item d-flex align-items-center">
                    <img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340" class="rounded me-2" style="width:60px;height:60px;object-fit:cover;">
                    <div class="flex-fill">
                        <h6 class="mb-0">내가 찜한 가게 1</h6>
                        <small class="text-muted">광주 남구</small>
                    </div>
                </div>

                <!-- 찜 2 -->
                <div class="list-group-item d-flex align-items-center">
                    <img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA1MzFfMjA5%2FMDAxNzE3MTI3NTU4MzUx.jm7irFvxcJeTMEcpd18H2NsssEMboL3zLNcmfsIH4TEg.0NBM5gkIlrPUi1MAy2elTegzmnfITofOBl57mYM45d4g.PNG%2F%25C1%25A6%25B8%25F1%25C0%25BB%25A3%25AD%25C0%25D4%25B7%25C2%25C7%25D8%25C1%25D6%25BC%25BC%25BF%25E4%25A3%25DF%25A3%25AD001%25A3%25AD8.png&type=a340" class="rounded me-2" style="width:60px;height:60px;object-fit:cover;">
                    <div class="flex-fill">
                        <h6 class="mb-0">내가 찜한 가게 2</h6>
                        <small class="text-muted">광주 서구</small>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

	</div>

	<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4307aaa155e95c89c9a2cbb564db3cd3"></script>
<script>
var map = null;
var markers = []; // 지도 마커 저장
var center = new kakao.maps.LatLng(35.159545, 126.852601);

// 광주 범위
var sw = new kakao.maps.LatLng(34.9, 126.6);
var ne = new kakao.maps.LatLng(35.4, 127.2);
var bounds = new kakao.maps.LatLngBounds(sw, ne);

// 더미 데이터
var rankDummy = [
    { name: '해물짬뽕 전문점', lat: 35.17, lng: 126.85 },
    { name: '편육', lat: 35.16, lng: 126.86 },
    { name: '조개찜 전문점', lat: 35.15, lng: 126.84 }
];

var wishDummy = [
    { name: '내가 찜한 가게 1', lat: 35.18, lng: 126.83 },
    { name: '내가 찜한 가게 2', lat: 35.14, lng: 126.87 }
];

// 기존 마커 제거
function clearMarkers() {
    markers.forEach(function(marker) {
        marker.setMap(null);
    });
    markers = [];
}

// 데이터 기반으로 마커 렌더링
function renderMarkers(dataset) {
    clearMarkers();
    dataset.forEach(function(item) {
        var position = new kakao.maps.LatLng(item.lat, item.lng);
        var marker = new kakao.maps.Marker({
            position: position,
            title: item.name
        });
        marker.setMap(map);
        markers.push(marker);
    });
}

$(function() {
    // 게시글 탭
    $('#tab-posts').on('click', function(e) {
        e.preventDefault();
        $(this).addClass('active');
        $('#tab-map').removeClass('active');
        $('#posts-section').show();
        $('#map-section').hide();
    });

    // 지도 탭
    $('#tab-map').on('click', function(e) {
        e.preventDefault();
        $(this).addClass('active');
        $('#tab-posts').removeClass('active');
        $('#posts-section').hide();
        $('#map-section').show();
        
        setTimeout(function () {
            if (!map) {
                var container = document.getElementById('map');
                var options = {
                    center: center,
                    level: 9
                };
                map = new kakao.maps.Map(container, options);

                // 지도 드래그 제한 (광주 범위)
                kakao.maps.event.addListener(map, 'dragend', function () {
                    if (!bounds.contain(map.getCenter())) {
                        map.setCenter(center);
                    }
                });

                // 확대 제한
                kakao.maps.event.addListener(map, 'zoom_changed', function() {
                    var currentLevel = map.getLevel();
                    var maxLevel = 9;
                    if (currentLevel > maxLevel) {
                        map.setLevel(maxLevel);
                    }
                    map.setCenter(center);
                });

                // 초기 마커: 랭킹 데이터
                renderMarkers(rankDummy);

                // 랭킹 탭 클릭 시
                document.querySelector('button[data-bs-target="#rank-content"]').addEventListener('click', function() {
                    renderMarkers(rankDummy);
                });

                // 찜 탭 클릭 시
                document.querySelector('button[data-bs-target="#wish-content"]').addEventListener('click', function() {
                    renderMarkers(wishDummy);
                });
            }
            
            map.relayout();
            map.setCenter(center);
            
        }, 300);
    });
    
    // 화면 리사이즈 시 지도 중심 보정
    $(window).on('resize', function() {
        if (map && $('#map-section').is(':visible')) {
            map.relayout();
            map.setCenter(center);
        }
    });
});
</script>
<!-- jQuery -->


<!-- Bootstrap JS (bundle) 추가 -->


</body>
</html>
