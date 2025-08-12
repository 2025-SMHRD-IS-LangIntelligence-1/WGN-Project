document.addEventListener('DOMContentLoaded', () => {
  // 요소들 직접 잡기
  const sideBar      = document.querySelector('.side-bar');
  const topbarIcon   = document.querySelector('.top-bar i') || document.querySelector('#top-bar i');

  const linkLikes    = document.querySelector('.user-menu a[data-target="likes"]');
  const linkComments = document.querySelector('.user-menu a[data-target="comments"]');
  const linkReviews  = document.querySelector('.user-menu a[data-target="reviews"]');

  const panelLikes    = document.querySelector('.left-panel[data-panel="likes"]');
  const panelComments = document.querySelector('.left-panel[data-panel="comments"]');
  const panelReviews  = document.querySelector('.left-panel[data-panel="reviews"]');
  
  const panels  = document.querySelectorAll('.left-panel');
  const menuLinks = document.querySelectorAll('.user-menu a');

  if (!sideBar) return;

  // 모두 닫기 (단순 버전)
  function closeAllPanels() {
    panelLikes?.classList.remove('show');
    panelComments?.classList.remove('show');
    panelReviews?.classList.remove('show');
  }

  // 하나만 열기
  function openOnly(panel) {
    closeAllPanels();
    panel?.classList.add('show');
  }

  // 각 메뉴에 직접 바인딩
  linkLikes?.addEventListener('click', (e) => {
    e.preventDefault();
    if (panelLikes?.classList.contains('show')) {
      panelLikes.classList.remove('show');
    } else {
      // 사이드바 닫혀있다면 열어두고
      if (!sideBar.classList.contains('active')) sideBar.classList.add('active');
      openOnly(panelLikes);
    }
  });

  linkComments?.addEventListener('click', (e) => {
    e.preventDefault();
    if (panelComments?.classList.contains('show')) {
      panelComments.classList.remove('show');
    } else {
      if (!sideBar.classList.contains('active')) sideBar.classList.add('active');
      openOnly(panelComments);
    }
  });

  linkReviews?.addEventListener('click', (e) => {
    e.preventDefault();
    if (panelReviews?.classList.contains('show')) {
      panelReviews.classList.remove('show');
    } else {
      if (!sideBar.classList.contains('active')) sideBar.classList.add('active');
      openOnly(panelReviews);
    }
  });

  // 상단바 아이콘 클릭 뒤, 사이드바가 닫혀 있으면 패널도 닫기
  topbarIcon?.addEventListener('click', () => {
    // 초보 느낌: rAF 대신 setTimeout(0)
    setTimeout(() => {
      if (!sideBar.classList.contains('active')) {
        closeAllPanels();
      }
    }, 0);
  });

  // 사이드바 바깥 클릭하면 닫기 + 패널 닫기 (간단 click 사용)
  document.addEventListener('click', (e) => {
    if (!sideBar.classList.contains('active')) return;

    const insideSidebar = e.target.closest('.side-bar');
	const insideLeftPanel = e.target.closest('.left-panel'); 
    const onToggleIcon  = e.target.closest('.top-bar i') || e.target.closest('#top-bar i');

    if (insideSidebar || insideLeftPanel || onToggleIcon) return;

    sideBar.classList.remove('active');
    closeAllPanels();
  });

  // ESC로 패널 닫기
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeAllPanels();
  });
  
   function lockBody() {
      if (!document.body.classList.contains('no-scroll')) {
        savedScrollY = window.scrollY || window.pageYOffset || 0;
        document.body.style.top = `-${savedScrollY}px`;
        document.body.classList.add('no-scroll');
      }
    }

    function unlockBody() {
      if (document.body.classList.contains('no-scroll')) {
        document.body.classList.remove('no-scroll');
        document.body.style.top = '';
        window.scrollTo(0, savedScrollY || 0);
      }
    }

    function needLock() {
      const sidebarOpen = !!sideBar && sideBar.classList.contains('active');
      let panelOpen = false;
      panels.forEach(p => { if (p.classList.contains('show')) panelOpen = true; });
      return sidebarOpen || panelOpen;
    }

    function recalcLock() {
      if (needLock()) lockBody(); else unlockBody();
    }

    // 초기 동기화
    recalcLock();

    // 클래스 변화 감지 → 기존 코드 수정 없이 자동 반응
    const observer = new MutationObserver(recalcLock);
    if (sideBar) observer.observe(sideBar, { attributes: true, attributeFilter: ['class'] });
    panels.forEach(p => observer.observe(p, { attributes: true, attributeFilter: ['class'] }));

    // 해시/내비게이션 변화 대비
    window.addEventListener('hashchange', recalcLock);
});
  





