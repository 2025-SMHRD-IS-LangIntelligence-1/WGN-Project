
let fileValid = false;
let contentValid = false;
let resValid = false;

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

// 파일 선택 이벤트 리스너
$('#file-upload').on('change', function() {
	// 선택한 파일 개수 확인
	const fileCount = this.files.length;

	if (fileCount >= 1) {
		fileValid = true;
	} else {
		fileValid = false;
	}

	submitButtonState();
});

// 콘텐츠 작성 이벤트 리스너
$('#feed_content').on('input', function() {
	// 콘텐츠 길이 확인
	const contentLength = this.value.length;

	if (contentLength >= 1) {
		contentValid = true;
	} else {
		contentValid = false;
	}

	submitButtonState();
});


// 음식점 검색 이벤트 리스너
$('.search_input').on('input', debounce(function() {
	let keyword = $(this).val().trim();

	if (keyword === "") {
		$('.search-list').empty().hide();
		return;
	}

	$.ajax({
		url: contextPath + '/search/restaurant',
		type: 'GET',
		data: { keyword: keyword },
		success: function(resInfoList) {

			$('.search-list').empty(); // 기존 결과 비우기

			if (resInfoList.length === 0) {
				$('.search-list').html('<p>검색 결과가 없습니다.</p>').show();
				return;
			}

			resInfoList.forEach(function(res) {

				const invalidThumbnails = ["", "null", "nan", "NaN", "undefined"];

				const thumbnail = (invalidThumbnails.includes(res.res_thumbnail.trim()))
					? 'https://res.cloudinary.com/duyrajdqg/image/upload/v1754354334/free-icon-food-and-restaurant-mega-pack-color-8285335_h1rljq.png'
					: res.res_thumbnail;

				console.log("썸네일 값:", thumbnail, typeof res.res_thumbnail);

				const card = `
                <div class="search-res" data-res-idx="${res.res_idx}">
                    <img src="${thumbnail}" alt="음식 이미지" class="res_thumbnail">
                    <div class="res_info">
                        <h3 class="res_name">${res.res_name}</h3>
                        <p class="res_addr">${res.res_addr}</p>
                        <div class="rating_info">
							<i alt="별" class="bi bi-star"></i>
                            <span class="ratings_text">${res.res_avg_rating || '0.0'}</span>
                        </div>
                    </div>
                </div>`;
				$('.search-list').append(card);
			});

			$('.search-list').show();
		},
		error: function() {
			console.error("검색 실패");
		}
	});
}, 600));


// 음식점 리스트 클릭 이벤트
$(document).on('click', '.search-res', function() {
	console.log("search-res 클릭됨");
	const selectedName = $(this).find('.res_name').text();
	const selectedIdx = $(this).data('res-idx');

	$('#feed_content').val(selectedName);
	$('#selectedResIdx').val(selectedIdx);
	$('.search-list').empty().hide();

	console.log("선택된 res_idx:", selectedIdx);

	resValid = true;
	submitButtonState();
});


// 제출 버튼 상태 업데이트
function submitButtonState() {
	if (fileValid && contentValid && resValid) {
		$('.submit-btn').prop('disabled', false);
	} else {
		$('.submit-btn').prop('disabled', true);
	}
}

// 별점 폼
const ratingForm = document.getElementById('ratingForm');
const stars = document.querySelectorAll('input[name="rating"]');

ratingForm.addEventListener("click", function() {


	stars.forEach(function(star) {
		star.addEventListener('change', function() {
			console.log('선택한 별점:', this.value);
		});
	});
});


