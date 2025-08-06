document.addEventListener("DOMContentLoaded", function() {
    fetch('/wgn/recommendation/feed', {
        credentials: 'include'  // 이 부분 추가
    })
    .then(response => {
		if (!response.ok) {
		      // 응답 상태 코드와 상태 텍스트를 던져서 디버깅에 도움 주기
		      throw new Error(`HTTP error! status: ${response.status} ${response.statusText}`);
		    }
		    return response.json();
    })
    .then(data => {
		
    })
    .catch(error => {
        const feedList = document.getElementById('feed-list');
        feedList.innerHTML = `<li>추천 피드 로드 실패: ${error.message}</li>`;
        console.error('추천 피드 로드 중 에러:', error);
    });
});
