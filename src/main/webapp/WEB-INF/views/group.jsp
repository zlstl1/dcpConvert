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
				<p>회원을 그룹별로 관리하실 수 있습니다.</p>
				<h2>회원 그룹 관리</h2>
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
							<button class="btn float-right mb-3" data-toggle="modal"
								data-target="#exampleModal">
								<i class="fas fa-plus"></i> 그룹 추가
							</button>

							<table class="table table-bordered text-center" id="userTable">
								<thead>
									<tr>
										<th scope="col">그룹명</th>
										<th scope="col">회원수</th>
										<th scope="col">GPU</th>
										<th scope="col">STORAGE</th>
										<th scope="col">생성일자</th>
										<th scope="col">최근수정일</th>
										<th scope="col">관리</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="list" items="${list}">
										<tr>
											<td>${list.group_name}</td>
											<td>${list.group_count}</td>
											<td>${list.group_usingGpu}</td>
											<td>${list.group_storageCapa}</td>
											<td><fmt:formatDate value="${list.group_create}"
													pattern="yyyy-MM-dd HH:mm" /></td>
											<td><fmt:formatDate value="${list.group_update}"
													pattern="yyyy-MM-dd HH:mm" /></td>
											<td>
												<button class="btn" data-toggle="modal"
													data-target="#exampleModal"
													onclick="getgroup('${list.group_name}');">
													<i class="fas fa-wrench"></i>
												</button>
												<c:if test="${list.group_name ne 'default'}">
												<button class="btn"
													onclick="delgroup('${list.group_name}');">
													<i class="far fa-trash-alt"></i>
												</button>
												</c:if>
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

					<div class="form-group">
						<label class="col-form-label">그룹명</label> <input type="text"
							class="form-control" id="group_name">
					</div>
					<div class="form-group">
						<label class="col-form-label">GPU</label> <input type="text"
							class="form-control" id="group_usingGpu">
					</div>
					<div class="form-group">
						<label class="col-form-label">STORAGE</label> <input type="text"
							class="form-control" id="group_storageCapa">
					</div>
					<input type="hidden" id="group_no"/>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">Close</button>
					<button type="button" class="btn btn-primary"
						onclick="creategroup();" id="modalbutton">Save</button>
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
	var before;
	
	function creategroup(){
		var group_name = $("#group_name").val();
				
		var type = $("#modalbutton").text();
		
		if(type=="Save"){

			if(groupNameCheck(group_name)!="false"){
				console.log("중복없음");
				$.ajax({
		            url:"<%=cp%>/creategroup",
						type : "POST",
						dataType : "json",
						async : false,
						data : {
							"group_name" : group_name,
							"group_usingGpu" : $("#group_usingGpu").val(),
							"group_storageCapa" : $("#group_storageCapa").val()
						},
						success : function(data) {
							swal("success","등록되었습니다.","success");
							setTimeout(function() {
								location.reload();
							}, 2000);
						},
						error : function(err) {
							console.log(err);
						}
					});
			}else{
				console.log("중복");
				return false;
			}
			
		}else if(type=="Update"){
			
			if(before!=group_name){
				if(groupNameCheck(group_name)=="false"){
					swal("error","이미 등록된 그룹명입니다.","error");
					return false;
				}
			}
			
			$.ajax({
		          url:"<%=cp%>/updateGroup",
						type : "POST",
						dataType : "json",
						async : false,
						data : {
							"group_no" : $("#group_no").val(),
							"group_name" : group_name,
							"group_usingGpu" : $("#group_usingGpu").val(),
							"group_storageCapa" : $("#group_storageCapa").val()
						},
						success : function(data) {
							
												
						},error : function(err) {
							console.log(err);
						}
					});
			
		}
		
		
	} 
	function getgroup(groupname){		 
		
		 $.ajax({
            url:"<%=cp%>/getgroup",
				type : "POST",
				dataType : "json",
				async : false,
				data : {
					"group_name" : groupname
				},
				success : function(data) {

					$("#group_name").val(data.group_name);
					$("#group_usingGpu").val(data.group_usingGpu);
					$("#group_storageCapa").val(data.group_storageCapa);
					$("#group_no").val(data.group_no);
					
					$("#modalbutton").text("Update");
					
					before = data.group_name;
					
				},error : function(err) {
					console.log(err);
				}

			});

		}
	
	function delgroup(groupname){		 
		
		swal({
            title: "그룹을 삭제하시겠습니까?",
            text: "삭제하시면 해당 그룹에 속한 회원은 default 그룹으로 이동되며, 이동된 그룹의 설정값으로 변경됩니다. 삭제하시겠습니까?",
            type: "warning",
            showCancelButton: true,
            allowEscapeKey: false,
            allowOutsideClick: false,
        }).then(function (result) {

            if (result.dismiss === "cancel") { // 취소면 그냥 나감
                return false;
            }

            $.ajax({
                url:"<%=cp%>/delGroup",
     				type : "POST",
     				dataType : "json",
     				async : false,
     				data : {
     					"group_name" : groupname
     				},
     				success : function(data) {
     					
     					swal("success","삭제되었습니다.","success");
     					setTimeout(function() {
     						location.reload();
     					}, 2000);
     					
     				},error : function(err) {
     					console.log(err);
     				}
     			});

		});

		
		 
	}
	
	function groupNameCheck(group_name){
		var result=null;
		$.ajax({
            url:"<%=cp%>/selectGroupName",
				type : "POST",
				dataType : "text",
				async : false,
				data : {
					"group_name" : group_name
				},
				success : function(data) {
					result = data;
				},
				error : function(err) {
					console.log(err);
				}
			});
			return result;
		}
	
	</script>

</body>
</html>