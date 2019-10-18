<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String cp = request.getContextPath();
%>
<!DOCTYPE html>
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
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/circle.css">
<link rel="stylesheet" href="<%=cp%>/resources/css/cmGauge.css">
<link rel="stylesheet" href="<%=cp%>/webjars/font-awesome/5.8.1/css/all.css">
<link rel="stylesheet" href="<%=cp%>/webjars/font-awesome/5.8.1/css/fontawesome.css">
<link rel="stylesheet" href="<%=cp%>/resources/css/datatables.css">
<link rel="stylesheet" href="<%=cp%>/webjars/sweetalert2/8.18.1/dist/sweetalert2.min.css">

</head>
<body class="subpage">
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

					<div class="row text-center">
						<div class="col">
							<h1 class="font-weight-bold">
								<a href="<%=cp%>/dcp/${user.user_id}/cpumonitoring"
									style="color: #000;">CPU</a>
							</h1>
							<img src="<%=cp%>/resources/img/cpu.png" style="width: 150px;">
						</div>

						<div class="col">
							<h1 class="font-weight-bold">
								<a href="<%=cp%>/dcp/${user.user_id}/gpumonitoring"
									style="color: #000;">GPU</a>
							</h1>
							<img src="<%=cp%>/resources/img/graphicscard.png"
								style="width: 150px;">
						</div>

						<div class="col">
							<h1 class="font-weight-bold">
								<a href="<%=cp%>/dcp/${user.user_id}/rammonitoring"
									style="color: #000;">RAM</a>
							</h1>
							<img src="<%=cp%>/resources/img/ram.png" style="width: 150px;"
								class="mt-4">
						</div>

						<div class="col">
							<h1 class="font-weight-bold">
								<a href="<%=cp%>/dcp/${user.user_id}/storage"
									style="color: #000;">STORAGE</a>
							</h1>
							<img src="<%=cp%>/resources/img/cloud.png" style="width: 150px;"
								class="mt-4">
						</div>
					</div>

					<div class="row mt-5">
					
					
						<div class="col border m-2">
							<p class="m-0 font-weight-bold mt-1 mt-2"><a class="text-dark" href="<%=cp%>/dcp/${user.user_id}/userlist">회원리스트</a></p>
							<%-- 
							<div class="row mb-2">
								<div class="col text-left">
									<p class="m-0 text-dark font-weight-bold mt-1">회원리스트</p>
								</div>
								<div class="col text-right">
									<p class="m-0 mt-1"><a class="text-dark fa-sm" href="<%=cp%>/dcp/${user.user_id}/userlist">상세보기 <i class="fas fa-arrow-right fa-sm"></i></a></p>
								</div>
							</div>
							 --%>
							<table class="table table-bordered mt-2 text-center"
								id="userTable">
								<thead>
									<tr>
										<th scope="col">아이디</th>
										<th scope="col">GPU</th>
										<th scope="col">STORAGE</th>
										<th scope="col">최근접속일</th>
										<th scope="col">그룹</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="list" items="${list}">
									<c:if test="${list.user_status ne '관리자'}">
										<tr>
											<td>${list.user_id}</td>
											<td>${list.user_usingGpu}</td>
											<td>${list.user_storageCapa}</td>
											<td><fmt:formatDate value="${list.user_connect}"
													pattern="yyyy-MM-dd HH:mm" /></td>
												<td>	
									<c:if test="${list.user_status ne '미승인'}">
											${list.user_group}
									</c:if>
									<c:if test="${list.user_status eq '미승인'}">
											${list.user_status}
									</c:if>
									</td>
										</tr>
										
												</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
						
						
						<div class="col border m-2">
							<p class="m-0 font-weight-bold mt-1 mt-2"><a class="text-dark" href="<%=cp%>/dcp/${user.user_id}/waiting">가입 대기 회원</a></p>
							<table class="table table-bordered mt-2 text-center"
								id="waitingTable">
								<thead>
									<tr>
										<th scope="col">아이디</th>
										<th scope="col">이름</th>
										<th scope="col">가입신청일</th>
										<th scope="col"></th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="waiting" items="${waiting}">
										<tr>
											<td>${waiting.user_id}</td>
											<td>${waiting.user_name}</td>
											<td><fmt:formatDate value="${waiting.user_joined}"
													pattern="yyyy-MM-dd HH:mm" /></td>
											<td>
												<button class="btn btn-outline-dark" data-toggle="modal"
													data-target="#addgroupmodal"
													onclick="setUsetname('${waiting.user_id}');">승인</button>
												<button class="btn btn-outline-dark"
													onclick="reject('${waiting.user_id}');">거절</button>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>

						</div>

					</div>

					<%-- 				
					<div class="row text-left">
						<div class="col">
							<h4>
								<a href="<%=cp%>/dcp/cpumonitoring" style="color: #000;">CPU</a>
							</h4>
							<div class="row ml-2">
								<div class="col">
									<p class="font-weight-bold text-secondary mt-3">LOAD</p>
									<div class="c100 custom green ml-5" id="cpumem">
										<span id="cpumemtext"></span>
										<div class="slice">
											<div class="bar"></div>
											<div class="fill"></div>
										</div>
									</div>
								</div>

								<div class="col">
									<p class="font-weight-bold text-secondary mt-3 mb-4">CLOCK
										SPEED</p>
									<div id="gaugeDemo3" class="gauge gauge-big ml-3">
										<div class="gauge-arrow" data-percentage="98"
											style="transform: rotate(0deg);"></div>
									</div>
									<h4 class="mt-3 text-center text-secondary" id="cpuclocktext"></h4>
								</div>

							</div>
						</div>
						<div class="col-3">
							<h4>
								<a href="<%=cp%>/dcp/rammonitoring" style="color: #000;">RAM</a>
							</h4>
							<div class="row ml-2">
								<div class="col">
									<p class="font-weight-bold text-secondary mt-3">LOAD</p>
									<div class="c100 custom green ml-5" id="rammem">
										<span id="rammemtext"></span>
										<div class="slice">
											<div class="bar"></div>
											<div class="fill"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-3">
							<h4>STORAGE</h4>
							<div class="row h-75">
								<div class="col" style="margin-top: auto; margin-bottom: auto">
									<p class="font-weight-bold text-secondary">C:Drive</p>
									<div class="progress" style="height: 50px;">
										<div class="progress-bar" role="progressbar"
											style="width: 49%;" aria-valuenow="25" aria-valuemin="0"
											aria-valuemax="100" id="memused">
											<h4 id="memusedtext"></h4>
										</div>
									</div>

									<p class="font-weight-bold text-secondary mt-3 text-center">
										Used : <a id="diskused"></a> / Free : <a id="diskfree"></a>
									</p>
								</div>
							</div>
						</div>
					</div>

					<hr class="m-2">

						<div class="row text-left">
							<div class="col">

								<h4 class="m-0 p-0">
									<a href="<%=cp%>/dcp/gpumonitoring1" style="color: #000;">GPU 1</a>
								</h4>

								<div class="row ml-2">
									<div class="col">
										<div class="row">
											<div class="col">
												<p class="font-weight-bold text-secondary mt-3">TEMP</p>
												<i class="fas fa-3x mt-5 ml-5 gputemp1"></i> <a
													class="fa-3x mt-3 ml-5 gputemptext1"></a>
											</div>
										</div>

									</div>

									<div class="col">
										<div class="row">
											<div class="col">
												<p class="font-weight-bold text-secondary mt-3">LOAD</p>
												<div class="c100 custom green ml-5 gpumem1">
													<span class="gpumemtext1"></span>
													<div class="slice">
														<div class="bar"></div>
														<div class="fill"></div>
													</div>
												</div>
											</div>
										</div>
									</div>

									<div class="col">
										<div class="row">
											<div class="col">
												<p class="font-weight-bold text-secondary mt-3">CLOCK SPEED</p>

												<div class="row text-center mt-4">
													<div class="col">
														<div class="gauge gauge-big gaugeDemo1">
															<div class="gauge-arrow" data-percentage="9"
																style="transform: rotate(0deg);"></div>
														</div>
													</div>
												</div>
												<h4 class="mt-3 text-center text-secondary gpuclocktext1"></h4>

											</div>

										</div>

									</div>

								</div>

							</div>


						</div>
						
						<hr class="m-2">
						
						<div class="row text-left">
							<div class="col">

								<h4 class="m-0 p-0">
									<a href="<%=cp%>/dcp/gpumonitoring2" style="color: #000;">GPU 2</a>
								</h4>

								<div class="row ml-2">
									<div class="col">
										<div class="row">
											<div class="col">
												<p class="font-weight-bold text-secondary mt-3">TEMP</p>
												<i class="fas fa-3x mt-5 ml-5 gputemp2"></i> <a
													class="fa-3x mt-3 ml-5 gputemptext2"></a>
											</div>
										</div>

									</div>

									<div class="col">
										<div class="row">
											<div class="col">
												<p class="font-weight-bold text-secondary mt-3">LOAD</p>
												<div class="c100 custom green ml-5 gpumem1">
													<span class="gpumemtext2"></span>
													<div class="slice">
														<div class="bar"></div>
														<div class="fill"></div>
													</div>
												</div>
											</div>
										</div>
									</div>

									<div class="col">
										<div class="row">
											<div class="col">
												<p class="font-weight-bold text-secondary mt-3">CLOCK SPEED</p>

												<div class="row text-center mt-4">
													<div class="col">
														<div class="gauge gauge-big gaugeDemo2">
															<div class="gauge-arrow" data-percentage="9"
																style="transform: rotate(0deg);"></div>
														</div>
													</div>
												</div>
												<h4 class="mt-3 text-center text-secondary gpuclocktext2"></h4>

											</div>

										</div>

									</div>

								</div>

							</div>


						</div>
						
 --%>
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

	<%-- <script src="<%=cp%>/resources/js/adminpage.js"></script> --%>

	<!-- 김규아추가 -->
	<script src="<%=cp%>/resources/js/cmGauge.js"></script>
	<script src="<%=cp%>/resources/js/fontawesome.js"></script>
	<script src="<%=cp%>/resources/js/datatables.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/core-js/2.4.1/core.js"></script>
	<script src="<%=cp%>/webjars/sweetalert2/8.18.1/dist/sweetalert2.min.js"></script>

	<script type="text/javascript">
	var table = $("#userTable").DataTable({
		// 표시 건수기능
		lengthChange : false,
		// 검색 기능
		searching : true,
		// 정렬 기능
		ordering : false,
		// 정보 표시
		info : false,
		// 페이징 기능
		paging : true,
		order : [],
		//표시건수
		displayLength : 5,
	});
	
		var table = $("#waitingTable").DataTable({
			// 표시 건수기능
			lengthChange : false,
			// 검색 기능
			searching : true,
			// 정렬 기능
			ordering : false,
			// 정보 표시
			info : false,
			// 페이징 기능
			paging : true,
			order : [],
			//표시건수
			displayLength : 5,
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
						swal.fire("success",userid + " 회원의 가입이 거절 처리 되었습니다.","success");
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
						swal.fire("success",user + " 회원의 가입이 승인 처리 되었습니다.","success");
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