function getContextPath() {
  var hostIndex = location.href.indexOf( location.host ) + location.host.length;
  return location.href.substring( hostIndex, location.href.indexOf('/', hostIndex + 1) );
};

function getID(){
	var id
	$.ajax({
	    type:"GET",
	    url: getContextPath() + "/rest/getemail",
	    async:false,
	    success: function(data) {
	    	id= data;
	    }
	});
	return id;
}

//페이지 로딩시 파일 이동 모달창에 트리 그리기
renderTree();

//트리 전체 열기 기능
function expandFunc(){
	$("#tree").fancytree("getTree").expandAll();
};

//트리 전체 닫기 기능
function collapseFunc(){
	$("#tree").fancytree("getTree").expandAll(false);
};

//파일 탐색기 모달창에서 선택 버튼 클릭시 변환 모달창에 경로 기입 기능
$("#convertModalSelect").on("click",function(){
	var node = $("#tree").fancytree("getActiveNode");
    if( node ){
      	$(".path").val(node.key);
      	$('#explorerModal').modal('toggle');
    }else{
    	swal("경고","경로를 선택해 주세요", "error");
    }
});

//디렉토리 트리 그리기
function renderTree(){
	$("#tree").fancytree({
		source: {
			url: getContextPath() + "/dcp/" + getID() + "/getdirectorylist"
	   	}
	});
}

$('#convertBtn').mouseenter(function(){
	$('#convertArea').css("display", "flex");
});
$('#convertArea').mouseenter(function(){
	$('#convertArea').css("display", "flex");
});
$('#convertBtn').mouseleave(function(){
	$('#convertArea').css("display", "none");
});
$('#convertArea').mouseleave(function(){
	$('#convertArea').css("display", "none");
});

//파일 탐색기 모달창에서 선택 버튼을 두개로 만들고 하나는 파일 이동 기능 하나는 변환시 경로 지정 기능
$('#explorerBtn').on('click', function (e) {
	$("#explorerModalSelect").attr("hidden",false);
	$("#convertModalSelect").attr("hidden",true);
});

//파일 탐색기 모달창에서 선택 버튼 클릭시 파일 이동 기능
$("#explorerModalSelect").on("click",function(){
	var items = getItem();
	if(items[0] === undefined){
		swal("경고","파일 또는 폴더를 선택해주세요", "error");
		$('#explorerModal').modal('toggle');
	}else{
   		var node = $("#tree").fancytree("getActiveNode");
		for(var i=0; i<items.length; i++){
			if( node && items[i] == node.key){
				swal("경고","선택된 폴더로 폴더를 이동하는것은 불가능합니다", "error");
				$('#explorerModal').modal('toggle');
				return;
			}
		}
    	moveFile(node.key, items);
        $('#explorerModal').modal('toggle');
	}
}); 

//파일 이동 ajax
function moveFile(path, items){
	jQuery.ajaxSettings.traditional = true;
	$.ajax({
        url: getContextPath() + "/dcp/" + getID() + "/movefile",
        type:'POST',
      	//contentType : "application/json",
        data:{
        	"items" : items,
        	"path" : path
        },
        beforeSend: function() {
			showLoding();
		},
        success : function() {
        	swal("성공","이동 완료", "success");
        	hideLoding();
        	var path = $("#path").val();
        	fetchFileList(path);
        	renderTree();
        	jQuery.ajaxSettings.traditional = false;
		},
		error : function(XHR, status, error) {
			jQuery.ajaxSettings.traditional = false;
			console.error(status + " : " + error);
		}
    })
}

//폴더 생성 모달의 생성 버튼  클릭시 폴더 생성
$('#makeFolderBtn').on('click',function(){
	if($("#folderName").val() == ""){
		swal("경고","폴더명을 입력하세요", "error");
	}else{
		$.ajax({
			url: getContextPath() + "/dcp/" + getID() + "/makefolder",
			type : "post",
			//contentType : "application/json",
			data : {
				"folderName" : $("#path").val() + "/" + $("#folderName").val()
			},
			dataType : "text",
			beforeSend: function() {
				showLoding();
			},
			success : function() {
				swal("성공","폴더 생성 완료", "success");
				hideLoding();
				var path = $("#path").val();
	        	fetchFileList(path);
	        	renderTree();
	        	$('#makeFolderModal').modal('toggle');
			},
			error : function(XHR, status, error) {
				console.error(status + " : " + error);
			}
		});
	}
});

