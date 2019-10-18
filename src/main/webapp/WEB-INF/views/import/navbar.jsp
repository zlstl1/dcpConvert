<%@page import="com.spring.vo.UserVo"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    String cp = request.getContextPath();
%>
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
					<ul>
						<li><a href="#" onclick="monitoring()"> - 자원관리</a></li>
							<ul id="monitoring" style="display:none;">
								<li><a href="<%=cp%>/dcp/${user.user_id}/cpumonitoring">CPU</a></li>
								<li><a href="<%=cp%>/dcp/${user.user_id}/gpumonitoring">GPU</a></li>
								<li><a href="<%=cp%>/dcp/${user.user_id}/rammonitoring">RAM</a></li>
								<li><a href="<%=cp%>/dcp/${user.user_id}/storage">STORAGE</a></li>
							</ul>
					</ul>
					
					<ul>
						<li><a href="#" onclick="user()"> - 회원관리</a></li>
							<ul id="user" style="display:none">
								<li><a href="<%=cp%>/dcp/${user.user_id}/userlist">회원리스트</a></li>
		                    	<li><a href="<%=cp%>/dcp/${user.user_id}/waiting">가입대기회원</a></li>
		                    	<li><a href="<%=cp%>/dcp/${user.user_id}/group">회원그룹관리</a></li>
							</ul>
					</ul>
					
				</c:if>
				<li><a href="${pageContext.request.contextPath}/dcp/logout">로그아웃</a></li>
			</c:if>
			<c:if test="${empty user.user_id}">
				<li><a href="${google_url}">로그인</a></li>
			</c:if>
		</ul>
	</nav>

	<script type="text/javascript">
	
		function monitoring(){
			if($('#monitoring').css("display")=="none"){
	            $('#monitoring').css("display","block");
	        }else{
	            $('#monitoring').css("display","none");
	        }
		}
		
		function user(){
			if($('#user').css("display")=="none"){
	            $('#user').css("display","block");
	        }else{
	            $('#user').css("display","none");
	        }
		}
		
	</script>