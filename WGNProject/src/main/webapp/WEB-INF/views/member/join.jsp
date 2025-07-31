<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
						<td><input type="text" name="mb_name" placeholder="성 / 이름 입력"></td>
					</tr>
					<tr>
						<td><input type="text" name="mb_id" id="inputId" placeholder="아이디 입력"></td>
						<td><input type="button" value="중복체크" onclick="checkId()" /></td>
					<tr>
						<td>
							<br><span id="resultId"></span>
						</td>
					</tr>
					<tr>
						<td><input type="text" name="mb_nick" id="inputNick" placeholder="닉네임 입력"></td>
						<td><input type="button" value="중복체크" onclick="checkNick()" /></td>
					</tr>
					<tr>
						<td>
							<br><span id="resultNick"></span>
						</td>
					</tr>
					<tr>
						<td><input type="text" name="mb_pw_check" placeholder="비밀번호 입력"></td>
					</tr>
					<tr>
						<td><input type="password" name="mb_pw" placeholder="비밀번호 확인 입력"></td>
					</tr>
					<tr>
						<td><input type="submit" value="회원가입"></td>
					</tr>
					
				</table>
			</form>
		</div>
		<%@ include file="/WEB-INF/views/common/bottomBar.jsp" %>
	</div>

	<script>
    	const contextPath = '${pageContext.request.contextPath}';
	</script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/eventHandlers.js"></script>
</body>
</html>