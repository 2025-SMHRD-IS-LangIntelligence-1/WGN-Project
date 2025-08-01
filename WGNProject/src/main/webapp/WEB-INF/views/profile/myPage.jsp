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

		<!-- 게시글 섹션 -->
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
		</div>

		<!-- 기존 게시글 섹션
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
		-->
		


    	<!-- 지도 섹션 (처음엔 비워둠) -->
    	<div id="map-section" style="display:none;">
        	<div id="map" style="  width: 100%;height: auto;
  			aspect-ratio: 16/9;max-height: 70vh;"></div>
    	</div>

	</div>

	<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4307aaa155e95c89c9a2cbb564db3cd3"></script>
<script>
var map = null;
var mapInitialized = false;

$(function() {
    $('#tab-posts').on('click', function(e) {
        e.preventDefault();
        $(this).addClass('active');
        $('#tab-map').removeClass('active');
        $('#posts-section').show();
        $('#map-section').hide();
    });

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
                    center: new kakao.maps.LatLng(35.159545, 126.852601),
                    level: 8
                };
                map = new kakao.maps.Map(container, options);

                // 마커 추가


                map.setZoomable(false);
                map.setDraggable(false);
            }
            
            map.relayout();
            map.setCenter(new kakao.maps.LatLng(35.159545, 126.852601));
            
        }, 300);
    });
    
    $(window).on('resize', function() {
        if (map && $('#map-section').is(':visible')) {
            map.relayout();
            map.setCenter(centerPosition);
        }
    });
});
</script>


</body>
</html>
