// /resources/js/sidebar.js
document.addEventListener('DOMContentLoaded', () => {
	const menuLinks = document.querySelectorAll('.user-menu a');
	const linkLikes = document.querySelector('.user-menu a[data-target="likes"]');
	const linkComments = document.querySelector('.user-menu a[data-target="comments"]');
	const linkReviews = document.querySelector('.user-menu a[data-target="reviews"]');

	let bigModal = document.getElementById('bigModal');
	let bigModalBody = document.getElementById('bigModalBody');
	let bigModalTitle = document.getElementById('bigModalTitle');
	let bigModalClose;

	function ensureModal() {
		if (!bigModal) {
			const wrap = document.createElement('div');
			wrap.innerHTML = `
        <div id="bigModal" class="big-modal" aria-hidden="true" role="dialog" aria-modal="true">
          <div class="big-modal__dialog" role="document">
            <div class="big-modal__header">
              <h3 class="big-modal__title" id="bigModalTitle"></h3>
              <button type="button" class="big-modal__close" aria-label="닫기">&times;</button>
            </div>
            <div class="big-modal__body" id="bigModalBody"></div>
          </div>
        </div>
      `.trim();
			document.body.appendChild(wrap.firstChild);
		}
		bigModal = document.getElementById('bigModal');
		bigModalBody = document.getElementById('bigModalBody');
		bigModalTitle = document.getElementById('bigModalTitle');
		bigModalClose = bigModal.querySelector('.big-modal__close');

		if (!bigModal.dataset.bound) {
			bigModalClose?.addEventListener('click', closeBigModal);
			bigModal.addEventListener('click', (e) => { if (e.target === bigModal) closeBigModal(); });
			document.addEventListener('keydown', (e) => {
				if (e.key === 'Escape' && bigModal.classList.contains('is-open')) closeBigModal();
			});
			bigModal.dataset.bound = '1';
		}
	}

	function openBigModal(title, html) {
		ensureModal();
		bigModalTitle.textContent = title || '';
		bigModalBody.innerHTML = html || '';
		bigModal.classList.add('is-open');
		bigModal.style.display = 'flex';
		bigModal.setAttribute('aria-hidden', 'false');
		document.body.classList.add('modal-lock');
	}

	function closeBigModal() {
		if (!bigModal) return;
		bigModal.classList.remove('is-open');
		bigModal.style.display = 'none';
		bigModal.setAttribute('aria-hidden', 'true');
		document.body.classList.remove('modal-lock');
		menuLinks.forEach(a => a.classList.remove('is-active'));
	}


	linkLikes?.addEventListener('click', (e) => {
		e.preventDefault();
		menuLinks.forEach(a => a.classList.remove('is-active'));
		e.currentTarget.classList.add('is-active');


		fetch(`${contextPath}/sidebar/likes/json`, { method: "GET", credentials: "same-origin" })
			.then(async (res) => {
				if (res.status === 401) {
					openBigModal('피드 좋아요 관리', "<p class='text-danger'>로그인이 필요합니다.</p>");
					return;
				}
				const data = await res.json();
				const html = `
          <div>
            ${data.length === 0 ? `
              <p class="text-muted">좋아요한 피드가 없습니다.</p>
            ` : `
              <div class="liked-feed-grid">
                ${data.map(item => `
                  <a href="${contextPath}/feed?feed_idx=${item.feedIdx}" class="liked-feed-card">
                    <img src="${item.thumbnail}" alt="썸네일" class="liked-feed-thumb">
                  </a>
                `).join('')}
              </div>
            `}
          </div>
        `;
				openBigModal('피드 좋아요 관리', html);
			})
			.catch(err => {
				console.error(err);
				openBigModal('피드 좋아요 관리', "<p class='text-danger'>불러오기에 실패했습니다.</p>");
			});
	});
	// 클릭 시 모달 열고 AJAX로 내 댓글 목록 로드
	linkComments?.addEventListener('click', async (e) => {
		e.preventDefault();
		menuLinks.forEach(a => a.classList.remove('is-active'));
		e.currentTarget.classList.add('is-active');

		openBigModal('마이 댓글 관리', `
      <div class="cmt-modal">
        <div id="cmtList" class="cmt-list">${renderCmtSkeleton(6)}</div>
      </div>
    `);

		try {
			const res = await fetch(`${contextPath}/sidebar/comments/json`, {
				credentials: 'include',
				headers: { 'Accept': 'application/json' }
			});
			if (!res.ok) throw new Error('목록을 불러오지 못했습니다.');
			const items = await res.json();  // [{...}, ...]
			const listEl = document.getElementById('cmtList');
			if (!items || items.length === 0) {
				listEl.innerHTML = `<p class="empty">아직 댓글이 없습니다.</p>`;
				return;
			}
			listEl.innerHTML = items.map(renderCmtItem).join('');
		} catch (err) {
			document.getElementById('cmtList').innerHTML =
				`<p class="text-danger" style="padding:12px;">${err.message}</p>`;
		}
	});

	function renderCmtSkeleton(n) {
		return Array.from({ length: n }).map(() => `
      <div class="cmt-row skel">
        <div class="left">
          <div class="avatar"></div>
          <div class="meta">
            <div class="line w-60"></div>
            <div class="line w-40"></div>
          </div>
        </div>
        <div class="thumb skel-box"></div>
      </div>
    `).join('');
	}

	function renderCmtItem(x) {
		const feedUrl = `${contextPath}/feed?feed_idx=${x.feedIdx}`;
		const when = timeAgo(new Date(x.createdAt));

		return `
      <article class="cmt-card" data-id="${x.commentIdx}">
        <div class="card-top">
          <div class="feed-left">
            <a class="feed-head" href="${feedUrl}">
              <img class="feed-owner-avatar" src="${x.feedMbImg || ''}" alt="">
              <span class="feed-owner-nick">${escapeHtml(x.feedMbNick || '')}</span>
            </a>
            <a class="feed-text" href="${feedUrl}">
              ${escapeHtml(x.feedContent || '')}
            </a>
          </div>
          <a class="feed-thumb" href="${feedUrl}">
            ${x.feedThumbnail ? `<img src="${x.feedThumbnail}" alt="" loading="lazy">` : ''}
          </a>
        </div>

        <!-- 하단: 내가 단 댓글 (링크로 전체 감싸지 않음) -->
        <div class="card-bottom">
          <img class="cmt-avatar" src="${x.mbImg || ''}" alt="">
          <div class="cmt-right">
            <a class="cmt-nick" href="${feedUrl}">${escapeHtml(x.mbNick || x.mbId || '')}</a>

            <!-- 댓글 내용 + 선택 점 한 줄 -->
            <div class="cmt-content-row">
              <a class="cmt-content" href="${feedUrl}">
                ${escapeHtml(x.content || '')}
              </a>
              <button class="cmt-select-dot" type="button" aria-label="select"></button>
            </div>

            <time class="cmt-time">${when}</time>
          </div>
        </div>
      </article>
    `;
	}
	// 상태
	let cmtSelectionMode = false;
	const cmtSelected = new Set();

	// 모달 오픈 시 헤더/하단바 포함해서 렌더
	linkComments?.addEventListener('click', async (e) => {
		e.preventDefault();
		menuLinks.forEach(a => a.classList.remove('is-active'));
		e.currentTarget.classList.add('is-active');

		openBigModal('마이 댓글 관리', `
	    <div class="cmt-modal">
	      <div class="cmt-toolbar">
	        <button id="cmtSelectToggle" class="btn-select">선택</button>
	        <span id="cmtSelectCount" class="select-count"></span>
	      </div>
	      <div id="cmtList" class="cmt-list">${renderCmtSkeleton(6)}</div>

	      <!-- 하단 액션바 (선택 시 노출) -->
	      <div id="cmtActions" class="cmt-actions hidden">
	        <div class="cmt-actions-inner">
	          <span id="cmtActionsCount">0개 선택됨</span>
	          <button id="cmtDeleteBtn" class="btn-danger">삭제</button>
	        </div>
	      </div>
	    </div>
	  `);

		// 데이터 로딩
		try {
			const res = await fetch(`${contextPath}/sidebar/comments/json`, {
				credentials: 'include',
				headers: { 'Accept': 'application/json' }
			});
			if (!res.ok) throw new Error('목록을 불러오지 못했습니다.');
			const items = await res.json();
			const listEl = document.getElementById('cmtList');
			if (!items || items.length === 0) {
				listEl.innerHTML = `<p class="empty">아직 댓글이 없습니다.</p>`;
				return;
			}
			listEl.innerHTML = items.map(renderCmtItem).join('');
			bindCmtEvents(); // 이벤트 바인딩
		} catch (err) {
			document.getElementById('cmtList').innerHTML =
				`<p class="text-danger" style="padding:12px;">${err.message}</p>`;
		}
	});

	function renderCmtItem(x) {
		const feedUrl = `${contextPath}/feed?feed_idx=${x.feedIdx}`;
		const when = timeAgo(new Date(x.createdAt));

		return `
	    <article class="cmt-card" data-id="${x.commentIdx}">
	      <!-- 선택 원 -->
	 

	      <div class="card-top">
	        <div class="feed-left">
	          <a class="feed-head" href="${feedUrl}">
	            <img class="feed-owner-avatar" src="${x.feedMbImg || ''}" alt="">
	            <span class="feed-owner-nick">${escapeHtml(x.feedMbNick || '')}</span>
	          </a>
	          <a class="feed-text" href="${feedUrl}">
	            ${escapeHtml(x.feedContent || '')}
	          </a>
	        </div>
	        <a class="feed-thumb" href="${feedUrl}">
	          ${x.feedThumbnail ? `<img src="${x.feedThumbnail}" alt="" loading="lazy">` : ''}
	        </a>
	      </div>

	      <a href="${feedUrl}" class="card-bottom-link">
	        <div class="card-bottom">
	          <img class="cmt-avatar" src="${x.mbImg || ''}" alt="">
	          <div class="cmt-right">
	            <div class="cmt-nick">${escapeHtml(x.mbNick || x.mbId || '')}</div>
	            <div class="cmt-content">${escapeHtml(x.content || '')}</div>
	            <time class="cmt-time">${when}</time>
				
	          </div>
			  <button class="cmt-select-dot" type="button" aria-label="select"></button>
	        </div>
	      </a>
	    </article>
	  `;
	}

	// 이벤트 위임
	function bindCmtEvents() {
		const modal = document.querySelector('.cmt-modal');
		const listEl = document.getElementById('cmtList');
		const toggleBtn = document.getElementById('cmtSelectToggle');
		const deleteBtn = document.getElementById('cmtDeleteBtn');

		// 선택 모드 토글
		toggleBtn.addEventListener('click', () => {
			cmtSelectionMode = !cmtSelectionMode;
			cmtSelected.clear();
			updateSelectUI();
		});

		// 카드 클릭 처리
		listEl.addEventListener('click', (e) => {
			const card = e.target.closest('.cmt-card');
			if (!card) return;

			// 선택 점(원) 클릭 또는 카드 아무데나 클릭 시(선택모드일 때) 선택 토글
			if (cmtSelectionMode) {
				e.preventDefault();
				const id = card.dataset.id;
				if (cmtSelected.has(id)) cmtSelected.delete(id);
				else cmtSelected.add(id);
				card.classList.toggle('is-selected', cmtSelected.has(id));
				updateSelectUI();
				return;
			}

			// 선택 모드가 아니면 a 링크는 그대로 작동
		});

		// 삭제 클릭
		deleteBtn.addEventListener('click', async () => {
			if (cmtSelected.size === 0) return;
			const ok = await askConfirm(
				'삭제하시겠습니까?',
				`${cmtSelected.size}개 댓글을 삭제합니다. 이 작업은 되돌릴 수 없습니다.`,
				{ okText: '네', cancelText: '아니오' }
			);
			if (!ok) return;

			try {
				// (A) 벌크 삭제 API가 있는 경우
				const res = await fetch(`${contextPath}/sidebar/bulk`, {
					method: 'DELETE',
					credentials: 'include',
					headers: { 'Content-Type': 'application/json' },
					body: JSON.stringify({ ids: Array.from(cmtSelected).map(Number) })
				});

				// (B) 없다면 개별 삭제로 대체
				if (res.status === 404) {
					await Promise.all(Array.from(cmtSelected).map(id =>
						fetch(`${contextPath}/sidebar/${id}`, { method: 'DELETE', credentials: 'include' })
					));
				} else if (!res.ok) {
					throw new Error('삭제에 실패했습니다.');
				}

				// UI에서 제거
				Array.from(cmtSelected).forEach(id => {
					const el = document.querySelector(`.cmt-card[data-id="${id}"]`);
					el?.remove();
				});
				cmtSelected.clear();
				updateSelectUI();

				// 비었으면 빈 상태
				if (!document.querySelector('.cmt-card')) {
					document.getElementById('cmtList').innerHTML =
						`<p class="empty">아직 댓글이 없습니다.</p>`;
				}
			} catch (err) {
				alert(err.message || '삭제 중 오류가 발생했습니다.');
			}
		});
	}

	function updateSelectUI() {
		const list = document.getElementById('cmtList');
		const toggleBtn = document.getElementById('cmtSelectToggle');
		const countEl = document.getElementById('cmtSelectCount');
		const actions = document.getElementById('cmtActions');
		const actionsCount = document.getElementById('cmtActionsCount');

		list.classList.toggle('is-selecting', cmtSelectionMode);
		toggleBtn.textContent = cmtSelectionMode ? '선택 해제' : '선택';
		countEl.textContent = cmtSelectionMode ? `${cmtSelected.size}개 선택됨` : '';
		actions.classList.toggle('hidden', cmtSelected.size === 0);
		actionsCount.textContent = `${cmtSelected.size}개 선택됨`;

		// 선택 표시 초기화
		document.querySelectorAll('.cmt-card').forEach(card => {
			const id = card.dataset.id;
			card.classList.toggle('is-selected', cmtSelected.has(id));
		});
	}

	function askConfirm(title = '삭제하시겠습니까?', message = '', {
		okText = '네', cancelText = '아니오'
	} = {}) {
		return new Promise(resolve => {
			const wrap = document.createElement('div');
			wrap.className = 'confirm-backdrop';
			wrap.innerHTML = `
	      <div class="confirm-dialog" role="dialog" aria-modal="true" aria-labelledby="confirm-title">
	        <h3 id="confirm-title" class="confirm-title">${escapeHtml(title)}</h3>
	        ${message ? `<div class="confirm-message">${escapeHtml(message)}</div>` : ''}
	        <div class="confirm-actions">
			<button type="button" class="btn-danger">${escapeHtml(okText)}</button>
	          <button type="button" class="btn-cancel">${escapeHtml(cancelText)}</button>
	        </div>
	      </div>
	    `;
			document.body.appendChild(wrap);

			const close = (val) => {
				document.removeEventListener('keydown', onKey);
				wrap.remove();
				resolve(val);
			};
			const onKey = (e) => { if (e.key === 'Escape') close(false); };

			document.addEventListener('keydown', onKey);
			wrap.addEventListener('click', (e) => { if (e.target === wrap) close(false); });
			wrap.querySelector('.btn-cancel').addEventListener('click', () => close(false));
			wrap.querySelector('.btn-danger').addEventListener('click', () => close(true));
		});
	}

	function timeAgo(d) {
		const s = Math.floor((Date.now() - d.getTime()) / 1000);
		const m = 60, h = 3600, day = 86400, w = day * 7, mo = day * 30, yr = day * 365;
		if (s < m) return `${s}초`; if (s < h) return `${Math.floor(s / m)}분`;
		if (s < day) return `${Math.floor(s / h)}시간`; if (s < w) return `${Math.floor(s / day)}일`;
		if (s < mo) return `${Math.floor(s / w)}주`; if (s < yr) return `${Math.floor(s / mo)}개월`;
		return `${Math.floor(s / yr)}년`;
	}
	function escapeHtml(str) {
		return String(str).replace(/[&<>"']/g, s => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[s]));
	}

	// ========= 리뷰: 상태 =========
	let rvSelectionMode = false;
	const rvSelected = new Set();

	// ========= 링크 클릭: 리뷰 모달 열기 =========
	linkReviews?.addEventListener('click', async (e) => {
		e.preventDefault();
		menuLinks.forEach(a => a.classList.remove('is-active'));
		e.currentTarget.classList.add('is-active');

		openBigModal('마이 리뷰 관리', `
      <div class="rv-modal">
        <div class="rv-toolbar">
          <button id="rvSelectToggle" class="btn-select">선택</button>
          <span id="rvSelectCount" class="select-count"></span>
        </div>
        <div id="rvList" class="rv-list">${renderRvSkeleton(6)}</div>

        <div id="rvActions" class="rv-actions hidden">
          <div class="rv-actions-inner">
            <span id="rvActionsCount">0개 선택됨</span>
            <button id="rvDeleteBtn" class="btn-danger">삭제</button>
          </div>
        </div>
      </div>
    `);

		// 데이터 로딩
		try {
			const res = await fetch(`${contextPath}/sidebar/reviews/json`, {
				credentials: 'include',
				headers: { 'Accept': 'application/json' }
			});
			if (res.status === 401) {
				document.getElementById('rvList').innerHTML = `<p class="text-danger">로그인이 필요합니다.</p>`;
				return;
			}
			if (!res.ok) throw new Error('목록을 불러오지 못했습니다.');
			const items = await res.json();

			const listEl = document.getElementById('rvList');
			if (!items || items.length === 0) {
				listEl.innerHTML = `<p class="empty">작성한 리뷰가 없습니다.</p>`;
				return;
			}
			listEl.innerHTML = items.map(renderRvItem).join('');
			bindRvEvents();
		} catch (err) {
			document.getElementById('rvList').innerHTML =
				`<p class="text-danger" style="padding:12px;">${err.message}</p>`;
		}
	});

	// ========= 렌더 =========
	function renderRvSkeleton(n) {
		return Array.from({ length: n }).map(() => `
      <article class="rv-card skel">
        <div class="rv-top">
          <div class="rv-left">
            <div class="line w-40"></div>
            <div class="line w-70"></div>
          </div>
          <div class="rv-thumb skel-box"></div>
        </div>
        <div class="rv-bottom">
          <div class="avatar skel-box"></div>
          <div class="meta">
            <div class="line w-40"></div>
          </div>
        </div>
      </article>
    `).join('');
	}

	function renderRvItem(x) {
		const resUrl = `${contextPath}/restaurant?res_idx=${x.resIdx}`;
		const when = timeAgo(new Date(x.createdAt));

		return `
	<article class="rv-card" data-id="${x.reviewIdx}">
	  <div class="rv-top">
	    <div class="rv-left">
	      <a class="rv-head" href="${resUrl}">
	        ${x.mbImg ? `<img class="rv-res-thumb" src="${x.mbImg}" alt="">` : ''}
	        <span class="rv-res-name">${escapeHtml(x.res_name || '')}</span>
	      </a>
	    </div>
		<button class="rv-sel-dot" type="button" aria-label="select"></button>
	  </div>

	  <div class="rv-bottom">
	    <img class="rv-author-avatar" src="${x.reviewMbImg || ''}" alt="">
	    <div class="rv-right">
	      <div class="rv-author">${escapeHtml(x.reviewMbNick || '')}</div>

	      <!-- ⬇️ 텍스트+이미지 한 줄 -->
	      <div class="rv-main">
	        <div class="rv-text">${escapeHtml(x.reviewContent || '')}</div>
	        ${x.review_img ? `
	          <a class="rv-thumb" href="${resUrl}">
	            <img src="${x.review_img}" alt="" loading="lazy">
	          </a>` : ``}
	      </div>

	      <!-- 메타 영역 -->
	      <div class="rv-meta">
	        <time class="rv-time">${when}</time>
	      </div>
	    </div>
	  </div>
	</article>
    `;
	}

	// ========= 이벤트 바인딩 =========
	function bindRvEvents() {
		const listEl = document.getElementById('rvList');
		const toggleBtn = document.getElementById('rvSelectToggle');
		const deleteBtn = document.getElementById('rvDeleteBtn');

		toggleBtn.addEventListener('click', () => {
			rvSelectionMode = !rvSelectionMode;
			rvSelected.clear();
			updateRvSelectUI();
		});

		listEl.addEventListener('click', (e) => {
			const card = e.target.closest('.rv-card');
			if (!card) return;

			if (rvSelectionMode) {
				e.preventDefault();
				const id = card.dataset.id;
				if (rvSelected.has(id)) rvSelected.delete(id); else rvSelected.add(id);
				card.classList.toggle('is-selected', rvSelected.has(id));
				updateRvSelectUI();
				return;
			}
			// 평소에는 링크 동작
		});

		deleteBtn.addEventListener('click', async () => {
			if (rvSelected.size === 0) return;

			const ok = await askConfirm(
				'삭제하시겠습니까?',
				`${rvSelected.size}개 리뷰를 삭제합니다. 이 작업은 되돌릴 수 없습니다.`,
				{ okText: '네', cancelText: '아니오' }
			);
			if (!ok) return;

			try {
				// (A) 벌크 삭제
				const res = await fetch(`${contextPath}/sidebar/reviews/bulk`, {
					method: 'DELETE',
					credentials: 'include',
					headers: { 'Content-Type': 'application/json' },
					body: JSON.stringify({ ids: Array.from(rvSelected).map(Number) })
				});

				// (B) fallback: 단건 삭제
				if (res.status === 404) {
					await Promise.all(Array.from(rvSelected).map(id =>
						fetch(`${contextPath}/reviews/${id}`, { method: 'DELETE', credentials: 'include' })
					));
				} else if (!res.ok) {
					throw new Error('삭제에 실패했습니다.');
				}

				// UI 제거
				Array.from(rvSelected).forEach(id => {
					document.querySelector(`.rv-card[data-id="${id}"]`)?.remove();
				});
				rvSelected.clear();
				updateRvSelectUI();

				if (!document.querySelector('.rv-card')) {
					document.getElementById('rvList').innerHTML = `<p class="empty">작성한 리뷰가 없습니다.</p>`;
				}
			} catch (err) {
				alert(err.message || '삭제 중 오류가 발생했습니다.');
			}
		});
	}

	function updateRvSelectUI() {
		const list = document.getElementById('rvList');
		const toggle = document.getElementById('rvSelectToggle');
		const count = document.getElementById('rvSelectCount');
		const actions = document.getElementById('rvActions');
		const actionsCount = document.getElementById('rvActionsCount');

		list.classList.toggle('is-selecting', rvSelectionMode);
		toggle.textContent = rvSelectionMode ? '선택 해제' : '선택';
		count.textContent = rvSelectionMode ? `${rvSelected.size}개 선택됨` : '';
		actions.classList.toggle('hidden', rvSelected.size === 0);
		actionsCount && (actionsCount.textContent = `${rvSelected.size}개 선택됨`);

		document.querySelectorAll('.rv-card').forEach(card => {
			const id = card.dataset.id;
			card.classList.toggle('is-selected', rvSelected.has(id));
		});
	}

});

// === 사이드바 밖 클릭/ESC로 닫기 (최소 침습) ===
const sideBar = document.querySelector('.side-bar');

function closeSidebarOnly() {
  // 사이드바만 닫기: 기존 로직에 영향 없도록 클래스만 제거
  sideBar?.classList.remove('active');
}

// 빈 화면(사이드바 영역 밖) 클릭 시 닫기
document.addEventListener('click', (e) => {
  if (!sideBar) return;
  if (!sideBar.classList.contains('active')) return;

  // 사이드바 내부 클릭은 무시
  if (sideBar.contains(e.target)) return;

  // 모달(backdrop) 클릭 등 외부 클릭이면 닫기
  closeSidebarOnly();
}, true); // 캡처 단계에서 잡아 깔끔히 처리

// ESC로 닫기 (빅모달과 충돌 없이 동작)
document.addEventListener('keydown', (e) => {
  if (e.key !== 'Escape') return;
  if (!sideBar?.classList.contains('active')) return;
  closeSidebarOnly();
});