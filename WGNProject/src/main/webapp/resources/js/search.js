/* ================== 메뉴 풀 & 슬롯(1릴) 그대로 ================== */
const MENUS = [
  "비빔밥","불고기","김치찌개","돼지국밥","칼국수","냉면","순대국","곰탕","소불고기","닭갈비",
  "짜장면","짬뽕","탕수육","마라탕","마파두부","꿔바로우",
  "초밥","라멘","돈카츠","우동","가라아게","규동",
  "파스타","피자","스테이크","햄버거","리조또","샐러드"
];

let ITEM_H = 92, spinning = false, currentIndex = 0;

function measureItemH() {
  const win = document.querySelector('.reel-window'); if (!win) return;
  const rectH = Math.round(win.getBoundingClientRect().height);
  if (rectH > 0) ITEM_H = rectH;
  $('#reelList li').css('height', ITEM_H + 'px');
}
function applyOffset() {
  const offset = -currentIndex * ITEM_H;
  $('#reelList').css('transform', `translate3d(0, ${Math.round(offset)}px, 0)`);
}
(function initOneReel(){
  const $list = $('#reelList'); if ($list.length === 0) return;
  let html = ''; for (let r=0; r<4; r++){ for (const m of MENUS) html += `<li>${m}</li>`; }
  $list.html(html);
  currentIndex = Math.floor(Math.random()*MENUS.length);
  const reflow = () => { measureItemH(); applyOffset(); };
  requestAnimationFrame(reflow);
  if (document.fonts && document.fonts.ready) { document.fonts.ready.then(reflow).catch(()=>{}); }
})();
window.addEventListener('resize', () => { measureItemH(); applyOffset(); });

const easeOutCubic = t => 1 - Math.pow(1 - t, 3);
function startSlotOneReel(){
  if (spinning) return; const $list = $('#reelList'); if ($list.length===0) return;
  spinning = true; $("#pickedMenu").text("");
  const len = MENUS.length;
  const totalSteps = (3 + Math.floor(Math.random()*2)) * len + Math.floor(Math.random()*len);
  const duration = 2100 + Math.random()*1200;
  const startTime = performance.now(); let lastStep = -1;

  function tick(now){
    const t = Math.min((now - startTime)/duration, 1), step = Math.floor(easeOutCubic(t) * totalSteps);
    if (step !== lastStep){
      lastStep = step; const vIdx = (currentIndex + step) % len;
      $('#reelList').css('transform', `translate3d(0, ${Math.round(-vIdx*ITEM_H)}px, 0)`);
    }
    if (t<1){ requestAnimationFrame(tick); } else {
      currentIndex = (currentIndex + totalSteps) % len;
      const safeText = ($('#reelList li').eq(currentIndex).text() || MENUS[currentIndex]).trim();
      $("#pickedMenu").html(`🧭 오늘은 "<b>${safeText}</b>" 어때요?`);
      const $input = $('.form-control[name="query"]');
      $input.val(safeText).addClass('input-flash'); setTimeout(()=> $input.removeClass('input-flash'), 900);
      applyOffset(); spinning = false;
    }
  }
  requestAnimationFrame(tick);
}
$('#spinBtn').off('click').on('click', startSlotOneReel);


/* ================== 전역 로딩(하나만) ================== */
function showGlobalLoading(){
  hideGlobalLoading();
  $('.search-tabs').after(`
    <div id="global-loading">
      <div class="spinner-border text-warning" role="status"></div>
      <span>불러오는 중...</span>
    </div>
  `);
}
function hideGlobalLoading(){ $('#global-loading').remove(); }

/* ================== 카드 렌더러 ================== */
function renderRes(resList){
  const $res = $('#res-section').empty();
  if (!resList || resList.length===0) {
    $res.html('<p class="text-muted" style="padding:16px 8px;">검색 결과가 없습니다.</p>');
    return;
  }
  resList.forEach(res=>{
    const html = `
      <a href="${contextPath}/restaurant?res_idx=${res.res_idx}"
         class="result-card" aria-label="${res.res_name || ''}">
		 <img src="${res.res_thumbnail && res.res_thumbnail.trim() !== '' 
		     ? res.res_thumbnail 
		     : 'https://cdn-icons-png.flaticon.com/128/17797/17797745.png'}" 
		     class="res-thumb" 
		     alt="썸네일">
        <div class="res-body">
          <h6 class="res-name">${res.res_name || ''}</h6>
          <p class="res-addr">${res.res_addr || ''}</p>
          <div class="res-meta">
            <span class="badge-rating"><i class="bi bi-star-fill"></i> ${res.res_ratings ?? '-'}</span>
          </div>
        </div>
      </a>`;
    $res.append(html);
  });
}

