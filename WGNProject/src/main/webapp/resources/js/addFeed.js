// --- 상태 플래그 ---
let fileValid = false;
let contentValid = false;
let resValid = false;
let ratingValid = false;
let isDuplicateRes = false; // 음식점 랭킹 중복 여부

// 이미지 누적 관리
let allSelectedFiles = [];
const objectUrlMap = new Map(); // fileKey -> objectURL (미리보기 메모리 관리용)

// ===== 유틸 =====
function debounce(callback, delay) {
  let timer;
  return function (...args) {
    clearTimeout(timer);
    timer = setTimeout(() => callback.apply(this, args), delay);
  };
}

function fileKey(file) {
  return `${file.name}__${file.size}__${file.lastModified}`;
}

function escapeRegExp(s) {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function removeHashtag(text, name) {
  const re = new RegExp(`(^|\\s)#${escapeRegExp(name)}(?!\\S)`, 'gm');
  const t = (text || '').replace(re, '$1');
  return t.replace(/[ \t]+\n/g, '\n').replace(/\n{3,}/g, '\n\n').trim();
}

function renderPreviews() {
  const $container = $('#preview-container').empty();

  allSelectedFiles.forEach((f) => {
    const key = fileKey(f);
    let url = objectUrlMap.get(key);
    if (!url) {
      url = URL.createObjectURL(f);
      objectUrlMap.set(key, url);
    }
    const $item = $(`
      <div class="preview-item" data-key="${key}">
        <img src="${url}" class="preview-image" alt="미리보기">
        <button type="button" class="preview-remove" aria-label="이미지 삭제">&times;</button>
      </div>
    `);
    $container.append($item);
  });
}

function syncInputFiles() {
  const dt = new DataTransfer();
  allSelectedFiles.forEach((f) => dt.items.add(f));
  document.getElementById('file-upload').files = dt.files;
}

function submitButtonState() {
  // ⬇️ 중복이어도 제출 가능: isDuplicateRes는 제외
  const isAllValid = fileValid && contentValid && resValid && ratingValid;
  $('.submit-btn').prop('disabled', !isAllValid);
}

// ===== 바인딩 =====
$(function () {
  // 파일 선택(누적) & 미리보기
  $('#file-upload').off('change').on('change', function () {
    const picked = Array.from(this.files);
    picked.forEach((file) => {
      if (!file.type.startsWith('image/')) return;
      const dup = allSelectedFiles.some((f) => fileKey(f) === fileKey(file));
      if (!dup) allSelectedFiles.push(file);
    });

    // 최대 5장 제한
    if (allSelectedFiles.length > 5) {
      allSelectedFiles = allSelectedFiles.slice(0, 5);
    }

    fileValid = allSelectedFiles.length > 0;
    if (fileValid) $('#fileError').hide();

    renderPreviews();
    syncInputFiles();
    submitButtonState();
  });

  // 미리보기 X 버튼으로 삭제
  $(document).on('click', '.preview-remove', function () {
    const $item = $(this).closest('.preview-item');
    const key = $item.data('key');

    const url = objectUrlMap.get(key);
    if (url) {
      URL.revokeObjectURL(url);
      objectUrlMap.delete(key);
    }

    allSelectedFiles = allSelectedFiles.filter((f) => fileKey(f) !== key);
    $item.remove();

    fileValid = allSelectedFiles.length > 0;
    if (!fileValid) $('#fileError').show(); else $('#fileError').hide();

    syncInputFiles();
    submitButtonState();
  });

  // 내용 유효성
  $('#feed_content').on('input', function () {
    const content = $(this).val().trim();
    contentValid = content.length > 0;
    if (contentValid) $('#contentError').hide();
    submitButtonState();
  });

  // 음식점 검색
  let selectedRestaurant = null; // { idx, name }
  const DEFAULT_IMG = 'https://cdn-icons-png.flaticon.com/128/17797/17797745.png';

  $('.search_input').on('input', debounce(function () {
    const keyword = $(this).val().trim();

    if (keyword === '') {
      $('.search-list').empty().hide();
      return;
    }

    $.ajax({
      url: contextPath + '/search/restaurant',
      type: 'GET',
      data: { keyword },
      success: function (resInfoList) {
        const $list = $('.search-list').empty();

        if (!Array.isArray(resInfoList) || resInfoList.length === 0) {
          $list.html('<p style="margin: 0 25px; font-size: 15px; color: #333333;">검색 결과가 없습니다.</p>').show();
          return;
        }

        resInfoList.forEach((res) => {
          const rawThumb = (res.res_thumbnail ?? '').toString().trim();
          const invalid = !rawThumb || ['null', 'nan', 'NaN', 'undefined'].includes(rawThumb);
          const thumbnail = invalid ? DEFAULT_IMG : rawThumb;
          const rating = (res.res_avg_rating ?? '0.0').toString();
          const selected = (selectedRestaurant && String(selectedRestaurant.idx) === String(res.res_idx));

          const card = `
            <div class="search-res ${selected ? 'is-selected' : ''}"
                 data-res-idx="${res.res_idx}" data-res-name="${res.res_name}">
              <img src="${thumbnail}" alt="음식 이미지" class="res_thumbnail"
                   onerror="this.onerror=null;this.src='${DEFAULT_IMG}'">
              <div class="res_info">
                <h3 class="res_name">${res.res_name}</h3>
                <p class="res_addr">${res.res_addr}</p>
                <div class="rating_info">
                  <i class="bi bi-star"></i>
                  <span class="ratings_text">${rating}</span>
                </div>
              </div>
              ${selected ? `
                <div style="margin-left:auto; align-self:center;">
                  <img src="https://cdn-icons-png.flaticon.com/512/845/845646.png" width="24" height="24" alt="선택됨">
                </div>` : ``}
            </div>
          `;
          $list.append(card);
        });

        $list.show();
      },
      error: function () {
        console.error('음식점 검색 실패');
      }
    });
  }, 300));

  // 음식점 선택 토글 (선택 시 본문에 #가게명 미삽입)
  $(document).on('click', '.search-res', function () {
    const name = String($(this).data('res-name') || '');
    const idx = String($(this).data('res-idx') || '');

    // 같은 음식점 다시 클릭 → 선택 해제
    if (selectedRestaurant && selectedRestaurant.idx === idx) {
      selectedRestaurant = null;
      $('#selectedResIdx').val('');

      // 혹시 본문에 해당 해시가 있었다면 제거(이전 저장글 편집 대비)
      const cur = $('#feed_content').val();
      $('#feed_content').val(removeHashtag(cur, name));

      $('.search_input').val('');
      $('.search-list').empty().hide();

      resValid = false;
      isDuplicateRes = false;

      // 랭킹 UI 복구
      $('#rank_toggle').prop('disabled', false).prop('checked', false);
      $('#rankToggleWrapper').show();
      $('#duplicateFavoriteMsg').hide();

      submitButtonState();
      return;
    }

    // 새 선택 (본문에는 아직 태그 넣지 않음)
    selectedRestaurant = { idx, name };
    $('#selectedResIdx').val(idx);

    // 선택 카드 표시
    const selectedCard = $(this).clone();
    selectedCard.addClass('is-selected');
    selectedCard.append(`
      <div style="margin-left:auto; align-self:center;">
        <img src="https://cdn-icons-png.flaticon.com/512/845/845646.png" width="24" height="24" alt="선택됨">
      </div>
    `);
    $('.search-list').html(selectedCard).show();
    $('.search_input').val(name);

    $('#resError').hide();
    resValid = true;

    // 중복 랭킹 체크
    checkFavoriteDuplicate(idx);
    submitButtonState();
  });

  // 별점 유효성
  $('input[name="ratings"]').on('change', function () {
    ratingValid = true;
    $('#ratingError').hide();
    submitButtonState();
  });

  // 중복 랭킹 체크 (중복이어도 제출은 허용)
  function checkFavoriteDuplicate(resIdx) {
    $.ajax({
      url: contextPath + '/feed/rescheck',
      type: 'GET',
      data: { res_idx: resIdx },
      success: function (isDuplicate) {
        isDuplicateRes = !!isDuplicate;

        if (isDuplicateRes) {
          // 랭킹 토글 강제 해제 + 비활성화, 경고 노출
          $('#rank_toggle').prop('checked', false).prop('disabled', true);
          $('#rankToggleWrapper').hide();        // 정책: 중복이면 스위치 숨김
          $('#duplicateFavoriteMsg').show();     // "이미 등록한 음식점입니다."
        } else {
          // 중복 아님: 토글 다시 활성화
          $('#rank_toggle').prop('disabled', false);
          $('#rankToggleWrapper').show();
          $('#duplicateFavoriteMsg').hide();
        }

        submitButtonState();
      },
      error: function () {
        console.error('중복 체크 실패');
        isDuplicateRes = false;
        $('#rank_toggle').prop('disabled', false);
        $('#rankToggleWrapper').show();
        $('#duplicateFavoriteMsg').hide();
        submitButtonState();
      }
    });
  }

  // 최종 제출 (저장 시점에만 #가게명 본문 맨 아래 자동 추가)
  $('form').on('submit', function (e) {
    const fileCount = allSelectedFiles.length; // 누적 기준
    let content = $('#feed_content').val().trim();
    const resIdx = $('#selectedResIdx').val().trim();
    const ratingChecked = $('input[name="ratings"]:checked').length > 0;

    let isValid = true;

    if (fileCount === 0 || !fileValid) {
      $('#fileError').show();
      isValid = false;
    }
    if (content === '') {
      $('#contentError').show();
      isValid = false;
    }
    if (resIdx === '') {
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

    // 저장 시점에만 #가게명 자동 추가 (본문 맨 아래)
    if (selectedRestaurant && selectedRestaurant.name) {
      const tag = `#${selectedRestaurant.name}`;
      const re = new RegExp(`(^|\\s)${escapeRegExp(tag)}(?!\\S)`, 'm'); // 중복 방지
      if (!re.test(content)) {
        content = content.replace(/\s+$/, '');
        if (content.length && !content.endsWith('\n')) content += '\n';
        content += tag;
        $('#feed_content').val(content);
      }
    }

    // input.files 최종 동기화
    syncInputFiles();

    // 게시 중 모달 표시
    $('#postingModal').fadeIn();
  });
});
