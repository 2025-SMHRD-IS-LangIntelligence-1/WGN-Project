<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1">
<title>Insert title here</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
	rel="stylesheet">
<link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css'
	rel='stylesheet'>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/join.css" />
</head>
<body>

	<%@ include file="/WEB-INF/views/common/topBar.jsp"%>
	<div class="mobile-container">
		<div class="content">

			<div class="join-wrapper">
				<!-- 뒤로가기 버튼 -->
				<button type="button" class="back-btn"
					onclick="if(history.length>1){history.back()}else{location.href='${pageContext.request.contextPath}/'}">
					<i class="bi-chevron-left"></i>
				</button>
				<div class="join">
					<h1>회원가입</h1>
				</div>
			</div>

			<form action="${pageContext.request.contextPath}/member/joinMember"
				method="post">

				<!-- 이름 입력 -->
				<div class="join-box">
					<div class="form-row">
						<div class="icon-input-wrapper">
							<i class="bx bxs-user"></i>
							<!-- Bootstrap 아이콘 -->
							<input type="text" class="form-input" name="mb_name"
								id="inputName" placeholder="이름 입력" maxlength="20">
						</div>
					</div>

					<!-- 아이디 + 중복체크 -->
					<div class="form-row two-cols">
						<div class="icon-input-wrapper">
							<i class="bx bxs-id-card"></i> <input type="text"
								class="form-input" name="mb_id" id="inputId"
								placeholder="아이디 입력" maxlength="20">
						</div>
						<input type="button" value="중복체크" id="idCheckBtn" disabled>
					</div>

					<!-- 비밀번호 입력 -->
					<div class="form-row">
						<div class="icon-input-wrapper">
							<i class="bx bxs-lock"></i> <input type="password"
								class="form-input" name="mb_pw" id="inputPw"
								placeholder="비밀번호 입력" maxlength="50">
						</div>
					</div>

					<!-- 비밀번호 확인 -->
					<div class="form-row">
						<div class="icon-input-wrapper">
							<i class="bx bxs-lock-open"></i> <input type="password"
								class="form-input" name="mb_pw_check" id="inputPw_check"
								placeholder="비밀번호 확인 입력" maxlength="50">
						</div>
					</div>

					<!-- 닉네임 + 중복체크 -->
					<div class="form-row two-cols">
						<div class="icon-input-wrapper">
							<i class="bx bxs-user-circle"></i> <input type="text"
								class="form-input" name="mb_nick" id="inputNick"
								placeholder="닉네임 입력" maxlength="8">
						</div>
						<input type="button" value="중복체크" id="nickCheckBtn" disabled>
					</div>

					<!-- 메시지 영역 -->
					<div class="form-row resultMsg">
						<span id="checkResult"><span class="msg-text"></span></span>
					</div>
				</div>

				<!-- 회원가입 버튼 -->
				<div class="form-row">
					<input type="submit" value="회원가입" id="joinBtn" disabled>
				</div>

			</form>

			<!-- 모달창 -->


		</div>
		<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>
	</div>

	<script>
		const contextPath = '${pageContext.request.contextPath}';
	</script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/join.js"></script>
</body>
</html>