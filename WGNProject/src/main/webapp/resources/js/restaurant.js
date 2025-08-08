console.log(res_idx);
console.log(mb_id);


// 탭 이동 + active

document.addEventListener('DOMContentLoaded', function() {
	const sections = document.querySelectorAll('#info-section, #menu-section, #rating-section, #review-section');
	const tabLinks = document.querySelectorAll('.tab-link');
	const tab = document.getElementById("restaurantTabs");
	const tabOffsetTop = tab.offsetTop;
	const scrollOffset = 110; // 상단바 + 탭 메뉴 높이

	// 스크롤 시 탭 활성화
	function updateActiveTab() {
		let current = '';

		sections.forEach((section) => {
			const sectionTop = section.offsetTop;
			if (window.pageYOffset >= sectionTop - scrollOffset) {
				current = section.getAttribute('id');
			}
		});

		tabLinks.forEach((link) => {
			link.classList.remove('active');
			if (link.getAttribute('href') === `#${current}`) {
				link.classList.add('active');
			}
		});
	}

	// 탭 클릭 시 부드럽게 이동 + offset 고려
	tabLinks.forEach(link => {
		link.addEventListener('click', function(e) {
			e.preventDefault();

			const targetId = this.getAttribute('href');
			const targetSection = document.querySelector(targetId);

			if (targetSection) {
				const elementTop = targetSection.getBoundingClientRect().top;
				const offsetTop = window.pageYOffset + elementTop - scrollOffset;

				window.scrollTo({
					top: offsetTop,
					behavior: 'smooth'
				});
			}
		});
	});

	// 스크롤 시 탭 고정
	window.addEventListener("scroll", () => {
		updateActiveTab(); // 탭 활성화도 같이 체크

		if (window.scrollY >= tabOffsetTop - 60) {
			tab.classList.add("fixed");
		} else {
			tab.classList.remove("fixed");
		}
	});
});



//이미지

const images = [];
let currentIndex = 0;

// DOM 로드 후 이미지 수집 및 클릭 이벤트 연결
document.addEventListener('DOMContentLoaded', () => {
	const main = document.querySelector('.main-image');
	const thumbs = document.querySelectorAll('.sub-image');

	// 이미지 URL 추출 함수
	function extractUrl(el) {
		const bg = getComputedStyle(el).backgroundImage;
		const match = bg.match(/url\("?(.+?)"?\)/);
		return match ? match[1] : '';
	}

	// 이미지 배열에 push
	if (main) {
		const url = extractUrl(main);
		images.push(url);
		console.log("✅ 메인 이미지 URL:", url);
	}

	thumbs.forEach((thumb, i) => {
		const url = extractUrl(thumb);
		images.push(url);
		console.log(`✅ 썸네일 ${i + 1} URL:`, url);
	});

	// 이미지 클릭 이벤트 등록
	document.querySelectorAll('.main-image, .sub-image').forEach((img, idx) => {
		img.addEventListener('click', () => openModal(idx));
	});

	// 스와이프 설정
	setupTouchEvents();
});

// 모달 열기
function openModal(index) {
	currentIndex = index;
	console.log("openModal 호출됨 - index:", index, "| 이미지 URL:", images[currentIndex]);
	updateModalImage();
	document.getElementById('imageModal').style.display = 'flex';
	document.body.style.overflow = 'hidden';
}

// 모달 닫기
function closeModal() {
	console.log("모달 닫기");
	document.getElementById('imageModal').style.display = 'none';
	document.body.style.overflow = '';
}

// 이미지 업데이트
function updateModalImage() {
	const imgEl = document.getElementById('modalImageTag');
	const currentUrl = images[currentIndex];
	imgEl.src = currentUrl;
	console.log("모달 이미지 업데이트 - index:", currentIndex, "| URL:", currentUrl);

	document.querySelector('.nav-btn.prev').disabled = currentIndex === 0;
	document.querySelector('.nav-btn.next').disabled = currentIndex === images.length - 1;
}

// 이전 이미지
function prevImage() {
	if (currentIndex > 0) {
		currentIndex--;
		console.log("이전 이미지로 - index:", currentIndex);
		updateModalImage();
	}
}

// 다음 이미지
function nextImage() {
	if (currentIndex < images.length - 1) {
		currentIndex++;
		console.log("다음 이미지로 - index:", currentIndex);
		updateModalImage();
	}
}

// 모바일 터치 스와이프
function setupTouchEvents() {
	const modal = document.getElementById('modalImage');
	let startX = 0;
	let endX = 0;

	modal.addEventListener('touchstart', e => {
		startX = e.touches[0].clientX;
	});

	modal.addEventListener('touchend', e => {
		endX = e.changedTouches[0].clientX;
		handleSwipe();
	});

	function handleSwipe() {
		const diff = endX - startX;
		if (Math.abs(diff) > 50) {
			if (diff > 0) {
				prevImage();
			} else {
				nextImage();
			}
		}
	}
}
const arrow = document.getElementById('toggleArrow');
const fullBox = document.getElementById('fullSchedule');

