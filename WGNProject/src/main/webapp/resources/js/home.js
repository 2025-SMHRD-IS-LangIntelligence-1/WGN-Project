document.addEventListener("DOMContentLoaded", function() {
	console.log('스크립트 실행됨');

	fetch('/wgn/recommendation/feed', {
		credentials: 'include'
	})
		.then(res => res.json())
		.then(feedIdxList => {
			console.log("추천 받은 feedIdxList:", feedIdxList);

			return fetch('/wgn/feed/previews', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				credentials: 'include',
				body: JSON.stringify(feedIdxList)
			});
		})
		.then(res => res.json())
		.then(data => {
			const { feeds, followingMemList, likedFeedList } = data;
			const feedListEl = document.getElementById('feed-list');

			feeds.forEach((feed, i) => {
				const carouselId = `carousel-${feed.feed_idx ?? `idx-${i}`}`; // ✅ 항상 유니크

				const isFollowing = followingMemList.includes(feed.mb_id);
				const isLiked = likedFeedList.includes(feed.feed_idx);

				const followButtonHTML = isFollowing
					? `<button class="my-follow-btn following" data-following-id="${feed.mb_id}" data-followed="true">팔로잉</button>`
					: `<button class="my-follow-btn" data-following-id="${feed.mb_id}" data-followed="false">팔로우</button>`;

				const heartIconClass = isLiked ? 'bi-heart-fill clicked' : 'bi-heart';

				const imgs = Array.isArray(feed.imageUrls) ? feed.imageUrls : [];
				const hasImages = imgs.length > 0;

				const postHTML = `
	      <div class="post">
	        <!-- 헤더 -->
	        <div class="post-header">
	          <a href="/wgn/profile/${feed.mb_id}" class="post-user" style="display:flex;align-items:center;text-decoration:none;color:inherit;">
	            <img src="${feed.mb_img || ''}" alt="프로필">
	            <div class="post-user-info">
	              <b>${feed.mb_nick || 'OtherUsers'}</b>
	              <span style="color:#888;font-size:12px;">${timeAgo(feed.created_at) || '방금 전'}</span>
	            </div>
	          </a>
	          ${followButtonHTML}
	        </div>

	        <!-- 미디어(캐러셀) -->
	        ${hasImages ? `
	          <a href="/wgn/feed?feed_idx=${feed.feed_idx}">
			  <div id="${carouselId}"
			       class="carousel slide post-media"
			       data-bs-touch="false"
			       data-bs-wrap="false"
			       data-bs-keyboard="false"
			       data-bs-interval="false">
	              <div class="carousel-inner">
	                ${imgs.map((img, idx) => `
	                  <div class="carousel-item ${idx === 0 ? 'active' : ''}">
	                    <img src="${img}" class="d-block w-100" alt="피드 이미지">
	                  </div>
	                `).join('')}
	              </div>
	              <button class="carousel-control-prev" type="button" data-bs-target="#${carouselId}" data-bs-slide="prev">
	                <span class="carousel-control-prev-icon"></span>
	              </button>
	              <button class="carousel-control-next" type="button" data-bs-target="#${carouselId}" data-bs-slide="next">
	                <span class="carousel-control-next-icon"></span>
	              </button>
	            </div>
	          </a>
	        ` : ``}

	        <!-- 액션 -->
	        <div class="post-actions" data-feed-idx="${feed.feed_idx}">
	          <div class="actions-left">
	            <span class="clickable-heart"><i class="bi ${heartIconClass}"></i></span>
	            <i class="bi bi-chat ms-3"></i>
	          </div>
	          <div class="actions-stats">
	            <span class="like-count stats ms-2">${feed.feed_likes}</span>
	            <span class="stats ms-2">좋아요  · </span>
	            <span class="stats ms-2">${feed.comment_count || 0}</span>
	            <span class="stats ms-2">댓글</span>
	          </div>
	        </div>
			
			<!-- 장소 카드 -->
			<div class="location-card" onclick="window.location='restaurant?res_idx=${feed.res_idx}'">
			  <div class="location-info">
				<b>${feed.res_name || '가게명'}</b>
				  <span>${feed.res_category || '카테고리'}</span>
			  </div>
				<i class="bi bi-chevron-right"></i>
			</div>

	        <!-- 본문 -->
	        <div class="post-caption">
	          <span class="caption-text collapsed">${feed.feed_content}</span>
	          <span class="more-btn" onclick="toggleMore(this)">더보기</span>
	        </div>
	      </div>
	    `;

				feedListEl.insertAdjacentHTML('beforeend', postHTML);
				initMoreFor(feedListEl.lastElementChild);
			});

			// 모든 DOM 삽입 후 한 번만 초기화
			initCarouselButtons(document);
			enableSwipeForCarousels(document);
		})
		.catch(err => {
			console.error("추천 피드 로드 실패:", err);
		});
});

