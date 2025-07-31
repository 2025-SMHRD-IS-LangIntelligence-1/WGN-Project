let idValid = false;
let nickValid = false;
let pwValid = false;

// 아이디 입력값이 바뀌면 idValid 초기화 후 버튼 활성화 여부 체크
$('#inputId').on('input', function () {
    idValid = false;
    $("#checkResult").text(""); // 메시지 초기화 (선택사항)
    updateJoinButtonState();
});

// 닉네임 입력값이 바뀌면 nickValid 초기화 후 버튼 활성화 여부 체크
$('#inputNick').on('input', function () {
    nickValid = false;
    $("#checkResult").text(""); // 메시지 초기화 (선택사항)
    updateJoinButtonState();
});

// 비밀번호 입력값이 바뀌면 pwValid 초기화 후 버튼 활성화 여부 체크
$('#inputPw', '#inputPw_check').on('input', function () {
    pwValid = false;
    $("#checkResult").text(""); // 메시지 초기화 (선택사항)
    updateJoinButtonState();
});

// 비밀번호 입력값이 바뀌면 비밀번호 일치 여부 체크
$('#inputPw, #inputPw_check').on('input', checkPw);

// 아이디 중복 체크
function checkId() {
    updateJoinButtonState();

    let inputId = $('#inputId').val();

    if (inputId.trim() === "") {
        $("#checkResult").text("아이디를 입력해주세요.");
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

// 닉네임 중복 체크
function checkNick() {
    updateJoinButtonState();

    let inputNick = $('#inputNick').val();

    if (inputNick.trim() === "") {
        if (!idValid) {
            $("#checkResult").text("아이디를 다시 확인해주세요.");
        } else {
            $("#checkResult").text("닉네임을 입력해주세요.");
        }
        updateJoinButtonState();
        return;
    }

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

function checkPw() {
    let inputPw = $('#inputPw').val();
    let inputPw_check = $('#inputPw_check').val();

    if (inputPw.trim() === "" || inputPw_check.trim() === "") {
        $("#checkResult").text("비밀번호를 입력해주세요.");
        pwValid = false;
    } else if (inputPw !== inputPw_check) {
        $("#checkResult").text("비밀번호가 일치하지 않습니다.");
        pwValid = false;
    } else {
        $("#checkResult").text("비밀번호가 일치합니다.");
        pwValid = true;
    }

    updateJoinButtonState();
}

// 회원가입 버튼 상태 업데이트
function updateJoinButtonState() {
    if (idValid && nickValid && pwValid) {
        $('#joinBtn').prop('disabled', false);
    } else {
        $('#joinBtn').prop('disabled', true);
    }
}
