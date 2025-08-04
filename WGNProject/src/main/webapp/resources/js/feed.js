$(document).ready(() => {
	$(".my-follow-btn").on("click", function (e) {
		e.preventDefault(); // 페이지 이동하지 않게 막음
		
		console.log("팔로우 버튼 눌림")
		
		const followingId = $(this).data('following-id')
		const isFollowed = $(this).data('followed'); // true or false
		
		$.ajax({
			url: contextPath + '/member/follow',
			method: 'post',
			data: { following_id : followingId },
			success: (res) => {
				if (res === "followSuccess") {
					if (isFollowed) { // 만약 팔로잉이 되어 있다면, 버튼을 눌렀을 때
						$(this).text('팔로우'); // 팔로우 버튼으로 바뀜
						$(this).data('followed', false); // follow 여부는 false로 바뀜
						$(this).removeClass('following'); // 팔로잉이라는 클래스 삭제 -> 노란 버튼
					} else { // 팔로우가 되어 있지 않다면, 버튼을 눌렀을 때
						$(this).text('팔로잉'); // 팔로잉 버튼으로 바뀜
						$(this).data('followed', true) // follow 여부는 true로 바뀜
						$(this).addClass('following'); // 팔로잉이라는 클래스 추가 -> 회색
					}
				}
				else if (res === "notLoggedIn") {
					alert("로그인이 필요합니다.");
				}
			}, error: () => {
				alert('팔로우 요청 중 오류 발생');
			}
		});
	});
});
