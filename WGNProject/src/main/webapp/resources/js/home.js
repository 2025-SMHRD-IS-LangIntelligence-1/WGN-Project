document.addEventListener("DOMContentLoaded", function () {
    console.log('스크립트 실행됨');
    fetch('/wgn/recommendation/feed', {
        credentials: 'include'
    })
	.then(res => res.json())
	.then(feedIdxList => {
		console.log("응답 데이터 전체:", feedIdxList);
        feedIdxList.forEach(feed_idx => {
            fetch(`/wgn/feed/preview/${feed_idx}`, {
                method: 'GET',
                credentials: 'include'
            })
            .then(res => res.json())
            .then(feed => {
                console.log('받은 feed 데이터:', feed);
                const postHTML = `
                    <div class="post">
                        <div class="post-header">
                            <div class="post-user">
                                <img src="${feed.feed.mb_img || ''}" alt="프로필">
                                <div class="post-user-info">
                                    <b>${feed.feed.mb_nick || 'OtherUsers'}</b>
                                    <span style="color: #888; font-size: 12px;">방금 전</span>
                                </div>
                            </div>
                            <button class="follow-btn">팔로우</button>
                        </div>
                        <a href="/wgn/feed?feed_idx=${feed.feed.feed_idx}">
                            <div id="carousel-${feed.feed.feed_idx}" class="carousel slide" data-bs-touch="true" data-bs-interval="false">
                                <div class="carousel-inner">
                                    ${(feed.feed.imageUrls || []).map((img, idx) => `
                                        <div class="carousel-item ${idx === 0 ? 'active' : ''}">
                                            <img src="${img}" class="d-block w-100" alt="피드 이미지">
                                        </div>
                                    `).join('')}
                                </div>
                                <button class="carousel-control-prev" type="button" data-bs-target="#carousel-${feed.feed.feed_idx}" data-bs-slide="prev">
                                    <span class="carousel-control-prev-icon"></span>
                                </button>
                                <button class="carousel-control-next" type="button" data-bs-target="#carousel-${feed.feed.feed_idx}" data-bs-slide="next">
                                    <span class="carousel-control-next-icon"></span>
                                </button>
                            </div>
                        </a>
                        <div class="post-actions">
                            <i class="bi bi-heart"></i>
                            <i class="bi bi-chat ms-3"></i>
                            <span class="stats ms-2">${feed.feed.feed_likes} 좋아요 · ${feed.comment_count || 0} 댓글</span>
                        </div>
                        <div class="location-card" onclick="window.location='restaurant.html'">
                            <div class="location-info">
                                <b>${feed.resInfo.res_name || '가게명'}</b> <span>${feed.resInfo.res_category || '카테고리'}</span>
                            </div>
                            <i class="bi bi-chevron-right"></i>
                        </div>
                        <div class="post-caption">
                            <span class="caption-text">${feed.feed.feed_content}</span>
                            <span class="more-btn" onclick="toggleMore(this)">더보기</span>
                        </div>
                    </div>
                `;
                document.getElementById('feed-list').insertAdjacentHTML('beforeend', postHTML);
            })
            .catch(err => {
                console.error(`피드 ${feed_idx} 불러오기 실패:`, err);
            });
        });
    })
    .catch(err => {
        console.error("추천 피드 로드 실패:", err);
    });
});
