<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<title>createDCP</title>
	
	<link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath }/resources/img/titleIcon.png" sizes="128x128"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/assets/css/main.css">
	<link href="${pageContext.request.contextPath }/resources/css/skin-lion/ui.fancytree.css" rel="stylesheet">
	<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/bootstrap.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/sweetalert.css">
</head>
<body class="subpage">
	
	<div class="lodingDiv d-none">
		<div class="loader">Working...</div>
	</div>

	<%-- <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/import/navbar.jsp" /> --%>
	<%@include file="import/navbar.jsp" %>
	
	<!-- One -->
	<section id="One" class="wrapper style3">
		<div class="inner">
			<header class="align-center">
				<p>웹하드 형식으로 DCP변환이 가능합니다.</p>
				<h2>내 파일</h2>
			</header>
		</div>
	</section>

	<!-- Two -->
	<section id="two" class="wrapper style2">
		<div class="inner">
			<div class="box">
				<div class="content">
					<div class="mt-2 mb-2 ml-2">
						<input type="checkbox" id="checkAll">
						<label for="checkAll"  class="mb-3"></label>
						
						<div class="btn-group" role="group">
				  			<label for="uploadFile" class="button small"><i class="icon fa-upload"></i>&nbsp;업로드</label>
				  			<form id="fileForm">
				  				<input type="file" id="uploadFile" name="uploadFile" multiple="multiple" hidden="hidden">
				  				<input type="text" id="path" name="path" value="" hidden="hidden">
				  			</form>
						  	<button type="button" class="button small" id="downloadBtn"><i class="icon fa-download"></i>&nbsp;다운로드</button>
						  	<button type="button" class="button small" id="explorerBtn" data-toggle="modal" data-target="#explorerModal">
						  	<i class="icon fa-exchange"></i>&nbsp;파일 이동</button>
						  	<button type="button" class="button small" id="deleteBtn"><i class="icon fa-remove"></i>&nbsp;삭제</button>
						  	<button type="button" class="button small" id="convertBtn"><i class="icon fa-random"></i>&nbsp;변환</button>
						</div>
			
						<div id="convertArea">
				  			<button type="button" class="button small" id="tiffBtn" data-toggle="modal" data-target="#tiffModal">TIFF 변환</button>
						  	<button type="button" class="button small" id="jpegBtn" data-toggle="modal" data-target="#jpegModal">JPEG2000 변환</button>
						  	<button type="button" class="button small" id="mxfBtn" data-toggle="modal" data-target="#mxfModal">MXF 변환</button>
						  	<button type="button" class="button small" id="dcpBtn" data-toggle="modal" data-target="#dcpModal">DCP 변환</button>
						  	<button type="button" class="button small" id="oneStopBtn" data-toggle="modal" data-target="#oneStopModal">OneStop 변환</button>
						</div>
						
						<c:if test="${not empty dirSize}">
							<div class="float-right d-flex pt-2">
								<p>${user.user_name} : &nbsp</p><p id="userStorage">${dirSize}/${user.user_storageCapa}GB</p>
							</div>
						</c:if>
					</div>
					
					<div class="progress m-2" id="progressBarDiv" hidden="hidden">
				  		<div class="progress-bar" id="uploadProgressBar" role="progressbar" style="width:100%;" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100">100%</div>
					</div>
				
					<div id="myFileList" class="border border-success rounded-sm d-flex flex-row flex-wrap mr-1 ml-1 pt-2 pb-2">
						<div class="mr-1 ml-1 mb-1">
							<div class="upper_folder card" style="width: 10rem;">
					  			<img src="${pageContext.request.contextPath}/resources/img/upper_folder.png" class="card-img-top" alt="...">
					  			<div class="card-body">
					    			<p class="card-text text-truncate">..</p>
					  			</div>
							</div>
						</div>
						<div class="mr-1 ml-1 mb-1">
							<div class="make_folder card" style="width: 10rem;">
					  			<img src="${pageContext.request.contextPath}/resources/img/make_folder.png" class="card-img-top" alt="...">
					  			<div class="card-body">
					    			<p class="card-text text-truncate">폴더 생성</p>
					  			</div>
							</div>
						</div>
						
						<c:forEach var="fileList" items="${fileList}">
							<c:if test="${fileList.fileType eq 'folder'}">
								<div class="mr-1 ml-1 mb-1">
									<div class="${fileList.fileType} card selectCard" style="width: 10rem;">
										<input type="checkbox" class="chk" name="chk" value="${fileList.fileName}" hidden="hidden">
							  			<img src="${pageContext.request.contextPath}/resources/img/${fileList.fileType}.png" class="card-img-top" alt="...">
							  			<div class="card-body">
							    			<p class="card-text text-truncate">${fileList.fileName}</p>
							  			</div>
									</div>
								</div>
							</c:if>
							<c:if test="${fileList.fileType eq 'file'}">
								<div class="mr-1 ml-1 mb-1">
									<div class="${fileList.fileType} card selectCard" style="width: 10rem;">
										<input type="checkbox" class="chk" name="chk" value="${fileList.fileName}" hidden="hidden">
							  			<img src="${pageContext.request.contextPath}/resources/img/${fileList.fileType}.png" class="card-img-top" alt="...">
							  			<div class="card-body">
							    			<p class="card-text text-truncate">${fileList.fileName}</p>
							  			</div>
									</div>
								</div>
							</c:if>
						</c:forEach>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- Footer -->
	<%@include file="import/footer.jsp" %>
	
	<!-- makeFolder Modal -->
	<%-- <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/modal/makeFolderModal.jsp" /> --%>
	<%@include file="modal/makeFolderModal.jsp" %>
	
	<!-- TIFF Modal -->
	<%-- <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/modal/tiffModal.jsp" /> --%>
	<%@include file="modal/tiffModal.jsp" %>
	
	<!-- JPEG Modal -->
	<%-- <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/modal/jpegModal.jsp" /> --%>
	<%@include file="modal/jpegModal.jsp" %>
	
	<!-- MXF Modal -->
	<%-- <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/modal/mxfModal.jsp" /> --%>
	<%@include file="modal/mxfModal.jsp" %>
	
	<!-- DCP Modal -->
	<%-- <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/modal/dcpModal.jsp" /> --%>
	<%@include file="modal/dcpModal.jsp" %>
	
	<!-- ONESTOP Modal -->
	<%-- <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/modal/oneStopModal.jsp" /> --%>
	<%@include file="modal/oneStopModal.jsp" %>
	
	<!-- explorer modal -->
	<%-- <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/modal/explorerModal.jsp" /> --%>
	<%@include file="modal/explorerModal.jsp" %>
	
	<script src="${pageContext.request.contextPath}/resources/jquery/jQuery3.4.1.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/jquery.fancytree.ui-deps.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/jquery.fancytree.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/sweetalert.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/jquery.scrollex.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/skel.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/util.js"></script>
	<script src="${pageContext.request.contextPath}/resources/assets/js/main.js"></script>
	<script src="${pageContext.request.contextPath}/resources/jquery/main.js"></script>
	<%-- <jsp:include page="${pageContext.request.contextPath}/WEB-INF/views/import/indexJS.jsp" /> --%>
	
	<script type="text/javascript">

	//파일 업로드 기능
	$("#uploadFile").on("change",function(){
		var uploadFile = $(this).val();
		
		if(uploadFile != ""){
			var uploadFileSize = 0
			for(var i=0;i<this.files.length;i++){
				uploadFileSize += this.files[i].size
			}
			uploadFileSize = uploadFileSize / 1024.0 / 1024.0 / 1024.0;
			var dirSize = $("#userStorage").html().split("/")[0];
			var userStorageCapa = ${user.user_storageCapa};
			
			if((uploadFileSize+parseFloat(dirSize)) < userStorageCapa){
				
				var frm = document.getElementById('fileForm');
			    frm.method = 'POST';
			    frm.enctype = 'multipart/form-data';
			    if( $('#path').val().replace(/\s/g,"").length == 0){
			    	$('#path').val("/");
			    }
			    	
			    var formData = new FormData(frm);
			    
			    $.ajax({
			        url:"${pageContext.request.contextPath}/dcp/${user.user_id}/uploadfile",
			        type:'POST',
			        data:formData,
			        contentType:false,
			        processData:false,
			        beforeSend: function() {
			        	$("#progressBarDiv").removeAttr("hidden");
			        },
			        success : function() {
			        	swal("성공","업로드 완료", "success");
			        	if($('#path').val() == "/"){
			        		$('#path').val("");
			        	}
			        	var path = $("#path").val();
			        	fetchFileList(path);
			        	$("#progressBarDiv").attr("hidden","hidden");
					},xhr: function() { //XMLHttpRequest 재정의 가능
						var xhr = $.ajaxSettings.xhr();
						xhr.upload.onprogress = function(e) { //progress 이벤트 리스너 추가
							var percent = e.loaded * 100 / e.total;
							setProgress(percent);
						};
						return xhr;
					},
					error : function(XHR, status, error) {
						console.error(status + " : " + error);
					}
		
			    });
			    $(this).val("");
			}else{
				swal("경고","개인 용량을 초과하였습니다", "error");
				$(this).val("");
			}
		}
	});
	
	//myFileList 박스에 카드 그리기
	function fetchFileList(path){
		$.ajax({
			url: "${pageContext.request.contextPath}/dcp/${user.user_id}/fetchfilelist",
			type : "post",
			//contentType : "application/json",
			data : {
				path : path
			},
			beforeSend: function() {
				showLoding();
			},
			//dataType : "json",
			success : function(map) {
				render(map.fileList);
				$("#checkAll").prop("checked", false);
				$("#userStorage").html(map.dirSize+"/${user.user_storageCapa}GB");
				hideLoding();
			},
			error : function(XHR, status, error) {
				console.error(status + " : " + error);
			}
		});
	};
	
	</script>
	
</body>
</html>