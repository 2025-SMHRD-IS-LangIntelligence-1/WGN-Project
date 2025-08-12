$(document).ready(() => {
  // =========================
  // 전역 CP(컨텍스트 경로) 안전 참조
  // =========================
  const CP = (() => {
    if (typeof window.contextPath !== 'undefined' && window.contextPath) return window.contextPath;
    if (typeof contextPath !== 'undefined' && contextPath) return contextPath;
    return '';
  })();

  // =========================
  // 팔로우 버튼
  // =========================
  $(".my-follow-btn").on("click", function (e) {
    e.preventDefault();

    const $btn = $(this);
    if ($btn.prop("disabled")) return;
    $btn.prop("disabled", true);

    const followingId = $btn.data("following-id");
    const isFollowed  = $btn.data("followed");
    const action      = isFollowed ? "unfollow" : "follow";

    $.ajax({
      url: CP + "/member/" + action,
      method: "POST",
      data: { following_id: followingId },
      success: (res) => {
        if (res === "followSuccess") {
          $btn.text("팔로잉").data("followed", true).addClass("following");
        } else if (res === "unfollowSuccess") {
          $btn.text("팔로우").data("followed", false).removeClass("following");
        } else if (res === "notLoggedIn") {
          alert("로그인이 필요합니다.");
        }
      },
      error: () => {
        alert("팔로우 요청 중 오류 발생");
      },
      complete: () => {
        $btn.prop("disabled", false);
      },
    });
  });

  // =========================
  // 좋아요 버튼
  // =========================
  $(".clickable-heart").on("click", function () {
    const $btn = $(this);
    if ($btn.prop("disabled")) return;
    $btn.prop("disabled", true);

    // ⚠️ data-feed-idx가 달린 바깥 컨테이너를 확실히 찾기
    const $container    = $btn.closest("[data-feed-idx]");
    const feed_idx      = $container.data("feed-idx");
    const icon          = $btn.find("i");
    const likeCountSpan = $container.find(".like-count");

    if (typeof feed_idx === "undefined") {
      // 필수 데이터 없으면 롤백 후 종료
      $btn.prop("disabled", false);
      return;
    }

    const liked = icon.hasClass("clicked");
    const url   = liked ? "/feed/deleteFeedLike" : "/feed/addFeedLike";

    // UI 먼저 반영
    const current = parseInt(likeCountSpan.text(), 10) || 0;
    if (liked) {
      icon.removeClass("clicked bi-heart-fill").addClass("bi-heart");
      likeCountSpan.text(current - 1);
    } else {
      icon.addClass("clicked bi-heart-fill").removeClass("bi-heart");
      likeCountSpan.text(current + 1);
    }

    // 서버 반영 (폼 인코딩으로 400 회피)
    $.ajax({
      url: CP + url,
      method: "POST",
	  contentType: "application/json; charset=UTF-8",
      data: JSON.stringify(window.feedIdx),
      success: function (res) {
        // 서버가 최신 좋아요 수를 돌려주면 동기화
        if (res !== undefined && res !== null && res !== '') {
          likeCountSpan.text(res);
        }
      },
      error: function () {
        alert("좋아요 처리 중 오류가 발생했습니다.");
        // 실패 시 UI 롤백
        const curr2 = parseInt(likeCountSpan.text(), 10) || 0;
        if (liked) {
          icon.addClass("clicked bi-heart-fill").removeClass("bi-heart");
          likeCountSpan.text(curr2 + 1);
        } else {
          icon.removeClass("clicked bi-heart-fill").addClass("bi-heart");
          likeCountSpan.text(curr2 - 1);
        }
      },
      complete: function () {
        $btn.prop("disabled", false);
      },
    });
  });

  // =========================
  // Carousel prev/next 표시 제어
  // =========================
  const $carousel = $("#carousel1");
  if ($carousel.length) {
    const $prev = $carousel.find(".carousel-control-prev");
    const $next = $carousel.find(".carousel-control-next");

    function updateControls() {
      const $items  = $carousel.find(".carousel-item");
      const $active = $carousel.find(".carousel-item.active");
      const idx     = $items.index($active);
      const lastIdx = $items.length - 1;

      if ($items.length <= 1) { $prev.hide(); $next.hide(); return; }

      if (idx === 0)        { $prev.hide(); $next.show(); }
      else if (idx === lastIdx) { $prev.show(); $next.hide(); }
      else                  { $prev.show(); $next.show(); }
    }

    updateControls();
    $carousel.on("slid.bs.carousel", updateControls);
  }
});

/* =========================
   편집 모달 라디오에 따른 저장 버튼 색상 (안전 가드)
========================= */
document.addEventListener("DOMContentLoaded", function () {
  const editModal = document.getElementById("editFeedModal");
  if (!editModal) return;

  const replaceRadio = document.getElementById("modeReplace");
  const appendRadio  = document.getElementById("modeAppend");
  const saveBtn      = editModal.querySelector('.modal-footer button[type="submit"]');

  if (!saveBtn) return; // 저장 버튼이 없으면 종료

  function updateButtonColor() {
    const isReplace = !!(replaceRadio && replaceRadio.checked);
    if (isReplace) {
      saveBtn.classList.remove("btn-yellow");
      saveBtn.classList.add("btn-warning");
    } else {
      saveBtn.classList.remove("btn-warning");
      saveBtn.classList.add("btn-yellow");
    }
  }

  replaceRadio?.addEventListener("change", updateButtonColor);
  appendRadio?.addEventListener("change", updateButtonColor);
  updateButtonColor(); // 초기 반영
});

/* =========================
   편집 폼 중복 제출 방지 + 오버레이
========================= */
document.addEventListener('DOMContentLoaded', function () {
  const form    = document.querySelector('#editFeedModal form');
  const overlay = document.getElementById('updatingOverlay');

  if (!form || !overlay) return;

  form.addEventListener('submit', function (e) {
    if (form.dataset.submitting === 'true') {
      e.preventDefault();
      return;
    }
    form.dataset.submitting = 'true';

    const submitBtn = form.querySelector('button[type="submit"]');
    if (submitBtn) {
      submitBtn.disabled     = true;
      submitBtn.dataset._old = submitBtn.innerHTML;
      submitBtn.innerHTML    = '저장 중...';
    }

    overlay.style.display = 'flex';
  }, { passive: false });

  window.addEventListener('pageshow', function () {
    overlay.style.display = 'none';
    form.dataset.submitting = 'false';
    const submitBtn = form.querySelector('button[type="submit"]');
    if (submitBtn && submitBtn.dataset._old) {
      submitBtn.innerHTML = submitBtn.dataset._old;
      submitBtn.disabled  = false;
      delete submitBtn.dataset._old;
    }
  });
});