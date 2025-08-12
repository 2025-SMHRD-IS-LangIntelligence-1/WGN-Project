<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1">
<title>login</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css?v=${now.time}" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/home.css?v=2" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/login.css" />
</head>
<body>


	<%@ include file="/WEB-INF/views/common/topBar.jsp"%>

	<div class="mobile-container">
		<div class="content">
			<div class="login">
				<h1>로그인</h1>
			</div>

			<form action="${pageContext.request.contextPath}/member/loginMember"
				method="post">

				<div class=login_box>
					<!-- CSRF 토큰 (Spring Security 사용 시) -->
					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />

					<!-- 아이디 입력 -->
					<div class="input-id">
						<input type="text" name="mb_id" class="form-input"
							placeholder="아이디 입력" autocomplete="off">
					</div>

					<!-- 비밀번호 입력 -->
					<div class="input-pw">
						<input type="password" name="mb_pw" class="form-input"
							placeholder="비밀번호 입력" autocomplete="off">
					</div>

					<c:if test="${not empty loginErrorMsg or param.error == '1'}">
						<div class="text-danger mt-2">아이디와 비밀번호를 확인해주세요.</div>
					</c:if>


				</div>

				<!-- 로그인 버튼 -->
				<div class="form-group">
					<input type="submit" value="로그인">
				</div>

				<!-- 아이디/비밀번호 찾기 링크 -->
				<div class="my-form-links">
					<a href="${pageContext.request.contextPath}/member/findId">아이디
						찾기</a> | <a href="${pageContext.request.contextPath}/member/findPw">비밀번호
						찾기</a>
				</div>

				<!-- 회원가입 링크 -->
				<div class="form-links">
					게시글과 마이페이지를 이용하고 싶다면? <a
						href="${pageContext.request.contextPath}/member/join">회원가입</a>
				</div>

			</form>
		</div>
		<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>

	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</body>
</html>