// ============================== 프로필 ==============================

// 프로필 수정 모달창
const modal = document.getElementById('profileModal');

// 모달 열기 버튼
const openBtn = document.getElementById('profile-update-btn');

// 모달 닫기 버튼
const closeBtn = modal.querySelector('.close');

// 모달 띄우기
function openModal() {
  modal.style.display = 'block';
}

// 모달 닫기
function closeModal() {
  modal.style.display = 'none';
}

// 프로필 수정 버튼 클릭 시 모달 열기
openBtn.addEventListener('click', openModal);

// 닫기 버튼 클릭 시 모달 닫기
closeBtn.addEventListener('click', closeModal);

// 모달 바깥 영역 클릭 시 모달 닫기
window.addEventListener('click', function(event) {
  if (event.target === modal) {
    closeModal();
  }
});


// ============================== 지도 ==============================
var map = null;
var markers = []; // 지도 마커 저장
var center = new kakao.maps.LatLng(35.159545, 126.852601);

// 광주 범위
var sw = new kakao.maps.LatLng(34.9, 126.6);
var ne = new kakao.maps.LatLng(35.4, 127.2);
var bounds = new kakao.maps.LatLngBounds(sw, ne);
let openInfowindow = null;
// 마커 초기화 함수
function clearMarkers() {
	markers.forEach(marker => marker.setMap(null));
	markers = [];
	
	if (openInfowindow) {
		openInfowindow.close();
		openInfowindow = null;
	}
}

// ✅ 데이터 기반으로 마커 렌더링
function renderMarkers(dataset) {
	clearMarkers();

	dataset.forEach(function(item) {
		const position = new kakao.maps.LatLng(item.lat, item.lon);

		const marker = new kakao.maps.Marker({
			position: position,
			title: item.name
		});

		// 커스텀 인포윈도우
		const infowindow = new kakao.maps.InfoWindow({
			content: `
				<div style="width:170px; padding:8px; font-size:14px; display:flex; flex-direction:column; align-items:center; text-align:center; position:relative;">
					<button onclick="this.closest('div').style.display='none';"
						style="position:absolute; top:5px; right:5px; background:none; border:none; font-weight:bold; font-size:16px; cursor:pointer;">×</button>
					<strong style="margin-bottom:5px;">${item.name}</strong>
					<a href="${contextPath}/restaurant?res_idx=${encodeURIComponent(item.res_idx)}"
						style="color:#007bff; text-decoration:none; font-weight:bold;">
						정보 보기 &gt;
					</a>
				</div>
			`,
			removable: true
		});

		kakao.maps.event.addListener(marker, 'click', function () {
			map.setLevel(5);
			map.panTo(marker.getPosition());
			if (openInfowindow) {
					openInfowindow.close();
				}

				infowindow.open(map, marker);
				openInfowindow = infowindow; // 현재 열린 창 저장
			});

		marker.setMap(map);
		markers.push(marker);
	});
}

$(function () {
	// 게시글 탭
	$('#tab-posts').on('click', function (e) {
		e.preventDefault();
		$(this).addClass('active');
		$('#tab-map').removeClass('active');
		$('#posts-section').show();
		$('#map-section').hide();
	});

	// 지도 탭
	$('#tab-map').on('click', function (e) {
		e.preventDefault();
		$(this).addClass('active');
		$('#tab-posts').removeClass('active');
		$('#posts-section').hide();
		$('#map-section').show();

		setTimeout(function () {
			// 최초 지도 생성
			if (!map) {
				var container = document.getElementById('map');
				var options = {
					center: center,
					level: 9
				};
				map = new kakao.maps.Map(container, options);

				// 드래그 제한
				kakao.maps.event.addListener(map, 'dragend', function () {
					if (!bounds.contain(map.getCenter())) {
						map.setCenter(center);
					}
				});

				// 줌 제한
				kakao.maps.event.addListener(map, 'zoom_changed', function () {
					var currentLevel = map.getLevel();
					if (currentLevel > 9) {
						map.setLevel(9);
					}
					map.setCenter(center);
				});
			}

			// 항상 초기화
			map.relayout();
			map.setLevel(9);
			map.setCenter(center);
			renderMarkers(rankData); // 기본 마커 렌더링
		}, 300);
	});

	// 탭 클릭 이벤트는 map 초기화 여부와 무관하게 항상 바인딩
	document.querySelector('button[data-bs-target="#rank-content"]')
		.addEventListener('click', function () {
			map.setLevel(9);
			map.setCenter(center);
			renderMarkers(rankData);
		});

	document.querySelector('button[data-bs-target="#wish-content"]')
		.addEventListener('click', function () {
			map.setLevel(9);
			map.setCenter(center);
			renderMarkers(goingData);
		});

	// 화면 리사이즈 시 지도 중심 보정
	$(window).on('resize', function () {
		if (map && $('#map-section').is(':visible')) {
			map.relayout();
			map.setCenter(center);
		}
	});
});


// 음식점 랭킹 더보기 토글 !!!
function toggleFavorites() {
	const moreItems = document.querySelectorAll('[data-more="true"]');
	moreItems.forEach(item => {
		item.style.display = (item.style.display === 'none') ? 'flex' : 'none';
	});
}