<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<title>사용내역</title>
  
  	<link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath }/resources/img/titleIcon.png" sizes="128x128"/>
  	<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/main.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/bootstrap.css">
</head>
<body class="subpage">

	<%-- <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/import/navbar.jsp" /> --%>
	<%@include file="import/navbar.jsp" %>
	
	<!-- One -->
	<section id="One" class="wrapper style3">
		<div class="inner">
			<header class="align-center">
				<p>로그인 및 각종 변환 내역을 확인 가능합니다.</p>
				<h2>사용내역</h2>
			</header>
		</div>
	</section>

	<!-- Two -->
	<section id="two" class="wrapper style2">
		<div class="inner">
			<div class="box">
				<div class="content">
					<table class="table table-striped mt-2">
						<thead>
					    	<tr>
					      		<th scope="col">No</th>
						      	<th scope="col">발생 시간</th>
						      	<th scope="col">내역</th>
					    	</tr>
					  	</thead>
					  	<tbody>
							<c:choose>
						  		<c:when test="${empty historyList}">
									<tr><td colspan="3" align="center">데이터가 없습니다.</td></tr>
								</c:when> 
								<c:when test="${!empty historyList}">
									<c:forEach var="historyList" items="${historyList}" varStatus="status">
							  			<tr>
								  			<th scope="row">${status.count + ((pagination.page-1)*10)}</th>
									      	<td>${historyList.history_date}</td>
									      	<td>${historyList.history_msg}</td>
										</tr>
									</c:forEach>
								</c:when> 
							</c:choose>
					  	</tbody>
					</table>
					
					<nav aria-label="Page navigation example">
						 <ul class="pagination justify-content-center">
							<c:if test="${pagination.prev}">
								<li class="page-item"><a class="page-link" href="#" onClick="fn_prev('${pagination.page}', '${pagination.range}', '${pagination.rangeSize}')">이전</a></li>
							</c:if>
							<c:forEach begin="${pagination.startPage}" end="${pagination.endPage}" var="idx">
								<li class="page-item <c:out value="${pagination.page == idx ? 'active' : ''}"/> "><a class="page-link" href="#" onClick="fn_pagination('${idx}', '${pagination.range}', '${pagination.rangeSize}')"> ${idx} </a></li>
							</c:forEach>
							<c:if test="${pagination.next}">
								<li class="page-item"><a class="page-link" href="#" onClick="fn_next('${pagination.range}', '${pagination.range}', '${pagination.rangeSize}')" >다음</a></li>
							</c:if>
						</ul>
					</nav>
				</div>
			</div>
		</div>
	</section>
	
	<!-- Footer -->
	<%@include file="import/footer.jsp" %>
		
	
	<script src="${pageContext.request.contextPath}/resources/jquery/jQuery3.4.1.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/jquery.scrollex.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/skel.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/util.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/main.js"></script>
	
	<script type="text/javascript">
	
	function fn_prev(page, range, rangeSize) {
		event.preventDefault();
		var page = ((range - 2) * rangeSize) + 1;
		var range = range - 1;

		var url = "${pageContext.request.contextPath}/dcp/${user.user_id}/history";
		url = url + "?page=" + page;
		url = url + "&range=" + range;
		
		location.href = url;
	}

	function fn_pagination(page, range, rangeSize) {
		event.preventDefault();
		var url = "${pageContext.request.contextPath}/dcp/${user.user_id}/history";
		url = url + "?page=" + page;
		url = url + "&range=" + range;
		
		location.href = url;	
	}

	function fn_next(page, range, rangeSize) {
		event.preventDefault();
		var page = parseInt((range * rangeSize)) + 1;
		var range = parseInt(range) + 1;

		var url = "${pageContext.request.contextPath}/dcp/${user.user_id}/history";
		url = url + "?page=" + page;
		url = url + "&range=" + range;

		location.href = url;
	}
	</script>
</body>
</html>