//업로드 왼쪽의 체크박스 클릭시 모든 체크박스 활성화 및 비활성화
$("#checkAll").click(function() {
	if ($("#checkAll").prop("checked")) {
		$("input[name=chk]").prop("checked", true);
		$("input[name=chk]").parent().addClass("border border-primary");
	} else {
		$("input[name=chk]").prop("checked", false);
		$("input[name=chk]").parent().removeClass("border border-primary");
	}
});

//파일 업로드시 프로그레스 바 구현
function setProgress(per) {
	var $progressBar = $("#uploadProgressBar");
	$progressBar.css("width", Math.round(per) + "%");
	$progressBar.html(Math.round(per) + "%");
}

//선택된(체크 된) 체크박스 아이템 가져오기 (이메일 이후 경로부터)
function getItem(){
	var items=[]; 
	var path = $("#path").val() + "/";
	$('input[name="chk"]:checkbox:checked').each(function(){
		items.push(path + $(this).val());
	});
	
	return items;
};

//다운로드 버튼 클릭시 다운로드 기능
$("#downloadBtn").on("click",function(){
	var items = getItem();
	if(items[0] !== undefined){
		ext = items[0].split(".");
	}else{
		swal("경고","파일을 선택해주세요", "error");
		return;
	}
	
	if(ext.length < 2){
		if(items.length > 1){
			swal("경고","폴더는 하나씩 다운 가능합니다", "error");
		}else{
			swal({
				title: "경고",
			  	text: "폴더 다운로드는 압축으로 인해 오래 걸릴수 있습니다.",
			  	type: "warning",
			  	showCancelButton: true,
			  	confirmButtonClass: "btn-danger",
			  	confirmButtonText: "계속 진행",
			  	cancelButtonText: "취소",
			  	closeOnConfirm: true,
			  	closeOnCancel: true
			},
			function(isConfirm) {
			  	if (isConfirm) {
			  		window.location.href=getContextPath() + '/dcp/' + getID() + '/downloadfolder?path=' + items[0].split("/");
			  	}
			});
		}
	}else{
		for(var i=0; i < items.length; i++){
			window.location.href=getContextPath() + '/dcp/' + getID() + '/downloadfile?path=' + items[i].split("/");
			sleep(300);
		}
		
	}
});

function sleep (delay) {
   var start = new Date().getTime();
   while (new Date().getTime() < start + delay);
}

//파일 삭제 버튼 클릭시 파일 삭제 기능
$("#deleteBtn").on("click",function(){
	var items = getItem();
	if (items.length == 0 ){
		swal("경고","삭제하실 파일 또는 폴더를 선택하세요", "error");
	}else{
		swal({
			title: "경고",
		  	text: "파일을 지우시겠습니까?",
		  	type: "warning",
		  	showCancelButton: true,
		  	confirmButtonClass: "btn-danger",
		  	confirmButtonText: "지우기",
		  	cancelButtonText: "취소",
		  	closeOnConfirm: false,
		  	closeOnCancel: false
		},
		function(isConfirm) {
		  	if (isConfirm) {
		  		jQuery.ajaxSettings.traditional = true;
				
				$.ajax({
					 url: getContextPath() + "/dcp/" + getID() + "/deletefile",
			        type:'POST',
			        data:{
			        	"items" : items
			        },
			        beforeSend: function() {
						showLoding();
					},
			        success : function() {
			        	swal("성공","삭제 완료", "success");
			        	hideLoding();
			        	jQuery.ajaxSettings.traditional = false;
			        	var path = $("#path").val();
			        	fetchFileList(path);
			        	renderTree();
					},
					error : function(XHR, status, error) {
						jQuery.ajaxSettings.traditional = false;
						console.error(status + " : " + error);
					}
		
			    })
		  	} 
		});
	}
});

