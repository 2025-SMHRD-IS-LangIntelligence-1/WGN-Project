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
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/notification.css" />
</head>
<body>
	<div class="mobile-container">
		<%@ include file="/WEB-INF/views/common/topBar.jsp"%>

		<div class="mobile-container">

			<div class="content notification-content">

				<h3 class="page-title">알림</h3>

				<div id="notification-list" class="notification-list">
					<%-- 서버에서 알림 리스트를 넘겨줄 경우, JSTL로 출력 예시 --%>
					<c:forEach var="noti" items="${notifications}">
						<div
							class="notification-item <c:if test='${noti.read}'>read</c:if>">
							<div class="noti-message">
								<b>${noti.sender_id}</b>
								<c:choose>
									<c:when test="${noti.type == 'follow'}">
                                    님이 팔로우하셨습니다.
                                </c:when>
									<c:when test="${noti.type == 'comment'}">
                                    님이 게시글에 댓글을 남기셨습니다:<br>
                                    <span class="comment-content">${noti.content}</span>
									</c:when>
									<c:when test="${noti.type == 'like'}">
                                    님이 게시글에 좋아요를 누르셨습니다.
                                </c:when>
									<c:otherwise>
                                    알림이 도착했습니다.
                                </c:otherwise>
								</c:choose>
							</div>
							<div class="noti-time">${noti.created_at}</div>
						</div>
					</c:forEach>

					<%-- 알림이 없을 때 --%>
					<c:if test="${empty notifications}">
						<div class="no-notifications">받은 알림이 없습니다.</div>
					</c:if>
				</div>

			</div>

		</div>

		<%@ include file="/WEB-INF/views/common/bottomBar.jsp"%>

		<!-- Bootstrap JS -->
		<script
			src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
	</div>
</body>
</html>