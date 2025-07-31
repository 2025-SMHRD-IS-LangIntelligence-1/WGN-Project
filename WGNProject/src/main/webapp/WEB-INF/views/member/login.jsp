<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="mobile-container">
		<div class="content">
		<form action="${pageContext.request.contextPath}/member/loginMember" method="post">
				<table>
					<tr>
						<td><input type="text" name="mb_name" placeholder="성 / 이름 입력"></td>
					</tr>
					<tr>
						<td><input type="text" name="mb_id" id="inputId" placeholder="아이디 입력"></td>
						<td><input type="button" value="중복체크" onclick="checkId()" /></td>
					<tr>
						<td>
							<br><span id="resultId"></span>
						</td>
		</div>
		<%@ include file="/WEB-INF/views/common/bottomBar.jsp" %>
	</div>
</body>
</html>