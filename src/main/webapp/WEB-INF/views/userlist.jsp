<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String cp = request.getContextPath();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>관리자 페이지</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/assets/css/main.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/bootstrap.css">

<!-- 김규아 추가 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/circle.css">
<link rel="stylesheet" href="<%=cp%>/resources/css/cmGauge.css">


<link rel="stylesheet" href="<%=cp%>/resources/css/all.css">
<link rel="stylesheet" href="<%=cp%>/resources/css/fontawesome.css">

</head>
<body class="subpage">

	<%-- <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/import/navbar.jsp" /> --%>
	<%-- <%@include file="import/navbar.jsp" %> --%>
	<jsp:include page="import/navbar.jsp"></jsp:include>

	<!-- One -->
	<section id="One" class="wrapper style3">
		<div class="inner">
			<header class="align-center">
				<p>회원관리 및 자원 모니터링이 가능합니다.</p>
				<h2>관리자 페이지</h2>
			</header>
		</div>
	</section>

	<!-- Two -->
	<section id="two" class="wrapper style2">
		<div class="inner">
			<div class="box">
				<div class="content">
				
				
				</div>
			</div>
		</div>

	</section>

	<!-- Footer -->
	<%@include file="import/footer.jsp"%>

	<script
		src="${pageContext.request.contextPath}/resources/jquery/jQuery3.4.1.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/assets/js/jquery.scrollex.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/assets/js/skel.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/assets/js/util.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/assets/js/main.js"></script>
	
	<script src="<%=cp%>/resources/js/cmGauge.js"></script>

	<script src="<%=cp%>/resources/js/fontawesome.js"></script>

</body>
</html>