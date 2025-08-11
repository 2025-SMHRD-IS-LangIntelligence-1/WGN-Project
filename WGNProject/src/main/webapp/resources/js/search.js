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

        // 4. 클릭한 탭 ID에 따라 해당 콘텐츠 영역만 표시 및 form action 변경
        if (this.id === 'tab-res') {
            $('#res-section').show(); // 음식점 탭 클릭 시
            $('#searchForm').attr('action', '${pageContext.request.contextPath}/search/res');
        } else if (this.id === 'tab-feed') {
            $('#feed-section').show(); // 피드 탭 클릭 시
            $('#searchForm').attr('action', '${pageContext.request.contextPath}/search/feed');
        } else if (this.id === 'tab-member') {
            $('#member-section').show(); // 사용자 탭 클릭 시
            $('#searchForm').attr('action', '${pageContext.request.contextPath}/search/member');
        }
    });
});

$('.search-btn').on('click', function(e) {
	
	console.log("클릭 함수 실행")
	
    e.preventDefault();

    let keyword = $('.form-control').val().trim();

    if (keyword === "") {
        // 빈 검색어면 결과 숨김
        $('#res-section, #feed-section, #member-section').empty().hide();
        return;
    }

    const activeTabId = $('.tab.active').attr('id'); // 현재 활성 탭 ID
	
    if (activeTabId === 'tab-res') {
		
        // 음식점 검색 AJAX
		$.ajax({
		    url: 'search/res',
		    type: 'GET',
		    data: { query: keyword },
		    success: function(resList) {
		    
                // 음식점 결과 처리
                $('#res-section').empty();
                if (resList.length === 0) {
                    $('#res-section').html('<p>검색 결과가 없습니다.</p>').show();
                    return;
                }
                resList.forEach(function(res) {
					let card = `
					  <a href="/wgn/restaurant?res_idx=${res.res_idx}" class="list-group-item d-flex align-items-center res-card" style="text-decoration:none; color:inherit;">
					    <img src="${res.res_thumbnail}" alt="음식 이미지" class="res_thumbnail">
					    <div class="res-info">
					      <h5 class="res_name">${res.res_name}</h5>
					      <p class="res_addr">${res.res_addr} 북구</p>
					      <div class="rating_info">
						  	<i class="bi bi-star"></i>
					        <span class="ratings_text">${res.res_avg_rating}</span>
					      </div>
					    </div>
					  </a>
					`;
                    $('#res-section').append(card);
                });
                $('#res-section').show();
                // 다른 섹션 숨기기
                $('#feed-section, #member-section').hide();
            },
            error: function() {
                console.error("음식점 검색 실패");
            }
        });
    } else if (activeTabId === 'tab-feed') {
        // 피드 검색 AJAX
        $.ajax({
            url: 'search/feed',
            type: 'GET',
            data: { query: keyword },
            success: function(result) {

				let feedIdxList = result.feedIdxList;
				let thumbnailList = result.thumbnailList;				
				console.log(feedIdxList, thumbnailList);
				
                $('#feed-section').empty();
                if (feedIdxList.length === 0) {
                    $('#feed-section').html('<p>검색 결과가 없습니다.</p>').show();
                    return;
                }
				
				for (let i = 0; i < feedIdxList.length; i += 3) {
				    // 3개씩 자르기
				    let group = feedIdxList.slice(i, i + 3);
				    
				    // feed-image-grid 열기
				    let gridHtml = `<div class="feed-image-grid">`;
				    
				    group.forEach((feedIdx, idx) => {
				        let thumbnail = thumbnailList[i + idx] || '#';
				        gridHtml += `
				            <div class="cell" onclick="window.location='/wgn/feed?feed_idx=${feedIdx}'">
				                <img src="${thumbnail}" alt="대표 이미지">
				            </div>
				        `;
				    });
				    
				    gridHtml += `</div>`;
				    
				    // feed-box에 grid 넣기
				    let boxHtml = `<div class="feed-box">${gridHtml}</div>`;
				    $('#feed-section').append(boxHtml);
				}
                $('#feed-section').show();
                $('#res-section, #member-section').hide();
            },
            error: function() {
                console.error("피드 검색 실패");
            }
        });
    } else if (activeTabId === 'tab-member') {
        // 사용자 검색 AJAX
        $.ajax({
            url: contextPath + '/search/member',
            type: 'GET',
            data: { keyword: keyword },
            success: function(memberList) {
                $('#member-section').empty();
                if (memberList.length === 0) {
                    $('#member-section').html('<p>검색 결과가 없습니다.</p>').show();
                    return;
                }
                memberList.forEach(function(member) {
                    const card = `
                        <div class="member-header" data-mb-id="${member.mb_id}" style="cursor:pointer;">
                            <div class="feed-member">
                                <img src="${member.mb_img}" alt="프로필">
                                <div class="member-info">
                                    <span><b>${member.mb_nick}</b></span>
                                    <span style="font-size: 12px; color: #888;">@${member.mb_id}</span>
                                    <span style="font-size: 12px; color: #888;">${member.mb_intro}</span>
                                </div>
                            </div>
                        </div>
                    `;
                    $('#member-section').append(card);
                });
                $('#member-section').show();
                $('#res-section, #feed-section').hide();
            },
            error: function() {
                console.error("사용자 검색 실패");
            }
        });
    }
});



$(document).off('click').on('click', '.member-header', function() {
  const mbId = $(this).data('mb-id');
  
  console.log(mbId);
  
  if(mbId) {
    window.location.href = contextPath + '/profile/' + mbId;
  }
});
