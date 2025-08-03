let fileValid = false;
let contentValid = false;
let resValid = false;

// debounce 함수 정의
function debounce(callback, delay) {
    let timer;
    return function (...args) {
        clearTimeout(timer);
        timer = setTimeout(() => {
            callback.apply(this, args);
        }, delay);
    };
}

// 파일 선택 이벤트 리스너
$('#file-upload').on('change', function () {
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
$('#feed_content').on('input', function () {
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
$('.search_input').on('input', debounce(function () {
    let keyword = $(this).val().trim();

    if (keyword === "") {
        $('.search-list').empty().hide();
        return;
    }

    $.ajax({
        url: contextPath + '/search/restaurant',
        type: 'GET',
        data: { keyword: keyword },
        success: function (resInfoList) {
			
			
            $('.search-list').empty(); // 기존 결과 비우기

            if (resInfoList.length === 0) {
                $('.search-list').html('<p>검색 결과가 없습니다.</p>').show();
                return;
            }

            resInfoList.forEach(function (res) {
				console.log("썸네일 URL 확인:", res.res_thumbnail);
                const card = `
                <div class="search-res" data-res-idx="${res.res_idx}">
                    <img src="${res.res_thumbnail || 'default.jpg'}" alt="음식 이미지" class="res_thumbnail">
                    <div class="res_info">
                        <h3 class="res_name">${res.res_name}</h3>
                        <p class="res_addr">${res.res_addr}</p>
                        <div class="rating_info">
							<img src="coin-icon.png" alt="별" class="ratings_icon">	
                            <span class="ratings_text">${res.res_avg_rating || '0.0'}</span>
                        </div>
                    </div>
                </div>`;
                $('.search-list').append(card);
            });

            $('.search-list').show();
        },
        error: function () {
            console.error("검색 실패");
        }
    });
}, 600));


// 음식점 리스트 클릭 이벤트
$(document).on('click', '.res_info', function () {
    const selectedName = $(this).find('.res_name').text(); // 정확한 텍스트 추출
    const selectedIdx = $(this).data('res-idx');

    $('#feed_content').val(selectedName); // 입력창에 선택한 이름 채우기
    $('#selectedResIdx').val(selectedIdx); // hidden input에 idx 저장
    $('.search-list').empty().hide(); // 리스트 감추기

    resValid = true; // 음식점 선택 유효성 true로 설정
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
