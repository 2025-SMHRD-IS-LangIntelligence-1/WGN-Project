let fileValid = false;
let contentValid = false;
let resValid = false;
let ratingValid = false;
let isDuplicateRes = false;  // 음식점 중복 여부

// 이미지 누적 관리용 배열
let allSelectedFiles = [];

// 디바운스 함수
function debounce(callback, delay) {
	let timer;
	return function (...args) {
		clearTimeout(timer);
		timer = setTimeout(() => callback.apply(this, args), delay);
	};
}


// 파일 선택 시 미리보기 및 유효성 검사

// 파일 선택 시 미리보기 누적

$('#file-upload').on('change', function () {
	const previewContainer = $('#preview-container');
	const newFiles = Array.from(this.files);
	let hasImage = false;

	newFiles.forEach(file => {
		if (file.type.startsWith('image/')) {
			hasImage = true;

			const isDuplicate = allSelectedFiles.some(f => f.name === file.name && f.size === file.size);
			if (!isDuplicate) {
				allSelectedFiles.push(file);

				const img = document.createElement('img');
				img.src = URL.createObjectURL(file);
				img.classList.add('preview-image');
				previewContainer.append(img);
			}
		}
	});

	fileValid = hasImage || allSelectedFiles.length > 0;

	if (fileValid) {
		$('#fileError').hide();
	}

	submitButtonState();
});



// 내용 입력 유효성 검사

// 내용 유효성 체크

$('#feed_content').on('input', function () {
	const content = $(this).val().trim();
	contentValid = content.length > 0;

	if (contentValid) {
		$('#contentError').hide();
	}

	submitButtonState();
});

let selectedRestaurant = null;

// 음식점 검색
$('.search_input').on('input', debounce(function () {
	const keyword = $(this).val().trim();

	if (keyword === "") {
		$('.search-list').empty().hide();
		return;
	}

	$.ajax({
		url: contextPath + '/search/restaurant',
		type: 'GET',
		data: { keyword: keyword },
		success: function (resInfoList) {
			$('.search-list').empty();

			if (resInfoList.length === 0) {
				$('.search-list').html('<p>검색 결과가 없습니다.</p>').show();
				return;
			}

			resInfoList.forEach(res => {
				const invalidThumbnails = ["", "null", "nan", "NaN", "undefined"];
				const thumbnail = invalidThumbnails.includes(res.res_thumbnail?.trim())
					? 'https://res.cloudinary.com/duyrajdqg/image/upload/v1754354334/free-icon-food-and-restaurant-mega-pack-color-8285335_h1rljq.png'
					: res.res_thumbnail;

				const card = `
					<div class="search-res" data-res-idx="${res.res_idx}" data-res-name="${res.res_name}">
						<img src="${thumbnail}" alt="음식 이미지" class="res_thumbnail">
						<div class="res_info">
							<h3 class="res_name">${res.res_name}</h3>
							<p class="res_addr">${res.res_addr}</p>
							<div class="rating_info">
								<i class="bi bi-star"></i>
								<span class="ratings_text">${res.res_avg_rating || '0.0'}</span>
							</div>
						</div>
					</div>
				`;
				$('.search-list').append(card);
			});
			$('.search-list').show();
		},
		error: function () {
			console.error("음식점 검색 실패");
		}
	});
}, 300));



// 음식점 클릭 시 동작

// 음식점 선택 시 동작

$(document).on('click', '.search-res', function () {
	const selectedName = $(this).data('res-name');
	const selectedIdx = $(this).data('res-idx');
	
	// 기존 내용에 #음식점 명 추가
	const currentContent = $('#feed_content').val().trim();
	const newContent = currentContent ? `${currentContent}\n#${selectedName}` : `#${selectedName}`;
	$('#feed_content').val(newContent);
	
	// 선택된 음식점 카드로 대체 + 체크 아이콘 표시
	const selectedCard = $(this).clone();
	selectedCard.append(`
		<div style="margin-left: auto; align-self: center;">
			<img src="https://cdn-icons-png.flaticon.com/512/845/845646.png" width="24" height="24" alt="선택됨">
		</div>
	`);
	$('.search-list').html(selectedCard).show();

	$('.search_input').val(selectedName);

	$('#selectedResIdx').val(selectedIdx);

	$('#resError').hide();
	resValid = true;

	checkFavoriteDuplicate(selectedIdx);  // 중복 체크 추가
	submitButtonState();
});

// 별점 유효성 검사
$('input[name="ratings"]').on('change', function () {
	ratingValid = true;
	$('#ratingError').hide();

	submitButtonState();
});

// 제출 버튼 상태 제어
function submitButtonState() {
	const isAllValid = fileValid && contentValid && resValid && ratingValid && !isDuplicateRes;
	$('.submit-btn').prop('disabled', !isAllValid);
}

console.log(contextPath + '/feed/rescheck')

// 중복 랭킹 체크 AJAX
function checkFavoriteDuplicate(resIdx) {
	$.ajax({
		url: contextPath + '/feed/rescheck',
		type: 'GET',
		data: { res_idx: resIdx },
		success: function (isDuplicate) {
			isDuplicateRes = isDuplicate;

			if (isDuplicateRes) {
				// 중복이면: 스위치 숨기고 문구 보여줌
				$('#rankToggleWrapper').hide();
				$('#duplicateFavoriteMsg').show();
			} else {
				// 중복 아니면: 스위치 보이고 문구 숨김
				$('#rankToggleWrapper').show();
				$('#duplicateFavoriteMsg').hide();
			}

			submitButtonState();  // 다른 조건도 판단할 경우 유지
		},
		error: function () {
			console.error("중복 체크 실패");
			isDuplicateRes = false;

			// 오류 시에도 안전하게 스위치 보이기
			$('#rankToggleWrapper').show();
			$('#duplicateFavoriteMsg').hide();

			submitButtonState();
		}
	});
}



// 최종 제출 시 유효성 체크
$('form').on('submit', function (e) {
	const fileCount = $('#file-upload')[0].files.length;
	const content = $('#feed_content').val().trim();
	const resIdx = $('#selectedResIdx').val().trim();
	const ratingChecked = $('input[name="ratings"]:checked').length > 0;

	let isValid = true;

	if (fileCount === 0 || !fileValid) {
		$('#fileError').show();
		isValid = false;
	}
	if (content === "") {
		$('#contentError').show();
		isValid = false;
	}
	if (resIdx === "") {
		$('#resError').show();
		isValid = false;
	}
	if (!ratingChecked) {
		$('#ratingError').show();
		isValid = false;
	}
	if (isDuplicateRes) {
		$('#duplicateFavoriteMsg').show();
		isValid = false;
	}
	
	if (!isValid) {
		e.preventDefault();
		return;
	}

	// 게시 중 모달 띄우기
	$('#postingModal').fadeIn();

	let fileInput = document.getElementById('file-upload');
	let dataTransfer = new DataTransfer();

	allSelectedFiles.forEach(file => dataTransfer.items.add(file));
	fileInput.files = dataTransfer.files;
});