/* ----------------- 헬퍼들 ----------------- */

// 캐러셀 버튼(1장/처음/마지막) 처리 + 링크 충돌 방지
function initCarouselButtons(scopeEl = document) {
  scopeEl.querySelectorAll(".carousel").forEach(carousel => {
    // 🔒 기본 스와이프/랩핑/키보드 비활성화
    bootstrap.Carousel.getOrCreateInstance(carousel, {
      interval: false,
      touch: false,
      wrap: false,
      keyboard: false
    });

    const prevBtn = carousel.querySelector(".carousel-control-prev");
    const nextBtn = carousel.querySelector(".carousel-control-next");
    const items = carousel.querySelectorAll(".carousel-item");
    if (!prevBtn || !nextBtn) return;

    if (!items || items.length <= 1) {
      prevBtn.style.display = "none";
      nextBtn.style.display = "none";
      return;
    }

    function updateButtons() {
      const activeIndex = Array.from(items).findIndex(item => item.classList.contains("active"));
      prevBtn.style.display = activeIndex <= 0 ? "none" : "block";
      nextBtn.style.display = activeIndex >= items.length - 1 ? "none" : "block";

      carousel.dataset.activeIndex = activeIndex;
      carousel.dataset.totalItems = items.length;
    }

    carousel.addEventListener("slid.bs.carousel", updateButtons);
    updateButtons();
  });
}

// 스와이프(터치/마우스 드래그)로 슬라이드
function enableSwipeForCarousels(scopeEl = document) {
	scopeEl.querySelectorAll('.carousel').forEach((carousel) => {
		const inner = carousel.querySelector('.carousel-inner');
		if (!inner) return;

		let startX = 0, deltaX = 0, dragging = false, dragged = false;
		const getX = (e) => (e.touches ? e.touches[0].clientX : e.clientX);
		const threshold = 40;

		const onDown = (e) => {
			dragging = true;
			dragged = false;
			startX = getX(e);
			deltaX = 0;
		};

		const onMove = (e) => {
			if (!dragging) return;
			deltaX = getX(e) - startX;
			if (Math.abs(deltaX) > 5) {
				dragged = true;
				e.preventDefault();
				e.stopPropagation();
			}
		};

		const onUp = () => {
			if (!dragging) return;
			dragging = false;

			const activeIndex = parseInt(carousel.dataset.activeIndex || 0);
			const totalItems = parseInt(carousel.dataset.totalItems || 1);

			if (Math.abs(deltaX) > threshold) {
				const inst = bootstrap.Carousel.getOrCreateInstance(carousel);
				   if (deltaX > 0 && activeIndex > 0) {
				     inst.prev();   // ✅ BS5 메서드
				   } else if (deltaX < 0 && activeIndex < totalItems - 1) {
				     inst.next();   // ✅ BS5 메서드
				   }
			}
			deltaX = 0;
		};

		// 터치
		inner.addEventListener('touchstart', onDown, { passive: true });
		inner.addEventListener('touchmove', onMove, { passive: false });
		inner.addEventListener('touchend', onUp, { passive: true });

		// 마우스
		inner.addEventListener('mousedown', onDown);
		inner.addEventListener('mousemove', onMove);
		inner.addEventListener('mouseup', onUp);
		inner.addEventListener('mouseleave', onUp);

		// 드래그 후 링크 막기
		inner.addEventListener('click', (e) => {
			if (dragged) {
				e.preventDefault();
				e.stopPropagation();
			}
		}, true);
	});
}




