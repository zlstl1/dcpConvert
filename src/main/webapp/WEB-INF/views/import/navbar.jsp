<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!-- Header -->
	<header id="header">
		<div class="logo"><a href="${pageContext.request.contextPath}/dcp/login">DCP <span>Converter</span></a></div>
		<a href="#menu">Menu</a>
	</header>

	<!-- Nav -->
	<nav id="menu">
		<ul class="links">
			<c:if test="${!empty user.user_id}">
				<li><a href="${pageContext.request.contextPath}/dcp/${user.user_id}">내 파일</a></li>
				<li><a href="${pageContext.request.contextPath}/dcp/${user.user_id}/history">사용내역</a></li>
				<c:if test="${user.user_admin}">
					<li><a href="${pageContext.request.contextPath}/dcp/${user.user_id}/adminpage">관리자 페이지</a></li>
				</c:if>
				<li><a href="${pageContext.request.contextPath}/dcp/logout">로그아웃</a></li>
			</c:if>
			<c:if test="${empty user.user_id}">
				<li>
					<div id="google_id_login">
						<a href="${google_url}">로그인</a>
					</div>
				</li>
			</c:if>
		</ul>
	</nav>