//폴더 더블 클릭시 해당 폴더로 위치 이동
$("#myFileList").on("dblclick", ".folder",function(){
	var dirName = $(this).find(".card-text").html();
	var path = $("#path").val() + "/" + dirName;
	$("#path").val(path);
	fetchFileList(path);
});

//파일 또는 폴더 선택시 체크박스 값 변환 및 테두리
$("#myFileList").on("click", ".selectCard",function(){
	if ($(this).find("[name=chk]").prop("checked")) {
		$(this).find("[name=chk]").prop("checked", false);
		$(this).removeClass("border border-primary");
	} else {
		$(this).find("[name=chk]").prop("checked", true);
		$(this).addClass("border border-primary");
	}
});

//상위 폴더 더블 클릭시 상위 경로로 이동
$("#myFileList").on("dblclick", ".upper_folder",function(){
	var path = $("#path").val();
	var lastIndex = path.lastIndexOf("/");
	var changePath = "";
	if( lastIndex != -1){
		changePath = path.substr(0,lastIndex);
		$("#path").val(changePath);
		fetchFileList(changePath);
	}else{
	}
	
});

//폴더 생성 카드 선택시 폴더 생성 모달 
$("#myFileList").on("click", ".make_folder",function(){
	$('#makeFolderModal').modal('toggle');
});

//카드 그리기
function render(fileList) {
	
	var str = "";
	
	str += '<div class="mr-1 ml-1 mb-1">';
	str += '	<div class="upper_folder card" style="width: 10rem;">';
  	str += '		<img src="' + getContextPath() + '/resources/img/upper_folder.png" class="card-img-top" alt="...">';
  	str += '		<div class="card-body">';
    str += '			<p class="card-text text-truncate">..</p>';
  	str += '		</div>';
	str += '	</div>';
	str += '</div>';
	str += '<div class="mr-1 ml-1 mb-1">';
	str += '	<div class="make_folder card" style="width: 10rem;">';
  	str += '		<img src="' + getContextPath() + '/resources/img/make_folder.png" class="card-img-top" alt="...">';
  	str += '		<div class="card-body">';
    str += '			<p class="card-text text-truncate">폴더 생성</p>';
  	str += '		</div>';
	str += '	</div>';
	str += '</div>';

	for(var i=0; i<fileList.length; i++){
		str += '<div class="mr-1 ml-1 mb-1">';
		str += '<div class="' + fileList[i].fileType +' card selectCard" style="width: 10rem;">';
		str += '<input type="checkbox" class="chk" name="chk" value="' + fileList[i].fileName + '" hidden="hidden">';
		str += '<img src="' + getContextPath() + '/resources/img/' + fileList[i].fileType + '.png" class="card-img-top" alt="...">';
	  	str += '		<div class="card-body">';
	    str += '			<p class="card-text text-truncate">' + fileList[i].fileName + '</p>';
	  	str += '		</div>';
		str += '	</div>';
		str += '</div>';
	}

	
	$("#myFileList").empty();
	$("#myFileList").append(str);
}; 

//convert 모달 팝업시 폴더 탐색 모달 버튼 변경
$('.reset').on('show.bs.modal', function (e) {
	$("#explorerModalSelect").attr("hidden",true);
	$("#convertModalSelect").attr("hidden",false);
});

//convert 모달 종료시 내용 초기화
$('.reset').on('hidden.bs.modal', function (e) {
	$('#key').attr('disabled',true);
	$('#keyID').attr('disabled',true);
	$('.path').val('');
	$(this).find('form')[0].reset()
});

