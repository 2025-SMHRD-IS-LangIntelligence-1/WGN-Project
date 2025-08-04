let nameValid = false;
let idValid = false;
let nickValid = false;
let pwValid = false;

// debounce 함수 정의
function debounce(callback, delay) {
    let timer;
    return function (...args) {
        clearTimeout(timer);
        timer = setTimeout(() => {
            callback.apply(this, args);
        }, delay);
    };
}

// 이름 유효성 체크
$('#inputName').on('input', debounce(function () {

	$("#checkResult").text(""); // 메시지 초기화 
	
    let inputName = $(this).val();
    let filtered = inputName.replace(/[^가-힣]/g, '');  // 정규표현식으로 한글만 가능하게 제약

    if (inputName !== filtered) {
		$('#inputName').val(filtered);
        $("#checkResult").text("이름은 한글만 입력할 수 있습니다.");
		nameValid = false;
    } else if (filtered.length < 2) {
        $("#checkResult").text("이름은 2자 이상 입력해주세요.");
		nameValid = false;
    } else {
        $("#checkResult").text("사용할 수 있는 이름입니다.");  
        nameValid = true;
    }

    updateJoinButtonState(); // 버튼 활성화 여부 체크
}, 400));


$('#inputId').on('input', debounce(function () {
    $("#checkResult").text(""); // 메시지 초기화 

    let inputId = $('#inputId').val();
    let filtered = inputId.replace(/[^a-zA-Z0-9]/g, '');  // 영문 숫자만 허용
    
    if (inputId !== filtered) {
        $('#inputId').val(filtered);
        $("#checkResult").text("아이디는 영문과 숫자만 사용할 수 있습니다.");
        idValid = false;
        $('#idCheckBtn').prop('disabled', true);
    } else if (inputId.trim() === "") {
        $("#checkResult").text("아이디를 입력해주세요.");
        idValid = false;
        $('#idCheckBtn').prop('disabled', true);
    } else if (inputId.length >= 8 && inputId.length <= 20) {
        $("#checkResult").text("아이디 중복검사를 해 주세요.");
        idValid = false;
        $('#idCheckBtn').prop('disabled', false);
    } else {
        $("#checkResult").text("아이디는 8자 이상 20자 이하로 입력해주세요.");
        idValid = false;
        $('#idCheckBtn').prop('disabled', true);
    }

    updateJoinButtonState();
}, 400));

// 중복검사 버튼 클릭 시 실제 중복 체크 함수 호출
$('#idCheckBtn').on('click', function() {
    checkId();
});

// 닉네임 유효성 체크
$('#inputNick').on('input', debounce(function () {
    nickValid = false;       
    $("#checkResult").text("");

    let inputNick = $('#inputNick').val();
    let filtered = inputNick.replace(/[^A-Z가-힣0-9]/g, ''); // 한글과 숫자만 허용

    if (inputNick !== filtered) {
        $('#inputNick').val(filtered);
        $("#checkResult").text("닉네임은 영어, 한글과 숫자만 사용할 수 있습니다.");
        nickValid = false;
        $('#nickCheckBtn').prop('disabled', true);
    } else if (inputNick.trim() === "") {
        $("#checkResult").text("닉네임을 입력해주세요.");
        nickValid = false;
        $('#nickCheckBtn').prop('disabled', true);
    } else if (inputNick.length < 2 || inputNick.length > 8) {
        $("#checkResult").text("닉네임은 2자 이상 8자 이하로 입력해주세요.");
        nickValid = false;
        $('#nickCheckBtn').prop('disabled', true);
    } else {
        $("#checkResult").text("닉네임 중복 검사를 해 주세요."); 
        nickValid = false;
        $('#nickCheckBtn').prop('disabled', false);
    }

    updateJoinButtonState(); 
}, 400));

// 닉네임 중복 검사 버튼 클릭 시 중복검사 함수 호출
$('#nickCheckBtn').on('click', function() {
    checkNick();
});


// 비밀번호 유효성 체크
$('#inputPw, #inputPw_check').on('input', debounce(function () {
    pwValid = false;
    $("#checkResult").text("");

    let inputPw = $('#inputPw').val();
    let inputPw_check = $('#inputPw_check').val();

    // 영문/숫자만 필터링
    let filteredPw = inputPw.replace(/[^a-zA-Z0-9]/g, '');
    let filteredPw_check = inputPw_check.replace(/[^a-zA-Z0-9]/g, '');

	if (inputPw.trim() === '') {
	   $("#checkResult").text("비밀번호를 입력해주세요.");
	} else if (inputPw.length < 8) {
	    $("#checkResult").text("비밀번호는 8자 이상 입력해주세요.");
    } else if (inputPw !== filteredPw) {
        $('#inputPw').val(filteredPw);
        $("#checkResult").text("비밀번호는 영문과 숫자만 사용할 수 있습니다.");
    } else if (inputPw_check !== filteredPw_check) {
        $('#inputPw_check').val(filteredPw_check);
        $("#checkResult").text("비밀번호 확인은 영문과 숫자만 사용할 수 있습니다.");
    } else if (inputPw_check.trim() === '') {
        $("#checkResult").text("비밀번호 확인을 입력해주세요.");
    } else if (inputPw !== inputPw_check) {
        $("#checkResult").text("비밀번호가 일치하지 않습니다.");
    } else {
        $("#checkResult").text("비밀번호가 일치합니다.");
        pwValid = true;
    }

    updateJoinButtonState();
}, 400));


// 아이디 중복 검사
function checkId() {
    
	let inputId = $('#inputId').val();
	
    $.ajax({
        url: contextPath + "/member/checkId",
        type: "get",
        data: { inputId: inputId },
        success: (res) => {
			
			if (inputId.trim() === "") {
				$("#checkResult").text("아이디를 입력해주세요.");
				nickValid = false;
			} else if (res === "true") {
                $("#checkResult").text("가입할 수 있는 아이디입니다.");
                idValid = true;
            } else {
                $("#checkResult").text("이미 존재하는 아이디입니다.");
                idValid = false;
            }
            updateJoinButtonState();
        },
        error: (res) => {
            alert("중복 체크 실패");
        }
    });
}

// 닉네임 중복 검사
function checkNick() {

	let inputNick = $('#inputNick').val();

    // 중복 체크 Ajax 호출
    $.ajax({
        url: contextPath + "/member/checkNick",
        type: "get",
        data: { inputNick: inputNick },
        success: (res) => {
			
			if (inputNick.trim() === "") {
				$("#checkResult").text("닉네임을 입력해주세요.");
				nickValid = false;
            } else if (res === "true") {
                $("#checkResult").text("가입할 수 있는 닉네임입니다.");
                nickValid = true;
            } else {
                $("#checkResult").text("이미 존재하는 닉네임입니다.");
                nickValid = false;
            }
            updateJoinButtonState();
        },
        error: () => {
            alert("중복 체크 실패");
        }
    });
}


// 회원가입 버튼 상태 업데이트
function updateJoinButtonState() {
    if (nameValid && idValid && nickValid && pwValid) {
        $('#joinBtn').prop('disabled', false);
    } else {
        $('#joinBtn').prop('disabled', true);
    }
}