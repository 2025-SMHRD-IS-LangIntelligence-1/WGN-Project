/* ============================== 공통 설정 ============================== */
(() => {
  // contextPath 안전 참조 (없으면 빈 문자열)
  const CP = (typeof contextPath !== 'undefined') ? contextPath : '';
  // 로그인 사용자 ID (JSP에서 window.Mb_id로 주입됨)
  const MBID = (typeof Mb_id !== 'undefined') ? Mb_id : '';

  /* ============================== 전역(지도) ============================== */
  let map = null;
  let markers = [];
  let openInfowindow = null;

  // 광주 중심/범위
  const center = new kakao.maps.LatLng(35.159545, 126.852601);
  const sw = new kakao.maps.LatLng(34.9, 126.6);
  const ne = new kakao.maps.LatLng(35.4, 127.2);
  const bounds = new kakao.maps.LatLngBounds(sw, ne);

  function clearMarkers() {
    markers.forEach(m => m.setMap(null));
    markers = [];
    if (openInfowindow) {
      openInfowindow.close();
      openInfowindow = null;
    }
  }

  function renderMarkers(dataset) {
    if (!Array.isArray(dataset)) return;
    clearMarkers();

    dataset.forEach(item => {
      const position = new kakao.maps.LatLng(item.lat, item.lon);
      const marker = new kakao.maps.Marker({ position, title: item.name });

      const content = `
        <div style="width:170px; padding:8px; font-size:14px; display:flex; flex-direction:column; align-items:center; text-align:center; position:relative;">
          <button onclick="this.closest('div').style.display='none';"
            style="position:absolute; top:5px; right:5px; background:none; border:none; font-weight:bold; font-size:16px; cursor:pointer;">×</button>
          <strong style="margin-bottom:5px;">${item.name}</strong>
          <a href="${CP}/restaurant?res_idx=${encodeURIComponent(item.res_idx)}"
            style="color:#007bff; text-decoration:none; font-weight:bold;">
            정보 보기 &gt;
          </a>
        </div>
      `;
      const infowindow = new kakao.maps.InfoWindow({ content, removable: true });

      kakao.maps.event.addListener(marker, 'click', function () {
        map.setLevel(5);
        map.panTo(marker.getPosition());
        if (openInfowindow) openInfowindow.close();
        infowindow.open(map, marker);
        openInfowindow = infowindow;
      });

      marker.setMap(map);
      markers.push(marker);
    });
  }

  /* ============================== 전역(더보기 토글) ============================== */
  // 랭킹 더보기/접기
  window.toggleFavorites = (() => {
    let expanded = false;
    return function () {
      const items = document.querySelectorAll('a[data-more="favorite"]');
      const btn = document.getElementById('favoritesToggleBtn');
      expanded = !expanded;
      items.forEach(el => { el.style.display = expanded ? 'block' : 'none'; });
      if (btn) btn.textContent = expanded ? '접기' : '더보기';
    };
  })();

  // 찜 더보기/접기
  window.togglegoing = (() => {
    let expanded = false;
    return function () {
      const items = document.querySelectorAll('div[data-more="going"]');
      const btn = document.getElementById('goingToggleBtn');
      expanded = !expanded;
      items.forEach(el => el.classList.toggle('d-none', !expanded));
      if (btn) btn.textContent = expanded ? '접기' : '더보기';
    };
  })();

  /* ============================== DOM 로드 후 바인딩 ============================== */
  document.addEventListener('DOMContentLoaded', () => {
    /* ---- 프로필 수정 모달 ---- */
    const modal = document.getElementById('profileModal');
    const openBtn = document.getElementById('profile-update-btn'); // 본인 페이지에서만 존재
    const closeBtn = modal ? modal.querySelector('.close') : null;

    function openModal() { if (modal) modal.style.display = 'block'; }
    function closeModal() { if (modal) modal.style.display = 'none'; }

    if (openBtn) openBtn.addEventListener('click', openModal);
    if (closeBtn) closeBtn.addEventListener('click', closeModal);
    window.addEventListener('click', (e) => { if (modal && e.target === modal) closeModal(); });

    /* ---- 게시글/지도 탭 전환 ---- */
    // 게시글 탭
    const $tabPosts = $('#tab-posts');
    const $tabMap = $('#tab-map');
    const $posts = $('#posts-section');
    const $mapSec = $('#map-section');

    $tabPosts.on('click', function (e) {
      e.preventDefault();
      $tabPosts.addClass('active'); $tabMap.removeClass('active');
      $posts.show(); $mapSec.hide();
    });

    // 지도 탭
    $(document).on('click', '#tab-map', function (e) {
      e.preventDefault();
      $tabMap.addClass('active'); $tabPosts.removeClass('active');
      $posts.hide(); $mapSec.show();

      setTimeout(function () {
        if (!map) {
          const container = document.getElementById('map');
          const options = { center: center, level: 9 };
          map = new kakao.maps.Map(container, options);

          // 드래그 제한
          kakao.maps.event.addListener(map, 'dragend', function () {
            if (!bounds.contain(map.getCenter())) map.setCenter(center);
          });
          // 줌 제한
          kakao.maps.event.addListener(map, 'zoom_changed', function () {
            const lv = map.getLevel();
            if (lv > 9) map.setLevel(9);
            map.setCenter(center);
          });
        }

        map.relayout();
        map.setLevel(9);
        map.setCenter(center);
        // rankData / goingData는 JSP에서 window 전역 변수로 주입됨
        if (typeof rankData !== 'undefined') renderMarkers(rankData);
      }, 300);
    });

    // 지도 하단 탭(랭킹/찜) 눌렀을 때 마커 교체
    const rankBtn = document.querySelector('button[data-bs-target="#rank-content"]');
    const wishBtn = document.querySelector('button[data-bs-target="#wish-content"]');
    if (rankBtn) rankBtn.addEventListener('click', () => {
      if (!map) return;
      map.setLevel(9); map.setCenter(center);
      if (typeof rankData !== 'undefined') renderMarkers(rankData);
    });
    if (wishBtn) wishBtn.addEventListener('click', () => {
      if (!map) return;
      map.setLevel(9); map.setCenter(center);
      if (typeof goingData !== 'undefined') renderMarkers(goingData);
    });

    // 리사이즈 시 지도 보정
    $(window).on('resize', function () {
      if (map && $mapSec.is(':visible')) {
        map.relayout();
        map.setCenter(center);
      }
    });

    /* ---- 찜 해제 모달 + 삭제 요청 ---- */
    const unGoingModal = document.getElementById('unGoingModal');
    const modalResName = document.getElementById('modalResName');
    const confirmBtn = document.getElementById('confirmUnGoingBtn');

    if (unGoingModal && modalResName && confirmBtn) {
      let targetResIdx = null;
      let targetItemEl = null;

      unGoingModal.addEventListener('show.bs.modal', function (event) {
        const btn = event.relatedTarget;
        if (!btn) return;
        targetResIdx = btn.dataset?.resIdx || btn.getAttribute('data-res-idx') || '';
        const resName = btn.dataset?.resName || btn.getAttribute('data-res-name') || '';
        modalResName.textContent = resName;
        targetItemEl = btn.closest('.list-group-item') || btn.closest('.card') || btn.closest('li') || null;
      });

      confirmBtn.addEventListener('click', async function () {
        try {
          if (!targetResIdx) { alert('대상 식별자가 없습니다.'); return; }
          if (!MBID) { alert('로그인이 필요합니다.'); return; }

          const res = await fetch(`${CP}/going/delete`, {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `res_idx=${encodeURIComponent(targetResIdx)}&mb_id=${encodeURIComponent(MBID)}`
          });

          if (!res.ok) {
            const text = await res.text();
            console.error('Delete failed:', text);
            alert('삭제 실패');
            return;
          }

          if (targetItemEl) targetItemEl.remove();
          const instance = bootstrap.Modal.getInstance(unGoingModal) || bootstrap.Modal.getOrCreateInstance(unGoingModal);
          instance.hide();
        } catch (e) {
          console.error(e);
          alert('삭제 중 오류가 발생했습니다.');
        }
      });
    }

    /* ---- 내 랭킹 정렬(모달 + Sortable + 저장) ---- */
    const sortBtn = document.getElementById('sortToggleBtn');
    const sortModal = document.getElementById('sortRankModal');
    const saveBtn = document.getElementById('saveRankOrderBtn');
    const listEl = document.getElementById('sortableRankList');

    function renumberModal() {
      if (!listEl) return;
      listEl.querySelectorAll('.list-group-item[data-res-idx]').forEach((el, i) => {
        const b = el.querySelector('.order-badge');
        if (b) b.textContent = (i + 1) + '위';
      });
    }

    if (sortBtn && sortModal) {
      sortBtn.addEventListener('click', () => new bootstrap.Modal(sortModal).show());
    }

    if (sortModal && listEl) {
      let once = false;
      sortModal.addEventListener('shown.bs.modal', () => {
        if (once) return;
        new Sortable(listEl, {
          animation: 150,
          handle: '.bi-grip-vertical, .list-group-item',
          draggable: '.list-group-item',
          onSort: renumberModal,
          onEnd: renumberModal,
          scroll: true,
          scrollSensitivity: 80,
          scrollSpeed: 20,
          bubbleScroll: true
        });
        once = true;
        renumberModal();
      });
    }

    if (saveBtn && listEl) {
      saveBtn.addEventListener('click', async () => {
        saveBtn.disabled = true;
        const payload = {
          type: 'favorite',
          list: Array.from(listEl.querySelectorAll('.list-group-item[data-res-idx]')).map((el, i) => ({
            res_idx: Number(el.getAttribute('data-res-idx')),
            pos: i + 1
          }))
        };
        try {
          const res = await fetch(`${CP}/favorite/order`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
          });
          if (!res.ok) throw new Error('순서 저장 실패');
          bootstrap.Modal.getInstance(sortModal).hide();
          location.reload();
        } catch (e) {
          alert(e.message || '저장 중 오류가 발생했습니다.');
        } finally {
          saveBtn.disabled = false;
        }
      });
    }

    /* ---- 랭킹 항목 개별 삭제 버튼(정렬 모달 내부) ---- */
    document.querySelectorAll('.btn-remove').forEach(btn => {
      btn.addEventListener('click', function () {
        const resIdx = this.dataset.resIdx;
        if (!resIdx) return;
        if (!confirm('정말 삭제하시겠습니까?')) return;

        fetch(`${CP}/favorite/delete`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: `res_idx=${encodeURIComponent(resIdx)}`
        })
        .then(r => r.json())
        .then(data => {
          if (data.success) this.closest('li')?.remove();
          else alert('삭제 실패: ' + (data.error || '알 수 없는 오류'));
        })
        .catch(err => alert('서버 오류: ' + err));
      });
    });
  });
})();
