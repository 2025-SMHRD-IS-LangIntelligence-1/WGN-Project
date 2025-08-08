$(document).ready(() => {
	
	// 팔로우 버튼
	$(".my-follow-btn").on("click", function(e) {
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
				}
				else if (res === "unfollowSuccess") {
					$btn.text('팔로우').data('followed', false).removeClass('following');
				}
				else if (res === "notLoggedIn") {
					alert("로그인이 필요합니다.");
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

	// 좋아요 버튼
	$(".clickable-heart").on("click", function() {

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
		if (liked) {
			icon.removeClass("clicked bi-heart-fill").addClass("bi-heart");
			likeCountSpan.text(parseInt(likeCountSpan.text()) - 1);
		} else {
			icon.addClass("clicked bi-heart-fill").removeClass("bi-heart");
			likeCountSpan.text(parseInt(likeCountSpan.text()) + 1);
		}

		// 서버 반영
		$.ajax({
			url: contextPath + url,
			method: "POST",
			contentType: "application/json",
			data: JSON.stringify(feed_idx),
			success: function(res) {
				// 서버에서 최신 좋아요 수 반환 시 동기화
				likeCountSpan.text(res);
			},
			error: function() {
				alert("좋아요 처리 중 오류가 발생했습니다.");
				// 실패 시 UI 되돌리기
				if (liked) {
					icon.addClass("clicked bi-heart-fill").removeClass("bi-heart");
					likeCountSpan.text(parseInt(likeCountSpan.text()) + 1);
				} else {
					icon.removeClass("clicked bi-heart-fill").addClass("bi-heart");
					likeCountSpan.text(parseInt(likeCountSpan.text()) - 1);
				}
			},
			complete: function() {
				$btn.prop("disabled", false);
			}
		});

	});
});
