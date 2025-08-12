$(document).ready(function () {
  // 초기 읽은 알림 표시
  $(".notification-item").each(function () {
    const isRead = $(this).data("read");
    if (isRead === true) {
      $(this).addClass("read");
    }
  });

  // 알림 클릭 시 처리
  $(".notification-item").on("click", function () {

    console.log("알림 클릭 성공")

    const $this = $(this); // 클릭된 요소
    const notiId = $this.data("noti-id");
    const type = $this.data("type");
    const senderId = $this.data("sender-id");
    const targetId = $this.data("target-id");

    console.log(notiId, type, senderId, targetId)

    // 1. 먼저 읽음 처리 요청
    $.ajax({
      type: "POST",
      url: "/wgn/notification/read",
      data: { noti_id: notiId },
      success: function () {

        console.log("요청 성공")

        $this.addClass("read");

        // 2. 처리 후 페이지 이동
        let prefix = "http://localhost:8202/wgn";

        let url;
        if (type === "follow") {
          url = prefix + "/profile/" + senderId;
        } else if (type === "comment" || type === "like") {
          url = prefix + "/feed?feed_idx=" + targetId;
        }

        window.location.href = url;
      },
      error: function () {
        alert("알림 읽음 처리 실패!");
      }
    });
  });
});
