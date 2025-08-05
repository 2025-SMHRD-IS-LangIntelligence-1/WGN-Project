const loginUserId = "${member.mb_id}";

$(function() {
	// 탭 클릭 이벤트
	$('.search-tabs .tab').on('click', function(e) {
		e.preventDefault(); // <a href="#"> 기본 동작 막기

		// 1. 모든 탭의 'active' 클래스 제거 → 시각적 효과 초기화
		$('.search-tabs .tab').removeClass('active');

		// 2. 클릭한 탭(this)에만 'active' 클래스 추가
		$(this).addClass('active');

		// 3. 모든 콘텐츠 영역 숨기기
		$('#res-section, #feed-section, #member-section').hide();

		// 4. 클릭한 탭 ID에 따라 해당 콘텐츠 영역만 표시
		if (this.id === 'tab-res') {
			$('#res-section').show(); // 음식점 탭 클릭 시
		} else if (this.id === 'tab-feed') {
			$('#feed-section').show(); // 피드 탭 클릭 시
		} else if (this.id === 'tab-member') {
			$('#member-section').show(); // 사용자 탭 클릭 시
		}
	});
});


// debounce 함수 정의
function debounce(callback, delay) {
	let timer;
	return function(...args) {
		clearTimeout(timer);
		timer = setTimeout(() => {
			callback.apply(this, args);
		}, delay);
	};
}

// 사용자 검색 이벤트 리스너
$('.form-control').on('input', debounce(function() {

	let keyword = $(this).val().trim();

	if (keyword === "") {
		$('#member-section').empty().hide();
		return;
	}

	$.ajax({
		url: contextPath + '/search/member',
		type: 'GET',
		data: { keyword: keyword },
		success: function(memberList) {

			$('.member-header').empty(); // 기존 결과 비우기

			if (memberList.length === 0) {
				$('.member-header').html('<p>검색 결과가 없습니다.</p>').show();
				return;
			}

			memberList.forEach(function(member) {

				const card = `
				    <div class="member-header" data-mb-id="${member.mb_id}" style="cursor:pointer;">
				      <div class="feed-member">
				        <img src="${member.mb_img}" alt="프로필">
				        <div class="member-info">
				          <span><b>${member.mb_nick}</b></span>
				          <span style="font-size: 12px; color: #888;">${member.mb_intro}</span>
				        </div>
				      </div>
				    </div>
				  `
				  
				$('.member-header').append(card);
			});

			$('.member-header').show();
		},
		error: function() {
			console.error("검색 실패");
		}
	});
}, 600));

$(document).off('click').on('click', '.member-header', function() {
  const mbId = $(this).data('mb-id');
  
  console.log(mbId);
  
  if(mbId) {
    window.location.href = contextPath + '/profile/' + mbId;
  }
});