//TIFF 변환
$('#tiffConvert').on('click',function(){
	var items = getItem();
	if(items[0] !== undefined){
		var ext = items[0].split(".")[1];
		if(ext !== undefined){
			ext.toLowerCase();
		}
	}else{
		swal("경고","파일을 선택해주세요", "error");
		return;
	}
	
	if ( $("#title_t").val() == ""){
		swal("경고","Title을 입력해주세요", "error");
	}else if( $("#length_t").val() == ""){
		swal("경고","Length를 입력해주세요", "error");
	}else if( !($.isNumeric($("#length_t").val()))){
		swal("경고","Length 필드에는 숫자만 입력해주세요", "error");
	}else if( $("#quality_t").val() == ""){
		swal("경고","Quality를 입력해주세요", "error");
	}else if( !($.isNumeric($("#quality_t").val()))){
		swal("경고","Quality 필드에는 숫자만 입력해주세요", "error");
	}else if(items.length > 1){
		swal("경고","TIFF 변환은 동영상 파일 하나를 선택하세요", "error");
	}else if(ext != "mp4" && ext != "mkv" && ext != "avi" && ext != "mov" && ext != "wmv" && ext != "mpeg" && ext != "m4v" && ext != "asx" && ext != "mpg"&& ext != "ogm"){
		swal("경고","TIFF 변환은 동영상 파일을 선택하세요", "error");
	}else {
		jQuery.ajaxSettings.traditional = true;
		
       	$.ajax({
       	url: getContextPath() + "/dcp/" + getID() + "/tiff",
			type : "post",
			//contentType : "application/json",
			data : {
				"title" : $("#title_t").val(),
				"length" : $("#length_t").val(),
				"quality" : $("#quality_t").val(),
				"scale" : $("#scale_t").val(),
				"frameRate" : $("#frameRate_t").val(),
				"items" : items,
				"path" : $("#path_t").val()
			},
			//dataType : "json",
			beforeSend: function() {
				showLoding();
		    },
			success : function() {
				swal("성공","TIFF 변환완료", "success");
				hideLoding();
				jQuery.ajaxSettings.traditional = false;
				var path = $("#path").val();
	        	fetchFileList(path);
	        	renderTree();
	        	$('#tiffModal').modal('toggle');
			},
			error : function(XHR, status, error) {
				jQuery.ajaxSettings.traditional = false;
				hideLoding();
				console.error(status + " : " + error);
			}
		});
	}
});

//JPEG 변환
$('#jpegConvert').on('click',function(){
	var items = getItem();
	if(items[0] !== undefined){
		var ext = items[0].split(".")[1];
		if(ext !== undefined){
			ext.toLowerCase();
		}
	}else{
		swal("경고","파일을 선택해주세요", "error");
		return;
	}
	
	if( $("#bandWidth_j").val() == ""){
		swal("경고","BandWidth를 입력해주세요", "error");
	}else if( !($.isNumeric($("#bandWidth_j").val()))){
		swal("경고","BandWidth 필드에는 숫자만 입력해주세요", "error");
	}else if(ext != "tiff" && ext != "tif" && ext != "bmp"){
		swal("경고","JPEG 변환은 TIFF 또는 BMP 파일을 선택하세요", "error");
	}else{
		jQuery.ajaxSettings.traditional = true;
		$.ajax({
			url: getContextPath() + "/dcp/" + getID() + "/jpeg",
			type : "post",
			//contentType : "application/json",
			data : {
				"bandWidth" : $("#bandWidth_j").val(),
				"frameRate" : $("#frameRate_j").val(),
				"items" : items,
				"path" : $("#path_j").val()
			},
			//dataType : "json",
			beforeSend: function() {
				showLoding();
		    },
			success : function() {
				swal("성공","JPEG변환완료", "success");
				hideLoding();
				jQuery.ajaxSettings.traditional = false;
				var path = $("#path").val();
	        	fetchFileList(path);
	        	renderTree();
	        	$('#jpegModal').modal('toggle');
			},
			error : function(XHR, status, error) {
				jQuery.ajaxSettings.traditional = false;
				hideLoding();
				console.error(status + " : " + error);
			}
		});
	}
});

