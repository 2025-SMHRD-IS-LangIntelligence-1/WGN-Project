$(document).ready(() => {
  // =========================
  // 팔로우 버튼
  // =========================
  $(".my-follow-btn").on("click", function (e) {
    e.preventDefault();

    const $btn = $(this);
    if ($btn.prop("disabled")) return;
    $btn.prop("disabled", true);

    const followingId = $btn.data("following-id");
    const isFollowed = $btn.data("followed");
    const action = isFollowed ? "unfollow" : "follow";

    $.ajax({
      url: contextPath + "/member/" + action,
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

    const postDiv = $btn.closest(".post-info");
    const feed_idx = postDiv.data("feed-idx");
    const icon = $btn.find("i");
    const likeCountSpan = postDiv.find(".like-count");

    const liked = icon.hasClass("clicked");
    const url = liked ? "/feed/deleteFeedLike" : "/feed/addFeedLike";

    // UI 즉시 반영
    const current = parseInt(likeCountSpan.text(), 10) || 0;
    if (liked) {
      icon.removeClass("clicked bi-heart-fill").addClass("bi-heart");
      likeCountSpan.text(current - 1);
    } else {
      icon.addClass("clicked bi-heart-fill").removeClass("bi-heart");
      likeCountSpan.text(current + 1);
    }

    // 서버 반영
    $.ajax({
      url: contextPath + url,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(feed_idx), // 서버가 숫자/문자열 어느 쪽을 기대하든 기존 방식 유지
      success: function (res) {
        // 서버에서 최신 좋아요 수 반환 시 동기화
        if (res !== undefined && res !== null) likeCountSpan.text(res);
      },
      error: function () {
        alert("좋아요 처리 중 오류가 발생했습니다.");
        // 실패 시 UI 되돌리기
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
      const $items = $carousel.find(".carousel-item");
      const $active = $carousel.find(".carousel-item.active");
      const idx = $items.index($active);
      const lastIdx = $items.length - 1;

      if ($items.length <= 1) {
        // 슬라이드가 1장이면 양쪽 버튼 숨김
        $prev.hide();
        $next.hide();
        return;
      }

      if (idx === 0) {
        // 첫 장
        $prev.hide();
        $next.show();
      } else if (idx === lastIdx) {
        // 마지막 장
        $prev.show();
        $next.hide();
      } else {
        // 중간
        $prev.show();
        $next.show();
      }
    }

    // 초기 상태
    updateControls();

    // 슬라이드 이동 후 갱신 (Bootstrap 이벤트)
    $carousel.on("slid.bs.carousel", updateControls);
  }
});

document.addEventListener("DOMContentLoaded", function () {
  const replaceRadio = document.getElementById("modeReplace");
  const appendRadio = document.getElementById("modeAppend");
  const saveBtn = document.querySelector(".modal-footer .btn-primary");

  function updateButtonColor() {
    if (replaceRadio.checked) {
      saveBtn.classList.remove("btn-primary");
      saveBtn.classList.add("btn-warning-custom");
    } else {
      saveBtn.classList.remove("btn-warning-custom");
      saveBtn.classList.add("btn-primary");
    }
  }

  // 초기 상태 반영
  updateButtonColor();

  // 라디오 버튼 상태 변경 시 색상 업데이트
  replaceRadio.addEventListener("change", updateButtonColor);
  appendRadio.addEventListener("change", updateButtonColor);
});
