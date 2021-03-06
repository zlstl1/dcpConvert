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

<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/bootstrap.css">

<!-- 김규아 추가 -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/circle.css">
<link rel="stylesheet" href="<%=cp%>/resources/css/cmGauge.css">
<link rel="stylesheet" href="<%=cp%>/webjars/font-awesome/5.8.1/css/fontawesome.css">
<link rel="stylesheet" href="<%=cp%>/webjars/font-awesome/5.8.1/css/all.css">
<link rel="stylesheet" href="<%=cp%>/resources/css/datatables.css">
<link rel="stylesheet" href="<%=cp%>/webjars/sweetalert2/8.18.1/dist/sweetalert2.min.css">
</head>
<body class="subpage">
	<jsp:include page="import/navbar.jsp"></jsp:include>

	<!-- One -->
	<section id="One" class="wrapper style3">
		<div class="inner">
			<header class="align-center">
				<p>가입 대기 중인 회원의 상태를 변경하실 수 있습니다.</p>
				<h2>가입 대기 리스트</h2>
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
										<th scope="col">이메일</th>
										<th scope="col">가입일자</th>
										<th scope="col">관리</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="list" items="${list}">
										<tr>
											<td>${list.user_id}</td>
											<td>${list.user_name}</td>
											<td>${list.user_email}</td>
											<td><fmt:formatDate value="${list.user_joined}"
													pattern="yyyy-MM-dd HH:mm" /></td>
											<td>
												<button class="btn btn-outline-dark" data-toggle="modal"
													data-target="#addgroupmodal"
													onclick="setUsetname('${list.user_id}');">승인</button>
												<button class="btn btn-outline-dark"
													onclick="reject('${list.user_id}');">거절</button>
											</td>
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

	<div class="modal fade bd-example-modal-xl" id="addgroupmodal"
		tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modalheader">그룹설정</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<label class="mb-2">Group</label> <select class="form-control"
						id="group_name">
						<c:forEach var="grouplist" items="${grouplist}">
							<option value="${grouplist.group_name}">${grouplist.group_name}</option>
						</c:forEach>
					</select>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">Close</button>
					<button type="button" class="btn btn-primary"
						onclick="accept();" id="modalbutton">Save</button>
				</div>
				<input type="hidden" id="user_id">
			</div>
		</div>
	</div>

	<!-- Footer -->
	<%@include file="import/footer.jsp"%>

	<script src="${pageContext.request.contextPath}/resources/jquery/jQuery3.4.1.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/jquery.scrollex.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/skel.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/util.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/main.js"></script>
	<!-- 김규아 추가 -->
	<script src="<%=cp%>/resources/js/cmGauge.js"></script>
	<script src="<%=cp%>/resources/js/datatables.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/core-js/2.4.1/core.js"></script>
	<script src="<%=cp%>/webjars/sweetalert2/8.18.1/dist/sweetalert2.min.js"></script>

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

	 function reject(userid){
		 swal.fire({
	            title: "가입신청을 거절하시겠습니까?",
	            text: "거절하시면 가입 대기 회원에서 사라지며, 재승인 하실 수 없습니다. 취소하시려면 \"Cancle\" 버튼을 눌러주세요.",
	            type: "warning",
	            showCancelButton: true,
	            allowEscapeKey: false,
	            allowOutsideClick: false,
	        }).then(function (result) {

	            if (result.dismiss === "cancel") { // 취소면 그냥 나감
	                return false;
	            }
	            
	            $.ajax({
	                url:"<%=cp%>/deleteuser",
					type : "POST",
					dataType : "json",
					async : false,
					data : {
						"user_id" : userid
					},
					success : function(data) {
						swal.fire("success","\""+userid + "\"님의 회원가입이 거절 처리 되었습니다.","success");
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
	 
	 //모달창에 user_id 값 넘겨주기 위함 
	 function setUsetname(userid){
	        $("#user_id").val(userid);
		}
	 
	 function accept(){
		 var user = $("#user_id").val();
		 var group = $("#group_name").val();
		 
		 swal.fire({
	           title: "가입신청을 승인하시겠습니까?",
	           /* text: "승인하시면 가입 대기 리스트에서 사라지며, 회원 리스트에서 관리하실 수 있습니다. 취소하시려면 \"Cancle\" 버튼을 눌러주세요.", */
	           text : "회원명 : \""+user+"\" 그룹 : \""+group+"\" 으로 등록됩니다. 취소하시려면 \"Cancle\" 버튼을 눌러주세요.",
	           type: "info",
	           showCancelButton: true,
	           allowEscapeKey: false,
	           allowOutsideClick: false,
	       }).then(function (result) {
	    	   
	            if (result.dismiss === "cancel") { // 취소면 그냥 나감
	                return false;
	            }

	            $.ajax({
	                url:"<%=cp%>/acceptuser",
					type : "POST",
					dataType : "json",
					async : false,
					data : {
						"user_id" : user,
						"user_group" : group
					},
					success : function(data) {
						swal.fire("success","\""+user + "\"님의 회원가입이 승인 처리 되었습니다.","success");
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
	
	</script>

</body>
</html>