//MXF 모달의 암호화 활성화 및 비활성화
$("#encryption").on('change',function(){
	var checked = $('#encryption').prop("checked");
	if(checked){
		$('#key').attr('disabled',false);
		$('#keyID').attr('disabled',false);
	}else{
		$('#key').attr('disabled',true);
		$('#keyID').attr('disabled',true);
	}
});

//MXF 변환
$('#mxfConvert').on('click',function(){
	var items = getItem();
	if(items[0] !== undefined){
		var ext = items[0].split(".")[1];
		if(ext !== undefined){
			ext.toLowerCase();
		}
	}else{
		swal("경고","파일을 선택해주세요", "error");
		return;
	}
	
	if( $("#title_m").val() == ""){
		swal("경고","Title을 입력해주세요", "error");
	}else if( $("#fileType_m").val() == "picture" ){
		if(ext === undefined){
			mxfConvert(items);
		}else{
			swal("경고","JPEG2000 포맷의 파일이 있는 폴더를 선택하세요", "error");
		}
	}else if( $("#fileType_m").val() == "sound" ){
		if(ext === undefined){
			mxfConvert(items);
		}else{
			swal("경고","WAV 포맷의 파일이 있는 폴더를 선택하세요", "error");
		}
	}else if( $("#fileType_m").val() == "subtitle" ){
		if(ext === undefined ){
			swal("경고","srt 포맷의 파일을 선택하세요", "error");
		}else if( ext != "srt"){
			swal("경고","srt 포맷의 파일을 선택하세요", "error");
		}else{
			mxfConvert(items);
		}
	}else{
		mxfConvert(items);
	}
});

function mxfConvert(items){
	jQuery.ajaxSettings.traditional = true;
	
   	$.ajax({
   		url: getContextPath() + "/dcp/" + getID() + "/mxf",
		type : "post",
		//contentType : "application/json",
		data : {
			"title" : $("#title_m").val(),
			"label" : $("#label_m").val(),
			"scale" : $("#scale_m").val(),
			"frameRate" : $("#frameRate_m").val(),
			"fileType" : $("#fileType_m").val(),
			"encryption" : $("#encryption").val(),
			"key" : $("#key").val(),
			"keyID" : $("#keyID").val(),
			"items" : items,
			"path" : $("#path_m").val()
		},
		//dataType : "json",
		beforeSend: function() {
				showLoding();
		},
		success : function() {
			swal("성공","MXF 변환완료", "success");
			hideLoding();
			jQuery.ajaxSettings.traditional = false;
			var path = $("#path").val();
        	fetchFileList(path);
        	renderTree();
        	$('#mxfModal').modal('toggle');
		},
		error : function(XHR, status, error) {
			jQuery.ajaxSettings.traditional = false;
			hideLoding();
			console.error(status + " : " + error);
		}
	});
}

//DCP 변환
$('#dcpConvert').on('click',function(){
	var items = getItem();
	if(items[0] !== undefined){
		var ext = items[0].split(".")[1];
		if(ext !== undefined){
			ext.toLowerCase();
		}
	}else{
		swal("경고","파일을 선택해주세요", "error");
		return;
	}
	
	if( $("#title_d").val() == ""){
		swal("경고","Title을 입력해주세요", "error");
	}else if( $("#annotation_d").val() == "" ){
		swal("경고","Annotation을 입력해주세요", "error");
	}else if( $("#issuer_d").val() == "" ){
		swal("경고","Issuer를 입력해주세요", "error");
	}else if(ext === undefined ){
		swal("경고","mxf 포맷의 파일을 선택하세요", "error");
	}else if( ext != "mxf"){
		swal("경고","mxf 포맷의 파일을 선택하세요", "error");
	}else{
		jQuery.ajaxSettings.traditional = true;
	
       	$.ajax({
       	url: getContextPath() + "/dcp/" + getID() + "/dcp",
			type : "post",
			//contentType : "application/json",
			data : {
				"title" : $("#title_d").val(),
				"annotation" : $("#annotation_d").val(),
				"issuer" : $("#issuer_d").val(),
				"rating" : $("#rating_d").val(),
				"kind" : $("#kind_d").val(),
				"items" : items,
				"path" : $("#path").val()
			},
			//dataType : "json",
			beforeSend: function() {
				showLoding();
		    },
			success : function() {
				swal("성공","DCP 변환완료", "success");
				hideLoding();
				jQuery.ajaxSettings.traditional = false;
				var path = $("#path").val();
	        	fetchFileList(path);
	        	renderTree();
	        	$('#dcpModal').modal('toggle');
			},
			error : function(XHR, status, error) {
				jQuery.ajaxSettings.traditional = false;
				hideLoding();
				console.error(status + " : " + error);
			}
		});
	}
});

