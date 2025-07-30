function checkId(){
		
		// # inputId 라는 id 값의 value를 id 변수에 저장
		let inputId = $('#inputId').val();
		
		// id에 아무 것도 입력하지 않았을 경우 알려주는 조건문
		if (inputId.trim() === "") {
			$("#resultId").text("아이디를 입력해주세요.").css("color", "orange")
		}
		
		$.ajax({
			url : contextPath + "/member/checkId", // controller에게 요청
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
	
	function checkNick(){
			
			let inputNick = $('#inputNick').val();
			
			if (inputNick.trim() === "") {
				$("#resultNick").text("닉네임을 입력해주세요.").css("color", "orange")
			}
			
			$.ajax({
				url : contextPath + "/member/checkNick",
				type : "get",
				data : {inputNick : inputNick},
				success : (res) => { 
					if (res === "true"){
						$("#resultNick").text("가입할 수 있는 닉네임입니다.").css("color", "green");
					}else {
						$("#resultNick").text("이미 존재하는 닉네임입니다.").css("color", "red");
					}
				},
				error : (res) => {
					alert("중복 체크 실패");
				}
			}
			);	
		}