function renderFeed(result){
  const $feed = $('#feed-section').empty();
  const feedIdxList = result?.feedIdxList || [];
  const thumbnailList = result?.thumbnailList || [];
  if (feedIdxList.length===0){
    $feed.html('<p class="text-muted" style="padding:16px 8px;">검색 결과가 없습니다.</p>');
    return;
  }
  const grid = $('<div class="feed-grid"></div>');
  for (let i=0; i<feedIdxList.length; i++){
    const idx = feedIdxList[i], thumb = thumbnailList[i] || '#';
    grid.append(`
      <div class="feed-card" onclick="window.location='${contextPath}/feed?feed_idx=${idx}'">
        <img src="${thumb}" alt="피드 이미지">
      </div>
    `);
  }
  $feed.append(grid);
}

function renderMember(memberList){
  const $member = $('#member-section').empty();
  if (!memberList || memberList.length===0){
    $member.html('<p class="text-muted" style="padding:16px 8px;">검색 결과가 없습니다.</p>');
    return;
  }
  memberList.forEach(m=>{
    $member.append(`
      <div class="member-card" data-mb-id="${m.mb_id}">
        <img class="member-ava" src="${m.mb_img || ''}" alt="@${m.mb_id}">
        <div class="member-info">
          <div class="nick">${m.mb_nick || ''} <span class="id">@${m.mb_id || ''}</span></div>
          <div class="intro">${m.mb_intro || ''}</div>
        </div>
      </div>
    `);
  });
}

/* ================== 탭 전환 (표시만 변경) ================== */
$(function () {
  $('.search-tabs').on('click', '.tab', function (e) {
    e.preventDefault();
    $('.search-tabs .tab').removeClass('active'); $(this).addClass('active');
    const id = this.id;
    $('#res-section, #feed-section, #member-section').hide();
    if (id === 'tab-res') $('#res-section').show();
    else if (id === 'tab-feed') $('#feed-section').show();
    else $('#member-section').show();
  });
});

/* ================== 검색: 3개 섹션 동시 조회 + 전역 로딩 1개 ================== */
let lastSearchToken = 0;

function doSearch(e){
  if (e) e.preventDefault();
  const keyword = $('.form-control[name="query"]').val().trim();

  if (keyword === "") {
    $('#res-section, #feed-section, #member-section').empty().hide();
    $('.search-tabs').hide(); $('#pre-search').show(); hideGlobalLoading();
    return;
  }

  $('#pre-search').hide(); $('.search-tabs').show();
  $('.search-tabs .tab').removeClass('active'); $('#tab-res').addClass('active');
  $('#res-section').show(); $('#feed-section, #member-section').hide();

  const token = ++lastSearchToken;
  showGlobalLoading();

  $.when(
    $.ajax({ url: contextPath + '/search/res',    type:'GET', data:{ query: keyword } }),
    $.ajax({ url: contextPath + '/search/feed',   type:'GET', data:{ query: keyword } }),
    $.ajax({ url: contextPath + '/search/member', type:'GET', data:{ keyword: keyword } })
  ).done(function(resData, feedData, memberData){
    if (token !== lastSearchToken) return; // 오래된 응답 무시
    hideGlobalLoading();
    renderRes(resData[0]);
    renderFeed(feedData[0]);
    renderMember(memberData[0]);
  }).fail(function(){
    if (token !== lastSearchToken) return;
    hideGlobalLoading();
    $('#res-section').html('<p class="text-danger" style="padding:16px 8px;">검색 실패</p>');
  });
}

/* 버튼/엔터 → 검색 */
$('.search-btn').on('click', doSearch);
$('#search-form').on('submit', doSearch);

/* 멤버 카드 클릭 → 프로필로 */
$(document).on('click', '.member-card', function () {
  const mbId = $(this).data('mb-id'); if (mbId) window.location.href = contextPath + '/profile/' + mbId;
});