//OneStop 변환
$('#oneStopConvert').on('click',function(){
	var items = getItem();
	if(items[0] !== undefined){
		var ext = items[0].split(".")[1];
		if(ext !== undefined){
			ext.toLowerCase();
		}
	}else{
		swal("경고","파일을 선택해주세요", "error");
		return;
	}
	
	if ( $("#title_o").val() == ""){
		swal("경고","Title을 입력해주세요", "error");
	}else if( $("#quality_o").val() == ""){
		swal("경고","Quality를 입력해주세요", "error");
	}else if( !($.isNumeric($("#quality_o").val()))){
		swal("경고","Quality 필드에는 숫자만 입력해주세요", "error");
	}else if( $("#bandWidth_o").val() == ""){
		swal("경고","BandWidth를 입력해주세요", "error");
	}else if( !($.isNumeric($("#bandWidth_o").val()))){
		swal("경고","BandWidth 필드에는 숫자만 입력해주세요", "error");
	}else if( $("#annotation_o").val() == "" ){
		swal("경고","Annotation을 입력해주세요", "error");
	}else if( $("#issuer_o").val() == "" ){
		swal("경고","Issuer를 입력해주세요", "error");
	}else {
		for(var i=0;i<items.length;i++){
			var ext = items[i].split(".")[1];
			if(ext === undefined){
				swal("경고","폴더는 선택 불가능합니다", "error");
				return;
			}else{
				ext = ext.toLowerCase();
				if(ext != "mp4" && ext != "mkv" && ext != "avi" && ext != "mov" && ext != "wmv" && ext != "mpeg" && ext != "m4v" && ext != "asx" && ext != "mpg"&& ext != "ogm" 
						&& ext != "wav" && ext != "srt"){
					swal("경고","파일 포맷을 확인하세요", "error");
					return;
				}
			}
		}
		jQuery.ajaxSettings.traditional = true;
	
       	$.ajax({
       	url: getContextPath() + "/dcp/" + getID() + "/onestop",
			type : "post",
			//contentType : "application/json",
			data : {
				"title" : $("#title_o").val(),
				"quality" : $("#quality_o").val(),
				"bandWidth" : $("#bandWidth_o").val(),
				"annotation" : $("#annotation_o").val(),
				"issuer" : $("#issuer_o").val(),
				"rating" : $("#rating_o").val(),
				"kind" : $("#kind_o").val(),
				"label" : $("#label_o").val(),
				"scale" : $("#scale_o").val(),
				"frameRate" : $("#frameRate_o").val(),
				"items" : items,
				"path" : $("#path_o").val()
			},
			//dataType : "json",
			beforeSend: function() {
				showLoding();
			},
			success : function() {
				swal("성공","OneStop 변환완료", "success");
				hideLoding();
				jQuery.ajaxSettings.traditional = false;
				var path = $("#path").val();
	        	fetchFileList(path);
	        	renderTree();
	        	$('#oneStopModal').modal('toggle');
			},
			error : function(XHR, status, error) {
				jQuery.ajaxSettings.traditional = false;
				hideLoding();
				console.error(status + " : " + error);
			}
		});
	}
});

//변환시 로딩창 활성화
function showLoding(){
	$(".lodingDiv").removeClass("d-none");
};

//변환시 로딩창 비활성화
function hideLoding(){
	$(".lodingDiv").addClass("d-none");
};