$(document).on("click", ".my-follow-btn", function(e) {
	e.preventDefault();

	const $btn = $(this);
	if ($btn.prop("disabled")) return;
	$btn.prop("disabled", true);

	const followingId = $btn.data('following-id');
	const isFollowed = $btn.data('followed');
	const action = isFollowed ? 'unfollow' : 'follow';

	$.ajax({
		url: contextPath + '/member/' + action,
		method: 'post',
		data: { following_id: followingId },
		success: (res) => {
			if (res === "followSuccess") {
				$btn.text('팔로잉').data('followed', true).addClass('following');
			} else if (res === "unfollowSuccess") {
				$btn.text('팔로우').data('followed', false).removeClass('following');
			} else if (res === "notLoggedIn") {
				window.location.href = contextPath + "/member/login";
			}
		},
		error: () => {
			alert('팔로우 요청 중 오류 발생');
		},
		complete: () => {
			$btn.prop("disabled", false);
		}
	});
});

$(document).on("click", ".clickable-heart", function() {
	const $btn = $(this);
	if ($btn.prop("disabled")) return;
	$btn.prop("disabled", true);

	const postDiv = $btn.closest(".post-actions");
	const feed_idx = postDiv.data("feed-idx");
	const icon = $btn.find("i");
	const likeCountSpan = postDiv.find(".like-count");

	const liked = icon.hasClass("clicked");
	const url = liked ? "/feed/deleteFeedLike" : "/feed/addFeedLike";

	if (liked) {
		icon.removeClass("clicked bi-heart-fill").addClass("bi-heart");
		likeCountSpan.text(parseInt(likeCountSpan.text()) - 1);
	} else {
		icon.addClass("clicked bi-heart-fill").removeClass("bi-heart");
		likeCountSpan.text(parseInt(likeCountSpan.text()) + 1);
	}

	$.ajax({
		url: contextPath + url,
		method: "POST",
		contentType: "application/json",
		data: JSON.stringify(feed_idx),
		success: function(res) {
			likeCountSpan.text(res);
		},
		error: function() {
			if (liked) {
				icon.addClass("clicked bi-heart-fill").removeClass("bi-heart");
				likeCountSpan.text(parseInt(likeCountSpan.text()) + 1);
			} else {
				icon.removeClass("clicked bi-heart-fill").addClass("bi-heart");
				likeCountSpan.text(parseInt(likeCountSpan.text()) - 1);
			}
			window.location.href = contextPath + "/member/login";
		},
		complete: function() {
			$btn.prop("disabled", false);
		}
	});
});

function toggleMore(btn) {
	const caption = btn.previousElementSibling; // .caption-text
	if (caption.classList.contains('collapsed')) {
		caption.classList.remove('collapsed');
		btn.textContent = '접기';
	} else {
		caption.classList.add('collapsed');
		btn.textContent = '… 더보기';
	}
}

function initMoreFor(postEl) {
	const cap = postEl.querySelector('.caption-text');
	const btn = postEl.querySelector('.more-btn');
	if (!cap || !btn) return;

	// 접힌 상태로 만들어 놓고 높이 비교
	cap.classList.add('collapsed');

	requestAnimationFrame(() => {
		const needsMore = cap.scrollHeight > cap.clientHeight + 1;
		if (needsMore) {
			btn.style.display = 'inline';
			btn.textContent = '… 더보기';
		} else {
			btn.style.display = 'none';
		}
	});
}