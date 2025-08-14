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
				const heartHTML = isLiked
					? `<span class="clickable-heart stats" data-is-liking="true">
				       <i class="bi bi-heart-fill clicked stats"></i>
				     </span>`
					: `<span class="clickable-heart stats" data-is-liking="false">
				       <i class="bi bi-heart stats"></i>
				     </span>`;

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

			<!-- 좋아요 / 댓글 수 / 평점 -->
						<div
							class="post-info d-flex align-items-center justify-content-between post-meta-line"
							data-feed-idx="${feed.feed_idx}">

							<div class="post-info">
							    ${heartHTML}
							    <span class="like-comment-group stats ms-2">
							        <span class="like-count">${feed.feed_likes}</span>
							        <span>좋아요 · </span>
							        <span class="comment-count">${feed.comment_count}</span>
							        <span><a href="/wgn/feed?feed_idx=${feed.feed_idx}" style="color: black; text-decoration: none;">댓글</a></span>
							    </span>
							</div>
							
							<div class="rating-box">
												<i class="bi bi-star"></i> ${feed.ratings != null ? feed.ratings : '없음'}
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
				     inst.prev();   // BS5 메서드
				   } else if (deltaX < 0 && activeIndex < totalItems - 1) {
				     inst.next();   // BS5 메서드
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
// =========================
// 좋아요 버튼 클릭 이벤트
// =========================
$(document).on("click", ".clickable-heart", function() {
	const $btn = $(this);
	if ($btn.prop("disabled")) return;
	$btn.prop("disabled", true);

	// data-feed-idx가 있는 가장 가까운 컨테이너 찾기
	const $container = $btn.closest("[data-feed-idx]");
	const feed_idx = $container.data("feed-idx");
	const icon = $btn.find("i");
	const likeCountSpan = $container.find(".like-count");

	// feed_idx 못 찾으면 종료
	if (typeof feed_idx === "undefined") {
		console.warn("feed_idx를 찾을 수 없습니다.");
		$btn.prop("disabled", false);
		return;
	}

	const liked = icon.hasClass("clicked");
	const url = liked ? "/feed/deleteFeedLike" : "/feed/addFeedLike";

	// UI 먼저 업데이트
	const currentCount = parseInt(likeCountSpan.text(), 10) || 0;
	if (liked) {
		icon.removeClass("clicked bi-heart-fill").addClass("bi-heart");
		likeCountSpan.text(currentCount - 1);
	} else {
		icon.addClass("clicked bi-heart-fill").removeClass("bi-heart");
		likeCountSpan.text(currentCount + 1);
	}

	// 서버 요청
	$.ajax({
		url: contextPath + url,
		method: "POST",
		contentType: "application/json; charset=UTF-8",
		data: JSON.stringify(feed_idx),
		success: function(res) {
			// 서버에서 최신 좋아요 수를 내려주면 반영
			if (res !== undefined && res !== null && res !== "") {
				likeCountSpan.text(res);
			}
		},
		error: function(xhr) {
			console.error("좋아요 요청 실패:", xhr.status, xhr.responseText);

			// 로그인 안 된 경우에만 로그인 페이지로 이동
			if (xhr.status === 401 || xhr.status === 403) {
				window.location.href = contextPath + "/member/login";
			} else {
				alert("좋아요 처리 중 오류가 발생했습니다.");
			}

			// UI 롤백
			const rollbackCount = parseInt(likeCountSpan.text(), 10) || 0;
			if (liked) {
				icon.addClass("clicked bi-heart-fill").removeClass("bi-heart");
				likeCountSpan.text(rollbackCount + 1);
			} else {
				icon.removeClass("clicked bi-heart-fill").addClass("bi-heart");
				likeCountSpan.text(rollbackCount - 1);
			}
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