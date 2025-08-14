console.log(res_idx);
console.log(mb_id);

/* =========================
   탭 이동 + active
========================= */
document.addEventListener('DOMContentLoaded', function () {
  const sections = document.querySelectorAll('#info-section, #amenity-section, #menu-section, #rating-section, #review-section');
  const tabLinks = document.querySelectorAll('.tab-link');
  const tab = document.getElementById('restaurantTabs');
  const tabOffsetTop = tab ? tab.offsetTop : 0;
  const scrollOffset = 110;

  function updateActiveTab() {
    let current = '';
    sections.forEach((section) => {
      const sectionTop = section.offsetTop;
      if (window.pageYOffset >= sectionTop - scrollOffset) current = section.getAttribute('id');
    });
    tabLinks.forEach((link) => {
      link.classList.remove('active');
      if (link.getAttribute('href') === `#${current}`) link.classList.add('active');
    });
  }

  tabLinks.forEach((link) => {
    link.addEventListener('click', function (e) {
      e.preventDefault();
      const targetId = this.getAttribute('href');
      const targetSection = document.querySelector(targetId);
      if (!targetSection) return;
      const elementTop = targetSection.getBoundingClientRect().top;
      const offsetTop = window.pageYOffset + elementTop - scrollOffset;
      window.scrollTo({ top: offsetTop, behavior: 'smooth' });
    });
  });

  window.addEventListener('scroll', () => {
    updateActiveTab();
    if (!tab) return;
    if (window.scrollY >= tabOffsetTop - 60) tab.classList.add('fixed');
    else tab.classList.remove('fixed');
  });
});

/* =========================
   갤러리(대표 이미지) 모달 — #imageModal 전용
========================= */
(function GalleryModal() {
  const galleryWrapper = document.getElementById('imageModal');      // 오버레이
  const galleryImg     = document.getElementById('modalImageTag');   // 큰 이미지
  const prevBtn        = document.getElementById('galleryPrev');
  const nextBtn        = document.getElementById('galleryNext');
  const closeBtn       = document.getElementById('galleryClose');
  const reviewSection  = document.getElementById('review-section');

  const images = [];        // URL 배열
  let clickableNodes = [];  // 클릭 가능한 DOM
  let currentIndex = 0;

  function extractUrl(el) {
    if (!el) return '';
    if (el.dataset && el.dataset.url) return el.dataset.url; // ← 우선 사용
    if (el.tagName && el.tagName.toLowerCase() === 'img' && el.src) return el.src;
    const bg = getComputedStyle(el).backgroundImage;
    if (!bg || bg === 'none') return '';
    const m = bg.match(/url\((['"]?)(.*?)\1\)/i);
    return m ? m[2] : '';
  }

  function updateNavState() {
    if (!prevBtn || !nextBtn) return;
    if (images.length <= 1) {
      prevBtn.style.display = 'none';
      nextBtn.style.display = 'none';
    } else {
      prevBtn.style.display = '';
      nextBtn.style.display = '';
      prevBtn.disabled = currentIndex <= 0;
      nextBtn.disabled = currentIndex >= images.length - 1;
    }
  }

  function updateGalleryImage() {
    if (!galleryImg) return;
    let url = images[currentIndex];
    if (!url && clickableNodes[currentIndex]) {
      url = extractUrl(clickableNodes[currentIndex]) || '';
      if (url) images[currentIndex] = url;
    }
    if (!url) {
      console.warn('[gallery] 이미지 URL 비어있음 idx=', currentIndex);
      return;
    }
    galleryImg.src = url;
    updateNavState();
  }

  function openGallery(index) {
    if (!galleryWrapper || !galleryImg) return;
    currentIndex = index;
    updateGalleryImage();
    galleryWrapper.style.display = 'flex';
    document.body.style.overflow = 'hidden';
  }

  function closeGallery() {
    if (!galleryWrapper) return;
    galleryWrapper.style.display = 'none';
    document.body.style.overflow = '';
  }

  function prevImage() {
    if (currentIndex > 0) {
      currentIndex--;
      updateGalleryImage();
    }
  }

  function nextImage() {
    if (currentIndex < images.length - 1) {
      currentIndex++;
      updateGalleryImage();
    }
  }

  document.addEventListener('DOMContentLoaded', () => {
    // 후보 수집 (.main-image, .sub-image) — 리뷰 섹션 내부는 제외
    const candidates = Array.from(document.querySelectorAll('.main-image, .sub-image'));
    clickableNodes = candidates.filter((el) => !(reviewSection && reviewSection.contains(el)));

    // URL 채우기
    clickableNodes.forEach((el) => {
      const url = extractUrl(el);
      if (url) images.push(url);
    });

    // 클릭 바인딩
    clickableNodes.forEach((el, idx) => {
      el.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        openGallery(idx);
      });
    });

    // 오버레이 클릭 닫기 (이미지/버튼 클릭은 제외)
    if (galleryWrapper) {
      galleryWrapper.addEventListener('click', (e) => {
        if (e.target === galleryWrapper) closeGallery();
      }, { passive: true });
    }

    // X 버튼 닫기
    closeBtn?.addEventListener('click', (e) => {
      e.preventDefault();
      closeGallery();
    });

    // 좌우 버튼
    prevBtn?.addEventListener('click', (e) => { e.preventDefault(); prevImage(); });
    nextBtn?.addEventListener('click', (e) => { e.preventDefault(); nextImage(); });

    // ESC 닫기
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && galleryWrapper && galleryWrapper.style.display === 'flex') closeGallery();
    });

    // 터치 스와이프
    if (galleryImg) {
      let startX = 0;
      galleryImg.addEventListener('touchstart', (e) => {
        startX = e.touches[0].clientX;
      }, { passive: true });
      galleryImg.addEventListener('touchend', (e) => {
        const endX = e.changedTouches[0].clientX;
        const diff = endX - startX;
        if (Math.abs(diff) > 50) (diff > 0 ? prevImage() : nextImage());
      }, { passive: true });
    }
  });

  // 인라인 호출 호환
  window.openModal  = openGallery;
  window.closeModal = closeGallery;
})();

