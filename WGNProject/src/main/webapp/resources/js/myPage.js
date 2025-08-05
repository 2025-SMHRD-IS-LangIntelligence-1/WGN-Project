var map = null;
var markers = []; // 지도 마커 저장
var center = new kakao.maps.LatLng(35.159545, 126.852601);

// 광주 범위
var sw = new kakao.maps.LatLng(34.9, 126.6);
var ne = new kakao.maps.LatLng(35.4, 127.2);
var bounds = new kakao.maps.LatLngBounds(sw, ne);

// 더미 데이터
var rankDummy = [{
	name: '해물짬뽕 전문점',
	lat: 35.17,
	lng: 126.85
}, {
	name: '편육',
	lat: 35.16,
	lng: 126.86
}, {
	name: '조개찜 전문점',
	lat: 35.15,
	lng: 126.84
}];

var wishDummy = [{
	name: '내가 찜한 가게 1',
	lat: 35.18,
	lng: 126.83
}, {
	name: '내가 찜한 가게 2',
	lat: 35.14,
	lng: 126.87
}];

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
	$('#tab-map')
		.on(
			'click',
			function(e) {
				e.preventDefault();
				$(this).addClass('active');
				$('#tab-posts').removeClass('active');
				$('#posts-section').hide();
				$('#map-section').show();

				setTimeout(
					function() {
						if (!map) {
							var container = document
								.getElementById('map');
							var options = {
								center: center,
								level: 9
							};
							map = new kakao.maps.Map(
								container, options);

							// 지도 드래그 제한 (광주 범위)
							kakao.maps.event
								.addListener(
									map,
									'dragend',
									function() {
										if (!bounds
											.contain(map
												.getCenter())) {
											map
												.setCenter(center);
										}
									});

							// 확대 제한
							kakao.maps.event
								.addListener(
									map,
									'zoom_changed',
									function() {
										var currentLevel = map
											.getLevel();
										var maxLevel = 9;
										if (currentLevel > maxLevel) {
											map
												.setLevel(maxLevel);
										}
										map
											.setCenter(center);
									});

							// 초기 마커: 랭킹 데이터
							renderMarkers(rankDummy);

							// 랭킹 탭 클릭 시
							document
								.querySelector(
									'button[data-bs-target="#rank-content"]')
								.addEventListener(
									'click',
									function() {
										renderMarkers(rankDummy);
									});

							// 찜 탭 클릭 시
							document
								.querySelector(
									'button[data-bs-target="#wish-content"]')
								.addEventListener(
									'click',
									function() {
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