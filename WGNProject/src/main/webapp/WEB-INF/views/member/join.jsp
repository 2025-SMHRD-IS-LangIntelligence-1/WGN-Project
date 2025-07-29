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
			<h1>Join</h1>
			<form action="${pageContext.request.contextPath}/member/joinMember" method="post">
				<table>
					<tr>
						<td>아이디</td>
						<td><input type="text" name="member_id"></td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td><input type="text" name="password"></td>
					</tr>
					<tr>
						<td>비밀번호 확인</td>
						<td><input type="text" name="passwordCheck"></td>
					</tr>
					<tr>
						<td>이름</td>
						<td><input type="text" name="name"></td>
					</tr>
					<tr>
						<td>주민등록번호</td>
						<td><input type="text" name="ssn"></td>
					</tr>
					<tr>
						<td>닉네임</td>
						<td><input type="text" name="nickname"></td>
					</tr>
					<tr>
						<td><input type="submit" value="회원가입"></td>
					</tr>
					
				</table>
			</form>
		</div>
		<%@ include file="/WEB-INF/views/common/bottomBar.jsp" %>
	</div>
</body>
</html>