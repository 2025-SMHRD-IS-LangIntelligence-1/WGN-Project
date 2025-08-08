// ============================== 프로필 ==============================

console.log(contextPath)
console.log(Mb_id)
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

// 데이터 기반으로 마커 렌더링
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

// 랭킹 및 찜 음식점 더보기
window.toggleFavorites = (function () {
  let expanded = false; // 더보기 상태 저장
  return function () {
    const items = document.querySelectorAll('a[data-more="favorite"]');
    const btn   = document.getElementById('favoritesToggleBtn');

    expanded = !expanded;

    // 4위 이후 항목 보이기 / 숨기기
    items.forEach(el => {
      el.style.display = expanded ? 'block' : 'none';
    });

    // 버튼 텍스트만 변경 (색상은 CSS에서 고정)
    if (btn) {
      btn.textContent = expanded ? '접기' : '더보기';
    }
  };
})();

// 랭킹 및 찜 음식점 더보기
window.togglegoing = (function () {
  let expanded = false;
  return function () {
    const items = document.querySelectorAll('div[data-more="going"]');
    const btn   = document.getElementById('goingToggleBtn');


    // console.log('[togglegoing] items:', items.length);

    expanded = !expanded;
    items.forEach(el => el.classList.toggle('d-none', !expanded));
    if (btn) btn.textContent = expanded ? '접기' : '더보기';
  };
})();

// 찜 삭제
document.addEventListener('DOMContentLoaded', function () {
  const modalEl = document.getElementById('unGoingModal');
  const modalResName = document.getElementById('modalResName');
  const confirmBtn = document.getElementById('confirmUnGoingBtn');
  if (!modalEl || !modalResName || !confirmBtn) return;

  let targetResIdx = null;
  let targetItemEl = null;

  // 모달 열릴 때 데이터 주입
  modalEl.addEventListener('show.bs.modal', function (event) {
    const btn = event.relatedTarget;
    targetResIdx = btn.getAttribute('data-res-idx');
    modalResName.textContent = btn.getAttribute('data-res-name');
    targetItemEl = btn.closest('.list-group-item') || btn.closest('.card') || btn.closest('li');
  });

  // 네 버튼 클릭 → AJAX POST (로컬 단순 버전)
  confirmBtn.addEventListener('click', async function () {
    const res = await fetch(`${contextPath}/going/delete`, {
      method: 'DELETE',
	  headers: {
	  				"Content-Type": "application/x-www-form-urlencoded"
	  			},
      body: `res_idx=${encodeURIComponent(targetResIdx)}&mb_id=${Mb_id}`
    });

    if (!res.ok) { 
      alert('삭제 실패'); 
      return; 
    }

    if (targetItemEl) targetItemEl.remove();               
    bootstrap.Modal.getInstance(modalEl).hide();           // 모달 닫기
  });
});


// 내랭킹 수정
(function () {

  // ====== DOM 요소 캐싱 ======
  const sortBtn = document.getElementById('sortToggleBtn');      
  const modalEl = document.getElementById('sortRankModal');   
  const saveBtn = document.getElementById('saveRankOrderBtn');   
  const listEl  = document.getElementById('sortableRankList');    

  // ====== 리스트 순위 배지 번호 재정렬 함수 ======
  function renumberModal() {
    listEl.querySelectorAll('.list-group-item[data-res-idx]').forEach((el, i) => {
      const b = el.querySelector('.order-badge');
      if (b) b.textContent = (i + 1) + '위';
    });
  }

  // ====== 버튼 클릭 시 모달 열기 ======
  if (sortBtn) {
    sortBtn.addEventListener('click', () => new bootstrap.Modal(modalEl).show());
  }

  // ====== Sortable 초기화 (한 번만 실행) ======
  let once = false;
  modalEl.addEventListener('shown.bs.modal', () => {
    if (once) return;

    // Sortable.js 설정
    new Sortable(listEl, {
      animation: 150,                                
      handle: '.bi-grip-vertical, .list-group-item',
      draggable: '.list-group-item',                
      onSort: renumberModal,                        
      onEnd: renumberModal,                         

      // ====== 스크롤 설정 (리스트 영역만 스크롤) ======
      scroll: true,             
      scrollSensitivity: 80,    
      scrollSpeed: 20,         
      bubbleScroll: true       
    });

    once = true; // 두 번 초기화 방지
    renumberModal(); 
  });

  // ====== 저장 버튼 클릭 시 서버로 순서 전송 ======
  saveBtn.addEventListener('click', async () => {
    saveBtn.disabled = true; 

    // 서버로 보낼 데이터 구성
    const payload = {
      type: 'favorite', 
      list: Array.from(listEl.querySelectorAll('.list-group-item[data-res-idx]'))
              .map((el, i) => ({
                res_idx: Number(el.getAttribute('data-res-idx')),
                pos: i + 1                                      
              }))
    };

    try {
      // AJAX 요청 (JSON 전송)
      const res = await fetch(`${contextPath}/favorite/order`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });

      if (!res.ok) throw new Error('순서 저장 실패');

      // 저장 성공 → 모달 닫기 + 새로고침
      bootstrap.Modal.getInstance(modalEl).hide();
      location.reload();

    } catch (e) {
      alert(e.message || '저장 중 오류가 발생했습니다.');
    } finally {
      saveBtn.disabled = false; // 버튼 다시 활성화
    }
  });

})();


document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".btn-remove").forEach(btn => {
        btn.addEventListener("click", function () {
            const resIdx = this.dataset.resIdx;

            if (!confirm("정말 삭제하시겠습니까?")) return;

            fetch(`${contextPath}/favorite/delete`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: `res_idx=${encodeURIComponent(resIdx)}`
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    this.closest("li").remove();
                } else {
                    alert("삭제 실패: " + (data.error || "알 수 없는 오류"));
                }
            })
            .catch(err => alert("서버 오류: " + err));
        });
    });
});