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

			feeds.forEach(feed => {
				
				console.log(feed.imageUrls);
				
				const isFollowing = followingMemList.includes(feed.mb_id);
				const isLiked = likedFeedList.includes(feed.feed_idx);

				const followButtonHTML = isFollowing
					? `<button class="my-follow-btn following" data-following-id="${feed.mb_id}" data-followed="true">팔로잉</button>`
					: `<button class="my-follow-btn" data-following-id="${feed.mb_id}" data-followed="false">팔로우</button>`;

				const heartIconClass = isLiked ? 'bi-heart-fill clicked' : 'bi-heart';

				const postHTML = `
				<div class="post">
					<div class="post-header">
					<a href="/wgn/profile/${feed.mb_id}" class="post-user" style="display: flex; align-items: center; text-decoration: none; color: inherit;">
					  <img src="${feed.mb_img || ''}" alt="프로필">
					  <div class="post-user-info">
					    <b>${feed.mb_nick || 'OtherUsers'}</b>
					    <span style="color: #888; font-size: 12px;">${timeAgo(feed.created_at) || '방금 전'}</span>
					  </div>
					</a>

						${followButtonHTML}
					</div>
					<a href="/wgn/feed?feed_idx=${feed.feed_idx}">
						<div id="carousel-${feed.feed_idx}" class="carousel slide" data-bs-touch="true" data-bs-interval="false">
							<div class="carousel-inner">
								${(feed.imageUrls || []).map((img, idx) => `
									<div class="carousel-item ${idx === 0 ? 'active' : ''}">
										<img src="${img}" class="d-block w-100" alt="피드 이미지">
									</div>
								`).join('')}
							</div>
							<button class="carousel-control-prev" type="button" data-bs-target="#carousel-${feed.feed_idx}" data-bs-slide="prev">
								<span class="carousel-control-prev-icon"></span>
							</button>
							<button class="carousel-control-next" type="button" data-bs-target="#carousel-${feed.feed_idx}" data-bs-slide="next">
								<span class="carousel-control-next-icon"></span>
							</button>
						</div>
					</a>
					<div class="post-actions" data-feed-idx="${feed.feed_idx}">
						<span class="clickable-heart"><i class="bi ${heartIconClass}"></i></span>
						<i class="bi bi-chat ms-3"></i>
						
						<span class="like-count stats ms-2">${feed.feed_likes}</span>
						<span class="stats ms-2">좋아요  · </span>
						<span class="stats ms-2">${feed.comment_count || 0}</span>
						<span class="stats ms-2">댓글</span>
					</div>
					<div class="location-card" onclick="window.location='restaurant?res_idx=${feed.res_idx}'">
						<div class="location-info">
							<b>${feed.res_name || '가게명'}</b> <span>${feed.res_category || '카테고리'}</span>
						</div>
						<i class="bi bi-chevron-right"></i>
					</div>
					<div class="post-caption">
					  <span class="caption-text collapsed">${feed.feed_content}</span>
					  <span class="more-btn" onclick="toggleMore(this)">더보기</span>
					</div>

				</div>
			`;

				document.getElementById('feed-list').insertAdjacentHTML('beforeend', postHTML);
			});
		})
		.catch(err => {
			console.error("추천 피드 로드 실패:", err);
		});
});

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
	const caption = btn.previousElementSibling; // .caption-text 요소
	if (caption.classList.contains('collapsed')) {
		// 현재 접힌 상태 -> 펼치기
		caption.classList.remove('collapsed');
		btn.textContent = '접기';
	} else {
		// 현재 펼친 상태 -> 접기
		caption.classList.add('collapsed');
		btn.textContent = '더보기';
	}
}