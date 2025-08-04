$(document).ready(() => {
	$(".my-follow-btn").on("click", function(e) {
		e.preventDefault(); // 페이지 이동하지 않게 막음

		console.log("팔로우 버튼 눌림")

		const followingId = $(this).data('following-id')
		const isFollowed = $(this).data('followed'); // true or false
		const action = isFollowed ? 'unfollow' : 'follow';
		
		$.ajax({
			url: contextPath + '/member/' + action,
			method: 'post',
			data: { following_id : followingId },
			success: (res) => {
				if (res === "followSuccess") { // 팔로우에 성공할 경우
						$(this).text('팔로잉'); // 팔로잉 버튼으로 바뀜
						$(this).data('followed', true); // follow 여부는 true로 바뀜
						$(this).addClass('following'); // 팔로잉 클래스 추가
						console.log("팔로우 성공");
					}
					else if (res === "unfollowSuccess") { // 언팔로우에 성공할 경우
						$(this).text('팔로우'); // 팔로우 버튼으로 바뀜
						$(this).data('followed', false); // follow 여부는 false로 바뀜
						$(this).removeClass('following'); // 팔로잉 클래스 삭제
						console.log("언팔로우 성공");
					}
					else if (res === "notLoggedIn") {
						alert("로그인이 필요합니다.");
					}
				},
				error: () => {
					alert('팔로우 요청 중 오류 발생');
				}
			});
	});
});
