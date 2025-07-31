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
    let inputName = $(this).val();
    let filtered = inputName.replace(/[^가-힣]/g, '');  // 정규표현식으로 한글만 가능하게 제약

    if (inputName !== filtered) {
        $("#checkResult").text("이름은 한글만 입력할 수 있습니다.");
        nameValid = false;
    } else if (filtered.length < 2) {
        $("#checkResult").text("이름은 2자 이상 입력해주세요.");
        nameValid = false;
    } else {
        $("#checkResult").text("");  // 정상일 경우 메시지 제거
        nameValid = true;
    }

    updateJoinButtonState(); // 버튼 활성화 여부 체크
}, 400));


// 아이디 입력값이 바뀌면 idValid 초기화 후 버튼 활성화 여부 체크
$('#inputId').on('input', debounce(function () {
    idValid = false;
    $("#checkResult").text(""); // 메시지 초기화 
    updateJoinButtonState();
}, 400));

// 닉네임 입력값이 바뀌면 nickValid 초기화 후 버튼 활성화 여부 체크
$('#inputNick').on('input', debounce(function () {
    nickValid = false;
    $("#checkResult").text(""); // 메시지 초기화
    updateJoinButtonState();
}, 400));

// 비밀번호 유효성 체크
$('#inputPw, #inputPw_check').on('input', debounce(function () {
    pwValid = false;               // 초기화
    $("#checkResult").text("");   // 메시지 초기화

    let inputPw = $('#inputPw').val();
    let inputPw_check = $('#inputPw_check').val();

    // 영문/숫자만 필터링
    let filteredPw = inputPw.replace(/[^a-zA-Z0-9]/g, '');
    let filteredPw_check = inputPw_check.replace(/[^a-zA-Z0-9]/g, '');

    // 입력값에 허용 문자 외 포함 시 필터링된 값으로 교체 후 메시지 출력 및 종료
    if (inputPw !== filteredPw) {
        $('#inputPw').val(filteredPw);
        $("#checkResult").text("비밀번호는 영문과 숫자만 사용할 수 있습니다.");
        updateJoinButtonState();
        return;
    }

    if (inputPw_check !== filteredPw_check) {
        $('#inputPw_check').val(filteredPw_check);
        $("#checkResult").text("비밀번호 확인은 영문과 숫자만 사용할 수 있습니다.");
        updateJoinButtonState();
        return;
    }

    // 비밀번호 비어있으면
    if (inputPw.trim() === '' || inputPw_check.trim() === '') {
        $("#checkResult").text("비밀번호를 입력해주세요.");
        updateJoinButtonState();
        return;
    }

    // 비밀번호 일치 여부 검사
    if (inputPw !== inputPw_check) {
        $("#checkResult").text("비밀번호가 일치하지 않습니다.");
        updateJoinButtonState();
        return;
    }

    // 모두 통과 시
    $("#checkResult").text("비밀번호가 일치합니다.");
    pwValid = true;
    updateJoinButtonState();
}, 400));


// 아이디 유효성 체크
function checkId() {
    updateJoinButtonState();

    let inputId = $('#inputId').val();
	let filtered = inputId.replace(/[^a-zA-Z0-9]/g, '');  // 정규표현식으로 영문과 숫자만 가능하게 제약 
	
	// 아이디 제약조건 일치하지 않으면 메서드 종료
	if (inputId !== filtered) {
	    $('#inputId').val(filtered);
	    $("#checkResult").text("아이디는 영문과 숫자만 사용할 수 있습니다.");
	    updateJoinButtonState();
	    return;
	}
	
	// 아이디 값이 비어있을 경우 메서드 종료
    if (inputId.trim() === "") {
        $("#checkResult").text("아이디를 입력해주세요.");
        updateJoinButtonState();
        return;
    }
	
	// 아이디 값이 8자 이상 20자 이하가 아닐 경우 메서드 종료
	if (inputId.length >= 8 && inputId.length <= 20) {
	    // 유효한 길이
	} else {
	    $("#checkResult").text("아이디는 8자 이상 20자 이하로 입력해주세요.");
	    updateJoinButtonState();
	    return;
	}


    $.ajax({
        url: contextPath + "/member/checkId",
        type: "get",
        data: { inputId: inputId },
        success: (res) => {
            if (res === "true") {
                $("#checkResult").text("가입할 수 있는 아이디입니다.");
                idValid = true;
            } else {
                $("#checkResult").text("이미 존재하는 아이디입니다.");
                idValid = false;
            }
            updateJoinButtonState();
        },
        error: () => {
            alert("중복 체크 실패");
        }
    });
}

// 닉네임 유효성 체크
function checkNick() {
    updateJoinButtonState();

    let inputNick = $('#inputNick').val();
    let filtered = inputNick.replace(/[^가-힣0-9]/g, ''); // 한글과 숫자만 허용

    // 입력값에 허용 문자 외 포함 시 필터링된 값으로 교체 후 메시지 출력 및 종료
    if (inputNick !== filtered) {
        $('#inputNick').val(filtered);
        $("#checkResult").text("닉네임은 한글과 숫자만 사용할 수 있습니다.");
        updateJoinButtonState();
        return;
    }

    // 닉네임 빈 값 체크
    if (inputNick.trim() === "") {
        $("#checkResult").text("닉네임을 입력해주세요.");
        updateJoinButtonState();
        return;
    }

    // 길이 조건 체크
    if (inputNick.length < 2 || inputNick.length > 8) {
        $("#checkResult").text("닉네임은 2자 이상 8자 이하로 입력해주세요.");
        updateJoinButtonState();
        return;
    }

    // 중복 체크 Ajax 호출
    $.ajax({
        url: contextPath + "/member/checkNick",
        type: "get",
        data: { inputNick: inputNick },
        success: (res) => {
            if (res === "true") {
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