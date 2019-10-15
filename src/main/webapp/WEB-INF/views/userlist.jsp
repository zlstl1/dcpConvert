<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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


<link rel="stylesheet"
	href="<%=cp%>/webjars/font-awesome/5.8.1/css/fontawesome.css">
<link rel="stylesheet"
	href="<%=cp%>/webjars/font-awesome/5.8.1/css/all.css">

<link rel="stylesheet" href="<%=cp%>/resources/css/datatables.css">
<link rel="stylesheet"
	href="<%=cp%>/webjars/sweetalert2/dist/sweetalert2.css">
</head>
<body class="subpage">

	<%-- <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/import/navbar.jsp" /> --%>
	<%-- <%@include file="import/navbar.jsp" %> --%>
	<jsp:include page="import/navbar.jsp"></jsp:include>

	<!-- One -->
	<section id="One" class="wrapper style3">
		<div class="inner">
			<header class="align-center">
				<p>가입된 회원의 정보를 확인 가능합니다.</p>
				<h2>회원리스트</h2>
			</header>
		</div>
	</section>

	<!-- Two -->
	<section id="two" class="wrapper style2">
		<div class="inner">
			<div class="box">
				<div class="content">

					<div class="row">
						<div class="col">
							<table class="table table-bordered text-center" id="userTable">
								<thead>
									<tr>
										<th scope="col">아이디</th>
										<th scope="col">이름</th>
										<th scope="col">등급</th>
										<th scope="col">GPU</th>
										<th scope="col">STORAGE</th>
										<th scope="col">이메일</th>
										<th scope="col">가입승인일</th>
										<th scope="col">최근 접속일</th>
										<th scope="col">상태</th>
										<th scope="col">관리</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="list" items="${list}">
										<tr>
											<td>${list.user_id}</td>
											<td>${list.user_name}</td>
											<td>${list.user_grade}</td>
											<td>${list.user_usingGpu}</td>
											<td>${list.user_storageCapa}</td>
											<td>${list.user_email}</td>
											<td><c:if test="${list.user_status ne '미승인'}">
													<fmt:formatDate value="${list.user_joined}"
														pattern="yyyy-MM-dd HH:mm" />
												</c:if></td>
											<td><fmt:formatDate value="${list.user_connect}"
													pattern="yyyy-MM-dd HH:mm" /></td>
											<td>${list.user_status}</td>
											<td><button class="btn btn-outline-dark"
													onclick="updateuser('${list.user_id}');"
													data-toggle="modal" data-target="#exampleModal">
													<i class="fas fa-wrench"></i>
												</button>
												<button class="btn btn-outline-dark"
													onclick="deluser('${list.user_id}');">
													<i class="far fa-trash-alt"></i>
												</button></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>

				</div>
			</div>
		</div>

	</section>

	<div class="modal fade bd-example-modal-xl" id="exampleModal"
		tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
		aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">회원 정보 수정</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col">
							<div class="form-group">
								<label class="col-form-label">아이디</label> <input type="text"
									class="form-control" id="user_id" readonly>
							</div>
							<div class="form-group">
								<label class="col-form-label">회원등급</label> <select
									class="form-control" id="user_grade">
									<option value="회원">회원</option>
									<option value="관리자">관리자</option>
								</select>
							</div>
							<div class="form-group">
								<label class="col-form-label">가입승인일</label> <input type="text"
									class="form-control" id="user_joined" readonly>
							</div>
							<div class="form-group">
								<label class="col-form-label">상태</label> <input type="text"
									class="form-control" id="user_status" readonly>
							</div>
						</div>
						<div class="col">
							<div class="form-group">
								<label class="col-form-label">이름</label> <input type="text"
									class="form-control" id="user_name">
							</div>
							<div class="form-group">
								<label class="col-form-label">이메일</label> <input type="text"
									class="form-control" id="user_email">
							</div>
							<div class="form-group">
								<label class="col-form-label">최근 접속일</label> <input type="text"
									class="form-control" id="user_connect" readonly>
							</div>
						</div>
					</div>
					<hr>
					<div class="row">
						<div class="col">
							<div class="form-group">
								<label class="col-form-label">GPU</label> <input type="text"
									class="form-control" id="user_usingGpu">
							</div>
						</div>
						<div class="col">
							<div class="form-group">
								<label class="col-form-label">STORAGE</label> <input type="text"
									class="form-control" id="user_storageCapa">
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">Close</button>
					<button type="button" class="btn btn-primary">Send message</button>
				</div>
			</div>
		</div>
	</div>

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
	<script src="<%=cp%>/resources/js/datatables.min.js"></script>
	<script src="<%=cp%>/webjars/sweetalert2/dist/sweetalert2.min.js"></script>

	<script type="text/javascript">
	 var table = $("#userTable").DataTable({
	        // 표시 건수기능
	        lengthChange: false,
	        // 검색 기능
	        searching: true,
	        // 정렬 기능
	        ordering: true,
	        // 정보 표시
	        info: false,
	        // 페이징 기능
	        paging: true,
	        order: [],
	        //표시건수
	        displayLength: 20,
	    });

	 function deluser(userid){
	        swal({
	            title: "\'"+userid+"\' 회원을 삭제하시겠습니까?",
	            text: "삭제하시면 해당 회원은 탈퇴 처리 되며, 관련된 모든 정보가 사라집니다. 삭제하시겠습니까?",
	            type: "warning",
	            showCancelButton: true,
	            allowEscapeKey: false,
	            allowOutsideClick: false,
	        }).then(function (result) {

	            if (result.dismiss === "cancel") { // 취소면 그냥 나감
	                return false;
	            }

	            //일단은 user 테이블에서만 지워줬음 탈퇴시 필요한 기능추가
	            $.ajax({
	                url:"<%=cp%>/deleteuser",
					type : "POST",
					dataType : "json",
					async : false,
					data : {
						"user_id" : userid
					},
					success : function(data) {
						swal("success",userid + " 회원이 삭제처리 되었습니다.","success");
						setTimeout(function() {
							location.reload();
						}, 2000);
					},
					error : function(err) {
						console.log(err);
					}

				});

			});

		}
	 
	 function updateuser(userid){		 
		 $.ajax({
             url:"<%=cp%>/getuser",
				type : "POST",
				dataType : "json",
				async : false,
				data : {
					"user_id" : userid
				},
				success : function(data) {
					
					console.log(data.user_name);
					console.log(data.user_usingGpu);
					
					$("#user_id").val(data.user_id);
					$("#user_name").val(data.user_name);
					$("#user_grade").val(data.user_grade).prop("selected", true);
					$("#user_email").val(data.user_email);
					$("#user_joined").val(data.user_joined);
					$("#user_connect").val(data.user_connect);
					$("#user_status").val(data.user_status);

					$("#user_usingGpu").val(data.user_usingGpu);
					$("#user_storageCapa").val(data.user_storageCapa);
					
				},
				error : function(err) {
					console.log(err);
				}

			});

		}
	 
	</script>

</body>
</html>