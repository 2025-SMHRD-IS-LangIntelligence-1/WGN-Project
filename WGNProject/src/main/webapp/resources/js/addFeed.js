let fileValid = false;
let contentValid = false;
let resValid = false;
let ratingValid = false;

// 이미지 누적 관리용
let allSelectedFiles = [];

function debounce(callback, delay) {
	let timer;
	return function (...args) {
		clearTimeout(timer);
		timer = setTimeout(() => callback.apply(this, args), delay);
	};
}

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
}, 600));

// 음식점 선택 시 동작
$(document).on('click', '.search-res', function () {
	const selectedName = $(this).data('res-name');
	const selectedIdx = $(this).data('res-idx');

	// 기존 내용 유지하면서 줄바꿈 + #음식점명 입력
	const currentContent = $('#feed_content').val().trim();
	const newContent = currentContent ? `${currentContent}\n#${selectedName}` : `#${selectedName}`;
	$('#feed_content').val(newContent);

	// 선택된 음식점 카드만 남기고 ✅ 아이콘 추가
	const selectedCard = $(this).clone();
	selectedCard.append(`
		<div style="margin-left: auto; align-self: center;">
			<img src="https://cdn-icons-png.flaticon.com/512/845/845646.png" width="24" height="24" alt="선택됨">
		</div>
	`);
	$('.search-list').html(selectedCard).show();

	// 검색창엔 음식점 이름만 남김
	$('.search_input').val(selectedName);

	// 숨겨진 input에 res_idx 저장
	$('#selectedResIdx').val(selectedIdx);

	// 에러메시지 제거
	$('#resError').hide();
	resValid = true;

	submitButtonState();
});


// 별점 선택
$('input[name="rating"]').on('change', function () {
	ratingValid = true;
	$('#ratingError').hide();

	submitButtonState();
});

// 제출 버튼 활성화
function submitButtonState() {
	const isAllValid = fileValid && contentValid && resValid && ratingValid;
	$('.submit-btn').prop('disabled', !isAllValid);
}

// 제출 시 최종 유효성 체크
$('form').on('submit', function (e) {
	const fileCount = $('#file-upload')[0].files.length;
	const content = $('#feed_content').val().trim();
	const resIdx = $('#selectedResIdx').val().trim();
	const ratingChecked = $('input[name="rating"]:checked').length > 0;

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

	if (!isValid) {
		e.preventDefault();
		return;
	}

	// 게시 중 모달 띄우기
	$('#postingModal').fadeIn();

	// 누적된 이미지 파일을 다시 input에 넣기
	let fileInput = document.getElementById('file-upload');
	let dataTransfer = new DataTransfer();

	allSelectedFiles.forEach(file => dataTransfer.items.add(file));
	fileInput.files = dataTransfer.files;
});
