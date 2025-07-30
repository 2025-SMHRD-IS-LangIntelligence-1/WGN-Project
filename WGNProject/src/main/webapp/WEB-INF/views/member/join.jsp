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
						<br><span id="resultId"></span>
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
	
			<!-- 비동기 통신으로 회원가입의 아이디 중복 여부를 체크할 수 있는 기능 -->
			<script type="text/javascript">
				function checkId(){
					
					// # inputId 라는 id 값의 value를 id 변수에 저장
					let id = $('#inputId').val();
					
					// id에 아무 것도 입력하지 않았을 경우 알려주는 조건문
					if (id.trim() === "") {
						$("#resultId").text("아이디를 입력해주세요.").css("color", "orange")
					}
					
					$.ajax({
						url : "checkId", // controller가 받을 수 있는 요청 값
						type : "get",
						data : {inputId : id},
						success : (res) => {
							// 매개변수 res 의미 : controller의 작업 이후 중복체크 여부에 대한
							// 결과값이 담기는 변수!
							// controller에서 전달해주는 return의 값 => true/false
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