let isOpen = false;

if (arrow) {
	arrow.addEventListener('click', () => {
		isOpen = !isOpen;
		fullBox.style.display = isOpen ? 'block' : 'none';
		arrow.classList.toggle('bi-chevron-down');
		arrow.classList.toggle('bi-chevron-up');
	});
}



// 리뷰탭
document.querySelectorAll(".review-tab").forEach(button => {
	button.addEventListener("click", () => {
		// 탭 활성화 토글
		document.querySelectorAll(".review-tab").forEach(btn => btn.classList.remove("active"));
		button.classList.add("active");

		// 컨텐츠 보이기 토글
		const targetId = button.getAttribute("data-target");
		document.querySelectorAll(".review-tab-content").forEach(content => {
			content.style.display = "none";
		});
		document.getElementById(targetId).style.display = "block";
	});
});

// 카카오 네이버 더보기
document.addEventListener('DOMContentLoaded', function() {
	const toggleNaverBtn = document.getElementById('toggle-naver');
	const toggleKakaoBtn = document.getElementById('toggle-kakao');

	let naverExpanded = false;
	let kakaoExpanded = false;

	toggleNaverBtn.addEventListener('click', function() {
		const hiddenEls = document.querySelectorAll('.naver-review');
		naverExpanded = !naverExpanded;

		hiddenEls.forEach((el, idx) => {
			if (idx >= 3) {
				el.classList.toggle('d-none', !naverExpanded);
			}
		});

		this.textContent = naverExpanded ? '네이버 리뷰 접기' : '네이버 리뷰 더보기';
	});

	toggleKakaoBtn.addEventListener('click', function() {
		const hiddenEls = document.querySelectorAll('.kakao-review');
		kakaoExpanded = !kakaoExpanded;

		hiddenEls.forEach((el, idx) => {
			if (idx >= 3) {
				el.classList.toggle('d-none', !kakaoExpanded);
			}
		});

		this.textContent = kakaoExpanded ? '카카오 리뷰 접기' : '카카오 리뷰 더보기';
	});
});

// 사용자 리뷰 더보기
document.addEventListener("DOMContentLoaded", function() {
	const toggleUserBtn = document.getElementById("toggle-user");

	let userExpanded = false;

	if (toggleUserBtn) {
		toggleUserBtn.addEventListener("click", function() {
			const hiddenEls = document.querySelectorAll(".user-review");
			userExpanded = !userExpanded;

			hiddenEls.forEach((el, idx) => {
				if (idx >= 3) {
					el.classList.toggle("d-none", !userExpanded);
				}
			});

			this.textContent = userExpanded ? "사용자 리뷰 접기" : "사용자 리뷰 더보기";
		});
	}
});

// 리뷰작성 토글
document.addEventListener('DOMContentLoaded', function() {
	const toggleBtn = document.getElementById('toggleReviewBtn');
	const form = document.getElementById('reviewFormContainer');

	toggleBtn.addEventListener('click', function() {
		form.style.display = form.style.display === 'none' ? 'block' : 'none';
		if (form.style.display === 'block') {
			form.scrollIntoView({ behavior: 'smooth' });
		}
	});
});


// 리뷰 이미지
function openImageModal(imgUrl) {
	const modal = document.getElementById("reviewImageModal");
	const modalImg = document.getElementById("modalImage");
	modalImg.src = imgUrl;
	modal.style.display = "flex";
}

function closeImageModal() {
	document.getElementById("reviewImageModal").style.display = "none";
}

// 모달 배경 클릭 시 닫기
document.getElementById("reviewImageModal").addEventListener("click", function(e) {
	// 이미지나 버튼을 클릭한 경우는 무시
	if (e.target === this) {
		this.style.display = "none";
	}
});

// 리뷰 작성
const ratingError = document.getElementById("ratingError");
const contentError = document.getElementById("contentError");
const ratingInputs = document.querySelectorAll('input[name="ratings"]');
const reviewContent = document.getElementById("reviewContent");

// 별점 선택 시 에러 숨김
ratingInputs.forEach(input => {
	input.addEventListener("change", () => {
		ratingError.style.display = "none";
	});
});

// 리뷰 작성 시 에러 숨김
reviewContent.addEventListener("input", () => {
	if (reviewContent.value.trim() !== "") {
		contentError.style.display = "none";
	}
});

console.log('요청할 URL:', contextPath + "/feed/rescheck?res_idx=" + res_idx);
console.log(contextPath)
console.log(res_idx)

// 중복 랭킹 체크 
// 페이지 로딩 시 자동 실행
$(document).ready(function () {
    if (typeof res_idx !== 'undefined' && res_idx) {
        console.log("페이지 로드 후 중복 랭킹 체크 실행:", res_idx, mb_id);
        checkFavoriteDuplicate(res_idx);
    } else {
        console.warn("res_idx 또는 mb_id 값이 없어 중복 랭킹 체크를 실행하지 않음");
    }
});

