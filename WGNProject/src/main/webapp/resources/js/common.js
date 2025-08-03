

$(document).ready(()=>{
	$("#top-bar i").on('click', () => {
		$("#side-bar").toggleClass('active')
	});
});

document.addEventListener('DOMContentLoaded', () => {
    const icons = document.querySelectorAll('#top-bar i');

    icons.forEach(icon => {
        icon.addEventListener('click', () => {
            // 이미 active면 해제, 아니면 active 추가
            icon.classList.toggle('active');
        });
    });
});