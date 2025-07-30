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
					</tr>
					<tr>
						<td><input type="text" name="mb_nick" placeholder="닉네임 입력"></td>
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
	
			<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	
			<!-- 비동기 통신으로 회원가입의 아이디 중복 여부를 체크할 수 있는 기능 -->
			<script type="text/javascript">
				function checkId(){
					
					console.log("checkId 버튼 누름")
					
					// # inputId 라는 id 값의 value를 id 변수에 저장
					let inputId = $('#inputId').val();
					
					// id에 아무 것도 입력하지 않았을 경우 알려주는 조건문
					if (inputId.trim() === "") {
						$("#resultId").text("아이디를 입력해주세요.").css("color", "orange")
					}
					
					$.ajax({
						url : "${pageContext.request.contextPath}/member/checkId", // controller에게 요청
						type : "get",
						data : {inputId : inputId},
						success : (res) => { // controller 메서드의 return 값
							if (res === "true"){
								$("#resultId").text("가입할 수 있는 아이디입니다.").css("color", "green");
							}else {
								$("#resultId").text("이미 존재하는 아이디입니다.").css("color", "red");
							}
						},
						error : (res) => {
							alert("중복 체크 실패");
						}
					}
					);
					
				}
			</script>
</body>
</html>