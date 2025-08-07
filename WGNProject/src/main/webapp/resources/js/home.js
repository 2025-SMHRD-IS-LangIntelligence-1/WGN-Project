document.addEventListener("DOMContentLoaded", function () {
    console.log('스크립트 실행됨');

    fetch('/wgn/recommendation/feed', {
        credentials: 'include'
    })
    .then(res => res.json())
    .then(feedIdxList => {
        console.log("추천 받은 feedIdxList:", feedIdxList);

        // 💡 feedIdxList를 POST로 서버에 전달 (리스트 한 번에)
        return fetch('/wgn/feed/previews', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            credentials: 'include',
            body: JSON.stringify(feedIdxList) // 리스트 전체 전송
        });
    })
    .then(res => res.json())
    .then(feedList => {
        console.log("받은 feedList 전체:", feedList);

        feedList.forEach(feed => {
            const postHTML = `
                <div class="post">
                    <div class="post-header">
                        <div class="post-user">
                            <img src="${feed.mb_img || ''}" alt="프로필">
                            <div class="post-user-info">
                                <b>${feed.mb_nick || 'OtherUsers'}</b>
                                <span style="color: #888; font-size: 12px;">${timeAgo(feed.created_at) || '방금 전'}</span>
                            </div>
                        </div>
                        <button class="follow-btn">팔로우</button>
                    </div>
                    <a href="/wgn/feed?feed_idx=${feed.feed_idx}">
                        <div id="carousel-${feed.feed_idx}" class="carousel slide" data-bs-touch="true" data-bs-interval="false">
                            <div class="carousel-inner">
                                ${(feed.imageUrls || []).map((img, idx) => `
                                    <div class="carousel-item ${idx === 0 ? 'active' : ''}">
                                        <img src="${img}" class="d-block w-100" alt="피드 이미지">
                                    </div>
                                `).join('')}
                            </div>
							<button class="carousel-control-prev" type="button" data-bs-target="#carousel-${feed.feed_idx}" data-bs-slide="prev">
							    <span class="carousel-control-prev-icon"></span>
							</button>
							<button class="carousel-control-next" type="button" data-bs-target="#carousel-${feed.feed_idx}" data-bs-slide="next">
							    <span class="carousel-control-next-icon"></span>
							</button>

                        </div>
                    </a>
                    <div class="post-actions">
                        <i class="bi bi-heart"></i>
                        <i class="bi bi-chat ms-3"></i>
                        <span class="stats ms-2">${feed.feed_likes} 좋아요 · ${feed.comment_count || 0} 댓글</span>
                    </div>
                    <div class="location-card" onclick="window.location='restaurant?res_idx=${feed.res_idx}'">
                        <div class="location-info">
                            <b>${feed.res_name || '가게명'}</b> <span>${feed.res_category || '카테고리'}</span>
                        </div>
                        <i class="bi bi-chevron-right"></i>
                    </div>
                    <div class="post-caption">
                        <span class="caption-text">${feed.feed_content}</span>
                        <span class="more-btn" onclick="toggleMore(this)">더보기</span>
                    </div>
                </div>
            `;
            document.getElementById('feed-list').insertAdjacentHTML('beforeend', postHTML);
        });
    })
    .catch(err => {
        console.error("추천 피드 로드 실패:", err);
		const postHTML = `
		    <div class="post">
		        
		    </div>
		`;
		document.getElementById('feed-list').insertAdjacentHTML('beforeend', postHTML);
    });
});