/* =========================
   리뷰 이미지 모달 — #reviewImageModal 전용
   (JSP 인라인: onclick="openImageModal('URL')")
========================= */
(function ReviewImageModal() {
  const rim      = document.getElementById('reviewImageModal'); // 오버레이
  const rimImg   = document.getElementById('reviewModalImg');   // 이미지
  const closeBtn = document.getElementById('reviewModalClose'); // X 버튼

  function openReviewImage(url) {
    if (!rim || !rimImg) return;
    rimImg.src = url;
    rim.style.display = 'flex';
    document.body.style.overflow = 'hidden';
  }

  function closeReviewImage() {
    if (!rim) return;
    rim.style.display = 'none';
    document.body.style.overflow = '';
  }

  // 오버레이 클릭 닫기
  rim?.addEventListener('click', (e) => {
    if (e.target === rim) closeReviewImage();
  });

  // X 버튼 닫기
  closeBtn?.addEventListener('click', (e) => {
    e.preventDefault();
    closeReviewImage();
  });

  // ESC 닫기
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && rim && rim.style.display === 'flex') closeReviewImage();
  });

  // 전역 노출 (JSP 인라인과 호환)
  window.openImageModal   = openReviewImage;
  window.closeImageModal  = closeReviewImage;
  window.openReviewModal  = openReviewImage;   // HTML에서 openReviewModal(...) 써도 동작
  window.closeReviewModal = closeReviewImage;
})();

/* =========================
   리뷰 탭/더보기/작성 토글 & 유효성
========================= */
document.querySelectorAll('.review-tab').forEach((button) => {
  button.addEventListener('click', () => {
    document.querySelectorAll('.review-tab').forEach((btn) => btn.classList.remove('active'));
    button.classList.add('active');
    const targetId = button.getAttribute('data-target');
    document.querySelectorAll('.review-tab-content').forEach((content) => (content.style.display = 'none'));
    document.getElementById(targetId).style.display = 'block';
  });
});