// 중복 랭킹 체크
function checkFavoriteDuplicate(res_idx) {
    $.ajax({
        url: contextPath + "/feed/rescheck",
        type: 'GET',
        data: { res_idx: res_idx},
        success: function (isDuplicate) {
            isDuplicateRes = isDuplicate;
            console.log("isDuplicateRes:", isDuplicateRes);

            if (isDuplicateRes) {
                $('#rankToggleWrapper').hide();
                $('#duplicateFavoriteMsg').show();
            } else {
                $('#rankToggleWrapper').show();
                $('#duplicateFavoriteMsg').hide();
            }

            submitButtonState?.(); // 안전하게 호출
        },
        error: function (xhr, status, err) {
            console.error("중복 체크 실패:", status, err);
            isDuplicateRes = false;

            $('#rankToggleWrapper').show();
            $('#duplicateFavoriteMsg').hide();

            submitButtonState?.();
        }
    });
}


// 제출 시 유효성 검사
document.getElementById("reviewForm").addEventListener("submit", function(e) {
	const ratingChecked = document.querySelector('input[name="ratings"]:checked');
	const content = reviewContent.value.trim();

	let isValid = true;

	if (!ratingChecked) {
		ratingError.style.display = "block";
		isValid = false;
	}

	if (content === "") {
		contentError.style.display = "block";
		isValid = false;
	}

	if (!isValid) {
		e.preventDefault();
	}
});

// 지도구현
var map;

function toggleMap() {
	const mapSection = document.getElementById("map-section");
	const toggleBtn = document.getElementById("mapToggleBtn");

	if (mapSection.style.display === "none") {
		mapSection.style.display = "block";
		toggleBtn.innerText = "지도 접기";

		// 중심 좌표
		var center = new kakao.maps.LatLng(reslat, reslon);

		// 지도 생성
		map = new kakao.maps.Map(document.getElementById('map'), {
			center: center,
			level: 1
		});

		// 마커 생성
		var marker = new kakao.maps.Marker({
			position: center,
			map: map
		});

	} else {
		mapSection.style.display = "none";
		toggleBtn.innerText = "지도 보기";
	}
}


// 찜
document.addEventListener("DOMContentLoaded", function () {
	const tooltip = document.getElementById("iconTooltip");
	const closeBtn = document.querySelector(".close-tooltip");
	const iconGroup = document.getElementById("restaurantIconGroup");
	const iconElements = iconGroup.querySelectorAll(".icon-outline");

	// const res_idx = iconGroup.dataset.resIdx;
	// const mb_id = iconGroup.dataset.mbId;

	// 로그인 여부 확인
	if (!mb_id) {
		if (tooltip) {
			tooltip.style.display = "block";
			setTimeout(() => tooltip.style.display = "none", 3000);
		}
		return;
	}

	// 최초 진입 시 찜 여부 확인하여 아이콘 상태 설정
	fetch(`${contextPath}/going/check`, {
		method: "POST",
		headers: {
			"Content-Type": "application/x-www-form-urlencoded"
		},
		body: `res_idx=${res_idx}&mb_id=${mb_id}`
	})
	.then(res => res.json())
	.then(data => {
		if (data.isGoing) {
			iconElements.forEach(icon => icon.classList.add("active"));

			// 이미 찜한 경우 → 말풍선 숨김
			if (tooltip) {
				tooltip.style.display = "none";
			}
		} else {
			// 찜 안한 경우 → 말풍선 보여주기
			if (tooltip) {
				tooltip.style.display = "block";
				setTimeout(() => tooltip.style.display = "none", 3000);
			}
		}
	});

	// 아이콘 클릭 이벤트
	iconGroup.addEventListener("click", function () {
		if (!mb_id) {
			alert("로그인이 필요합니다.");
			return;
		}

		console.log("클릭한 res_idx:", res_idx);
		console.log("현재 로그인 사용자:", mb_id);

		// 상태 확인 후 등록 or 삭제
		fetch(`${contextPath}/going/check`, {
			method: "POST",
			headers: {
				"Content-Type": "application/x-www-form-urlencoded"
			},
			body: `res_idx=${res_idx}&mb_id=${mb_id}`
		})
		.then(res => res.json())
		.then(data => {
			const isGoing = data.isGoing;
			const url = isGoing ? `${contextPath}/going/delete` : `${contextPath}/going/insert`;
			const method = isGoing ? "DELETE" : "POST";

			console.log(isGoing ? "삭제 요청" : "등록 요청");

			return fetch(`${url}?res_idx=${res_idx}&mb_id=${mb_id}`, { method });
		})
		.then(res => res.json())
		.then(result => {
			if (result.success) {
				console.log("요청 성공");
				iconElements.forEach(icon => icon.classList.toggle("active"));
			} else {
				console.warn("❌ 요청 실패:", result);
				alert("요청 실패");
			}
		})
		.catch(err => {
			console.error("오류 발생:", err);
			alert("요청 처리 중 오류 발생");
		});
	});
});