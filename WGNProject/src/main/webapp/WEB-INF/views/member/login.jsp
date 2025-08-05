<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1">
<title>Home</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/home.css" />
</head>
<body>
		<div class="content">
			<form action="${pageContext.request.contextPath}/member/loginMember" method="post">
				<table>
					<tr>
						<td><input type="text" name="mb_id" placeholder="아이디 입력"></td>
					</tr>
					<tr>
						<td><input type="password" name="mb_pw" placeholder="비밀번호 입력"></td>
					</tr>
					<tr>
						<td><input type="submit" value="로그인"></td>
					</tr>
					<tr>
						<td><a href="${pageContext.request.contextPath}/member/join">회원가입</a></td>
					</tr>
				</table>
			</form>
		</div>
</body>
</html>