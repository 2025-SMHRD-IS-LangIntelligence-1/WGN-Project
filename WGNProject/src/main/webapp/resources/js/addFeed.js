let fileValid = false;
let contentValid = false;
let resValid = false;

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

    if (contentLength >= 10) {
        contentValid = true;
    } else {
        contentValid = false;
    }

    submitButtonState();
});


$('.search_input').on('input', function () {
    let keyword = $(this).val().trim();

    if (keyword === "") {
        $('#restaurantList').empty().hide();
        return;
    }

    $.ajax({
        url: '/search/restaurant',
        type: 'GET',
        data: { keyword: keyword },
        success: function (resList) {
            $('#.search-list').empty(); // 기존 결과 비우기

            if (resList.length === 0) {
                $('.search-list').html('<p>검색 결과가 없습니다.</p>').show();
                return;
            }

            resList.forEach(function (res) {
                const card = `
                <div class="search-res" data-res-idx="${res.res_idx}">
                    <img src="${res.thumbnail || 'default.jpg'}" alt="음식 이미지" class="res_thumbnail">
                    <div class="res_info">
                        <h3 class="res_name">${res.res_name}</h3>
                        <p class="res_addr">${res.res_addr}</p>
                        <div class="rating_info">
                            <img src="coin-icon.png" alt="별" class="ratings_icon">
                            <span class="ratings_text">${res.avg_rating || '0.0'}</span>
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
});


// 음식점 리스트 클릭 이벤트
$(document).on('click', '.res_info', function () {
    const selectedName = $(this).text();
    const selectedIdx = $(this).data('res_idx');

    $('#feed_content').val(selectedName); // 입력창에 선택한 이름 채우기
    $('#selectedResIdx').val(selectedIdx); // hidden input에 idx 저장
    $('#restaurantList').empty().hide(); // 리스트 감추기

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
