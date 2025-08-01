<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css" />
</head>
<body>
	<%@ include file="/WEB-INF/views/common/sideBar.jsp"%>

	<div class="top-bar">
		<div class="logo">WGN</div>
		<i class="bi bi-list"></i>
	</div>

	<script>
		const contextPath = '${pageContext.request.contextPath}';
	</script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
    const icons = document.querySelectorAll('.top-bar i');

    icons.forEach(icon => {
        icon.addEventListener('click', () => {
            // 이미 active면 해제, 아니면 active 추가
            icon.classList.toggle('active');
        });
    });
});
</script>
	
</body>
</html>