document.addEventListener('DOMContentLoaded', function () {
  // 처음에 3개만 보이도록(0,1,2만 보이게). 나머지는 d-none
  const clampTo3 = (selector) => {
    const items = document.querySelectorAll(selector);
    items.forEach((el, idx) => {
      el.classList.toggle('d-none', idx >= 3); // ✅ idx >= 3 (버그였던 > 3 수정)
    });
  };

  clampTo3('.naver-review');
  clampTo3('.kakao-review');
  clampTo3('.user-review'); // ✅ 사용자 리뷰도 동일 규칙 적용

  // 토글 버튼 헬퍼
  const makeToggle = (btnId, itemSelector, moreText, lessText) => {
    const btn = document.getElementById(btnId);
    if (!btn) return; // 버튼이 없으면 스킵
    let expanded = false;

    btn.addEventListener('click', function () {
      const items = document.querySelectorAll(itemSelector);
      expanded = !expanded;

      // 펼치기: 전부 보이게 / 접기: 3개 이후 d-none
      items.forEach((el, idx) => {
        el.classList.toggle('d-none', !expanded && idx >= 3);
      });

      this.textContent = expanded ? lessText : moreText;
    });
  };

  // 버튼 id와 아이템 클래스 매핑
  makeToggle('toggle-naver', '.naver-review', '네이버 리뷰 더보기', '네이버 리뷰 접기');
  makeToggle('toggle-kakao', '.kakao-review', '카카오 리뷰 더보기', '카카오 리뷰 접기');
  makeToggle('toggle-user',  '.user-review',  '사용자 리뷰 더보기',  '사용자 리뷰 접기'); // ✅ 추가
});

document.addEventListener('DOMContentLoaded', function () {
  const toggleBtn = document.getElementById('toggleReviewBtn');
  const form = document.getElementById('reviewFormContainer');
  if (!toggleBtn || !form) return;

  // 초기 상태: 노란색 버튼
  toggleBtn.classList.add('btn', 'btn-warning');

  toggleBtn.addEventListener('click', function () {
    const isHidden = form.style.display === 'none' || form.style.display === '';
    form.style.display = isHidden ? 'block' : 'none';

    if (isHidden) {
      // X 상태 (배경 제거)
      this.textContent = 'X';
      this.classList.remove('btn-warning');
      this.classList.remove('btn');
      this.style.backgroundColor = 'transparent';
      this.style.border = 'none';
      this.style.color = 'black';
    } else {
      // 리뷰 작성 상태 (노란색 버튼)
      this.textContent = '리뷰 작성';
      this.classList.add('btn', 'btn-warning');
      this.style.backgroundColor = '';
      this.style.border = '';
      this.style.color = '';
    }

    if (isHidden) {
      form.scrollIntoView({ behavior: 'smooth' });
    }
  });
});


// 작성 유효성
const ratingError   = document.getElementById('ratingError');
const contentError  = document.getElementById('contentError');
const ratingInputs  = document.querySelectorAll('input[name="ratings"]');
const reviewContent = document.getElementById('reviewContent');

if (ratingInputs && ratingError) {
  ratingInputs.forEach((input) => input.addEventListener('change', () => (ratingError.style.display = 'none')));
}
if (reviewContent && contentError) {
  reviewContent.addEventListener('input', () => {
    if (reviewContent.value.trim() !== '') contentError.style.display = 'none';
  });
}
const reviewForm = document.getElementById('reviewForm');
if (reviewForm) {
  reviewForm.addEventListener('submit', function (e) {
    const ratingChecked = document.querySelector('input[name="ratings"]:checked');
    const content = (reviewContent ? reviewContent.value : '').trim();
    let isValid = true;
    if (!ratingChecked && ratingError) { ratingError.style.display = 'block'; isValid = false; }
    if (content === ''   && contentError) { contentError.style.display = 'block'; isValid = false; }
    if (!isValid) e.preventDefault();
  });
}

/* =========================
   영업시간 토글
========================= */
const arrow   = document.getElementById('toggleArrow');
const fullBox = document.getElementById('fullSchedule');
let isOpen = false;
if (arrow && fullBox) {
  arrow.addEventListener('click', () => {
    isOpen = !isOpen;
    fullBox.style.display = isOpen ? 'block' : 'none';
    arrow.classList.toggle('bi-chevron-down');
    arrow.classList.toggle('bi-chevron-up');
  });
}

