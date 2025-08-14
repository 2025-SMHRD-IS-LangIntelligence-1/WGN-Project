<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1">
<title>Insert title here</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
</head>
<body>
	<%@ include file="/WEB-INF/views/common/sideBar.jsp"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<div class="top-bar">
		<a class="logo" href="<c:url value='/'/>">WGN</a>
		<i class="bi bi-list"></i>
	</div>

	<script>
		const contextPath = '${pageContext.request.contextPath}';
	</script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
	<script>
		
		$(document).ready(()=>{
			$(".top-bar i").on('click', () => {
				$(".side-bar").toggleClass('active')
			});
		});
	</script>

</body>
</html>