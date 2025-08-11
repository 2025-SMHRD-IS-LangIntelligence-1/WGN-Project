document.addEventListener('DOMContentLoaded', () => {
    const icons = document.querySelectorAll('.top-bar i');

    icons.forEach(icon => {
        icon.addEventListener('click', () => {
            // 이미 active면 해제, 아니면 active 추가
            icon.classList.toggle('active');
        });
    });
});

function formatDate(isoString) {
    const date = new Date(isoString);
    
    const year = date.getFullYear();
    const month = ('0' + (date.getMonth() + 1)).slice(-2);  // 0~11 → 1~12
    const day = ('0' + date.getDate()).slice(-2);
    const hours = ('0' + date.getHours()).slice(-2);
    const minutes = ('0' + date.getMinutes()).slice(-2);

    return `${year}-${month}-${day} ${hours}:${minutes}`;
}

function timeAgo(isoString) {
    const now = new Date();
    const then = new Date(isoString);
    const diffMs = now - then;

    const seconds = Math.floor(diffMs / 1000);
    const minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    const days = Math.floor(hours / 24);

    if (seconds < 60) return '방금 전';
    if (minutes < 60) return `${minutes}분 전`;
    if (hours < 24) return `${hours}시간 전`;
    if (days < 7) return `${days}일 전`;

    // 일주일 이상이면 날짜 포맷으로
    return formatDate(isoString);
}