/* =========================
   중복 랭킹 체크
========================= */
let isDuplicateRes = false;
$(document).ready(function () {
  if (typeof res_idx !== 'undefined' && res_idx) {
    checkFavoriteDuplicate(res_idx);
  } else {
    console.warn('res_idx가 없어 중복 랭킹 체크 생략');
  }
});

function checkFavoriteDuplicate(res_idx) {
  $.ajax({
    url: contextPath + '/feed/rescheck',
    type: 'GET',
    data: { res_idx: res_idx },
    success: function (isDuplicate) {
      isDuplicateRes = isDuplicate;
      if (isDuplicateRes) {
        $('#rankToggleWrapper').hide();
        $('#duplicateFavoriteMsg').show();
      } else {
        $('#rankToggleWrapper').show();
        $('#duplicateFavoriteMsg').hide();
      }
      if (typeof window.submitButtonState === 'function') window.submitButtonState();
    },
    error: function (xhr, status, err) {
      console.error('중복 체크 실패:', status, err);
      isDuplicateRes = false;
      $('#rankToggleWrapper').show();
      $('#duplicateFavoriteMsg').hide();
      if (typeof window.submitButtonState === 'function') window.submitButtonState();
    },
  });
}

/* =========================
   지도 토글
========================= */
var map;
function toggleMap() {
  const mapSection = document.getElementById('map-section');
  const toggleBtn  = document.getElementById('mapToggleBtn');
  if (!mapSection || !toggleBtn) return;

  if (mapSection.style.display === 'none') {
    mapSection.style.display = 'block';
    toggleBtn.innerText = '지도 접기';
    const center = new kakao.maps.LatLng(reslat, reslon);
    map = new kakao.maps.Map(document.getElementById('map'), { center: center, level: 1 });
    new kakao.maps.Marker({ position: center, map: map });
  } else {
    mapSection.style.display = 'none';
    toggleBtn.innerText = '지도 보기';
  }
}
window.toggleMap = toggleMap;

/* =========================
   찜 토글
========================= */
document.addEventListener('DOMContentLoaded', function () {
  const tooltip    = document.getElementById('iconTooltip');
  const iconGroup  = document.getElementById('restaurantIconGroup');
  if (!iconGroup) return;
  const iconEls = iconGroup.querySelectorAll('.icon-outline');

  if (!mb_id) {
    if (tooltip) {
      tooltip.style.display = 'block';
      setTimeout(() => (tooltip.style.display = 'none'), 3000);
    }
    return;
  }

  fetch(`${contextPath}/going/check`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: `res_idx=${res_idx}&mb_id=${mb_id}`,
  })
    .then((r) => r.json())
    .then((data) => {
      if (data.isGoing) {
        iconEls.forEach((i) => i.classList.add('active'));
        if (tooltip) tooltip.style.display = 'none';
      } else {
        if (tooltip) {
          tooltip.style.display = 'block';
          setTimeout(() => (tooltip.style.display = 'none'), 3000);
        }
      }
    });

  iconGroup.addEventListener('click', function () {
    if (!mb_id) { alert('로그인이 필요합니다.'); return; }
    fetch(`${contextPath}/going/check`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: `res_idx=${res_idx}&mb_id=${mb_id}`,
    })
      .then((r) => r.json())
      .then((data) => {
        const isGoing = data.isGoing;
        const url = isGoing ? `${contextPath}/going/delete` : `${contextPath}/going/insert`;
        const method = isGoing ? 'DELETE' : 'POST';
        return fetch(`${url}?res_idx=${res_idx}&mb_id=${mb_id}`, { method });
      })
      .then((r) => r.json())
      .then((result) => {
        if (result.success) iconEls.forEach((i) => i.classList.toggle('active'));
        else { console.warn('요청 실패:', result); alert('요청 실패'); }
      })
      .catch((err) => {
        console.error('오류 발생:', err);
        alert('요청 처리 중 오류 발생');
      });
  });
});

// 고유 항목 개수 표시
document.addEventListener('DOMContentLoaded', function(){
  var count = document.querySelectorAll('#amenity-section .amenity-item').length;
  var badge = document.getElementById('amenity-count');
  if(badge) badge.textContent = count ? count : '';
});
