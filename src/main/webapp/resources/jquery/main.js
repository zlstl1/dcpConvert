function getContextPath() {
  var hostIndex = location.href.indexOf( location.host ) + location.host.length;
  return location.href.substring( hostIndex, location.href.indexOf('/', hostIndex + 1) );
};

function getID(){
	return $("#email").val();
}

function getDirPromise(){
	var promise = $.ajax({  
	    type:"GET",
	    url: getContextPath() + "/dcp/" + getID() + "/getdirsize",
	});
	return promise;
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

//uploadFilde 선택시 promise를 통해 dirSize 가져오기 
$("#uploadFile").on("change",function(){
	var promise = getDirPromise();
	promise.done(uploadFunction);
});

//파일 업로드시 프로그레스 바 구현
function setProgress(percent) {
	var $progressBar = $("#uploadProgressBar");
	$progressBar.css("width", Math.round(percent) + "%");
	$progressBar.html(Math.round(percent) + "%");
}

//다운로드 버튼 클릭시 promise를 통해 dirSize 가져오기 
$("#downloadBtn").on("click",function(){
	var promise = getDirPromise();
	promise.done(downloadCheckFunction);
});

//다운로드 버튼 클릭시 다운로드 기능
function downloadFunc(){
	var items = getItem();
	if(items[0] !== undefined){
		ext = items[0].split(".");
	}else{
		swal.fire("경고","파일을 선택해주세요.", "error");
		return;
	}
	
	if(ext.length < 2){
		if(items.length > 1){
			swal.fire("경고","폴더는 하나씩 다운 가능합니다.", "error");
		}else{
			swal.fire({
				title: "경고",
			  	text: "폴더 다운로드는 압축으로 인해 오래 걸릴수 있습니다.",
			  	type: "warning",
			  	showCancelButton: true,
			  	confirmButtonClass: "btn-danger",
			  	confirmButtonText: "계속 진행",
			  	cancelButtonText: "취소",
			}).then(function (result) {
	            if (result.dismiss === "cancel") { 
	                return false;
	            }
	            window.location.href=getContextPath() + '/dcp/' + getID() + '/downloadfolder?path=' + items[0].split("/");
	            //window.open(getContextPath() + '/dcp/' + getID() + '/downloadfolder?path=' + items[0].split("/"),'_blank');
	        });
		}
	}else{
		for(var i=0; i < items.length; i++){
			window.location.href=getContextPath() + '/dcp/' + getID() + '/downloadfile?path=' + items[i].split("/");
			sleep(300);
		}
		
	}
};

//다중 다운로드시 interval
function sleep (delay) {
   var start = new Date().getTime();
   while (new Date().getTime() < start + delay);
}

//페이지 로딩시 파일 이동 모달창에 트리 그리기
renderTree();

//디렉토리 트리 그리기
function renderTree(){
	$("#tree").fancytree({
		source: {
			url: getContextPath() + "/dcp/" + getID() + "/getdirectorylist"
	   	}
	});
}

//트리 전체 열기/닫기 토글 기능
function treeExpandCollapseFunc(){
	var treeBtn = $('#treeExpandCollapseBtn');
	if( treeBtn.val() === "expand"){
		expandFunc();
		treeBtn.val("collapse");
		treeBtn.html("전체 닫기");
	}else{
		collapseFunc();
		treeBtn.val("expand");
		treeBtn.html("전체 열기");
	}
}

//트리 전체 열기 기능
function expandFunc(){
	$("#tree").fancytree("getTree").expandAll();
};

//트리 전체 닫기 기능
function collapseFunc(){
	$("#tree").fancytree("getTree").expandAll(false);
};

//파일 탐색기창의 폴더 생성 기능
function treeMakeFolderFunc(){
	var node = $("#tree").fancytree("getActiveNode");
	if(!node){
		swal.fire("경고","생성할 폴더 위치를 선택하세요.", "error");
	}
	var path = node.key;
	var folderName = path + "/" + $("#treeFolderName").val();
	if($("#treeFolderName").val() === ""){
		folderName = "";
	}
	makeFolder(folderName);
	resetTree();
}

//파일 탐색기창의 폴더 삭제 기능
function treeDeleteFolderFunc(){
	var node = $("#tree").fancytree("getActiveNode");
	if(!node){
		swal.fire("경고","삭제하실 폴더를 선택하세요.", "error");
	}else if(node.key === "/"){
		swal.fire("경고","최상위 폴더는 삭제할 수 없습니다.", "error");
	}else{
		deleteFunc(node.key);
	}
	resetTree();
}

//파일 탐색기창의 폴더명 변경 기능
function treeRenameFunc(){
	var node = $("#tree").fancytree("getActiveNode");
	if(!node){
		swal.fire("경고","변경하실 폴더를 선택하세요.", "error");
	}else if($("#treeFolderName").val() === ""){
		swal.fire("경고","변경하실 폴더명을 입력하세요.", "error");
	}else if(node.key === "/"){
		swal.fire("경고","최상위 폴더는 변경할 수 없습니다.", "error");
	}else{
		renameFunc(node.key, $('#treeFolderName').val());
	}
	resetTree();
}

function resetTree(){
	var treeBtn = $('#treeExpandCollapseBtn');
	$('#treeFolderName').val("");
	setTimeout(function() {
		expandFunc();
	}, 1500);
	treeBtn.val("collapse");
	treeBtn.html("전체 닫기");
}

$("#explorerModal").on("shown.bs.modal",function(){
	var items = getItem();
	if(items[0] === undefined){
		$('#explorerModal').modal('hide');
		swal.fire("경고","파일 또는 폴더를 선택해주세요.", "error");
	}
});

//파일 탐색기 모달창에서 선택 버튼 클릭시 파일 이동 기능
$("#explorerModalSelect").on("click",function(){
	var items = getItem();
	var node = $("#tree").fancytree("getActiveNode");
	if(!node){
		swal.fire("경고","이동하실 폴더를 선택하세요.", "error");
		return;
	}
	for(var i=0; i<items.length; i++){
		if( items[i] == node.key){
			swal.fire("경고","선택된 폴더로 폴더를 이동하는것은 불가능합니다.", "error");
			$('#explorerModal').modal('toggle');
			return;
		}
	}
	moveFile(node.key, items);
   $('#explorerModal').modal('toggle');
}); 

//파일 탐색기 모달창에서 선택 버튼을 두개로 만들고 하나는 파일 이동 기능 하나는 변환시 경로 지정 기능
$('#explorerBtn').on('click', function (e) {
	$("#explorerModalSelect").attr("hidden",false);
	$("#convertModalSelect").attr("hidden",true);
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
        	swal.fire("성공","이동 완료", "success");
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

$("#renameModal").on("shown.bs.modal",function(){
	var items = getItem();
	if (items.length == 0 ){
		swal.fire("경고","이름을 변경할 파일 또는 폴더를 선택하세요.", "error");
		$('#renameModal').modal('hide');
	}else if (items.length > 1){
		swal.fire("경고","파일 또는 폴더를 하나만 선택하세요.", "error");
		$('#renameModal').modal('hide');
	}
});

//파일명 변경
$("#renameFuncBtn").on("click",function(){
	var items = getItem();
	if ($("#rename").val() === ""){
		swal.fire("경고","변경할 파일 또는 폴더명을 입력하세요.", "error");
	}else{
		renameFunc(items, $('#rename').val());
		$('#renameModal').modal('hide');
	}
});

function renameFunc(items, rename){
	swal.fire({
		title: "경고",
	  	text: "이름을 변경하시겠습니까?",
	  	type: "warning",
	  	showCancelButton: true,
	  	confirmButtonClass: "btn-danger",
	  	confirmButtonText: "변경",
	  	cancelButtonText: "취소",
	}).then(function (result) {
		if (result.dismiss === "cancel") { 
			return false;
        }
		jQuery.ajaxSettings.traditional = true;
		
		$.ajax({
			 url: getContextPath() + "/dcp/" + getID() + "/renamefile",
	        type:'POST',
	        data:{
	        	"items" : items,
	        	"rename" : rename
	        },
	        beforeSend: function() {
				showLoding();
			},
	        success : function() {
	        	swal.fire("성공","변경 완료", "success");
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
    });
}

//파일 삭제 버튼 클릭시 파일 삭제 기능
$("#deleteBtn").on("click",function(){
	var items = getItem();
	if (items.length == 0 ){
		swal.fire("경고","삭제하실 파일 또는 폴더를 선택하세요.", "error");
	}else{
		deleteFunc(items);
	}
});

function deleteFunc(items){
	swal.fire({
		title: "경고",
	  	text: "파일을 지우시겠습니까?",
	  	type: "warning",
	  	showCancelButton: true,
	  	confirmButtonClass: "btn-danger",
	  	confirmButtonText: "지우기",
	  	cancelButtonText: "취소",
	}).then(function (result) {
        if (result.dismiss === "cancel") { 
            return false;
        }
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
	        	swal.fire("성공","삭제 완료", "success");
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
    });
}

//폴더 생성 모달의 생성 버튼  클릭시 폴더 생성
$('#makeFolderBtn').on('click',function(){
	var folderName = $("#path").val() + "/" + $("#folderName").val();
	if(folderName === ""){
		folderName = "";
	}
	makeFolder(folderName);
	$('#makeFolderModal').modal('hide');
});

function makeFolder(folderName){
	if(folderName == ""){
		swal.fire("경고","폴더명을 입력하세요.", "error");
	}else{
		$.ajax({
			url: getContextPath() + "/dcp/" + getID() + "/makefolder",
			type : "post",
			//contentType : "application/json",
			data : {
				"folderName" : folderName
			},
			dataType : "text",
			beforeSend: function() {
				showLoding();
			},
			success : function() {
				swal.fire("성공","폴더 생성 완료", "success");
				hideLoding();
				var path = $("#path").val();
	        	fetchFileList(path);
	        	renderTree();
			},
			error : function(XHR, status, error) {
				console.error(status + " : " + error);
			}
		});
	}
}

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
	str += '	<div class="upper_folder card d-block" style="width: 10rem;">';
  	str += '		<img src="' + getContextPath() + '/resources/img/upper_folder.png" class="card-img-top" alt="...">';
  	str += '		<div class="card-body">';
    str += '			<p class="card-text text-truncate">..</p>';
  	str += '		</div>';
	str += '	</div>';
	str += '</div>';
	str += '<div class="mr-1 ml-1 mb-1">';
	str += '	<div class="make_folder card d-block" style="width: 10rem;">';
  	str += '		<img src="' + getContextPath() + '/resources/img/make_folder.png" class="card-img-top" alt="...">';
  	str += '		<div class="card-body">';
    str += '			<p class="card-text text-truncate">폴더 생성</p>';
  	str += '		</div>';
	str += '	</div>';
	str += '</div>';

	for(var i=0; i<fileList.length; i++){
		str += '<div class="mr-1 ml-1 mb-1">';
		str += '<div class="' + fileList[i].fileType +' card selectCard d-block" style="width: 10rem;">';
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

//파일 탐색기 모달창에서 선택 버튼 클릭시 변환 모달창에 경로 기입 기능
$("#convertModalSelect").on("click",function(){
	var node = $("#tree").fancytree("getActiveNode");
    if( node ){
      	$(".path").val(node.key);
      	$('#explorerModal').modal('toggle');
    }else{
    	swal.fire("경고","경로를 선택해 주세요.", "error");
    }
});

//변환 버튼 클릭시 convertArea 보이기/감추기
$('#convertBtn').click(function(){
	var convertArea = $('#convertArea')
	if (convertArea.css("display") === "none") {
		convertArea.css("display", "flex");
	} else {
		convertArea.css("display", "none");
	}
});

//TIFF 변환
$('#tiffConvert').on('click',function(){
	var items = getItem();
	if(items[0] !== undefined){
		var pos = items[0].lastIndexOf(".");
		var ext = items[0].substring(pos + 1, items[0].length);
		if(pos !== -1){
			ext.toLowerCase();
		}
	}else{
		swal.fire("경고","파일을 선택해주세요.", "error");
		return;
	}
	
	if ( $("#title_t").val() == ""){
		swal.fire("경고","Title을 입력해주세요.", "error");
	}else if( $("#length_t").val() == ""){
		swal.fire("경고","Length를 입력해주세요.", "error");
	}else if( !($.isNumeric($("#length_t").val()))){
		swal.fire("경고","Length 필드에는 숫자만 입력해주세요.", "error");
	}else if( $("#quality_t").val() == ""){
		swal.fire("경고","Quality를 입력해주세요.", "error");
	}else if( !($.isNumeric($("#quality_t").val()))){
		swal.fire("경고","Quality 필드에는 숫자만 입력해주세요.", "error");
	}else if(items.length > 1){
		swal.fire("경고","동영상 파일 하나를 선택하세요.", "error");
	}else if(ext != "mp4" && ext != "ts" && ext != "mkv" && ext != "avi" && ext != "mov" && ext != "wmv" && ext != "mpeg" && ext != "m4v" && ext != "asx" && ext != "mpg"&& ext != "ogm"){
		swal.fire("경고","동영상 파일을 선택하세요.", "error");
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
				swal.fire("성공","TIFF 변환완료", "success");
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
		var pos = items[0].lastIndexOf(".");
		var ext = items[0].substring(pos + 1, items[0].length);
		if(pos !== -1){
			ext.toLowerCase();
		}
	}else{
		swal.fire("경고","파일을 선택해주세요.", "error");
		return;
	}
	
	if( $("#bandWidth_j").val() == ""){
		swal.fire("경고","BandWidth를 입력해주세요.", "error");
	}else if( !($.isNumeric($("#bandWidth_j").val()))){
		swal.fire("경고","BandWidth 필드에는 숫자만 입력해주세요.", "error");
	}else if(ext != "tiff" && ext != "tif" && ext != "bmp"){
		swal.fire("경고","TIFF 또는 BMP 파일을 선택하세요.", "error");
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
				swal.fire("성공","JPEG변환완료", "success");
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
		var pos = items[0].lastIndexOf(".");
		var ext = items[0].substring(pos + 1, items[0].length);
		if(pos !== -1){
			ext.toLowerCase();
		}
	}else{
		swal.fire("경고","파일을 선택해주세요.", "error");
		return;
	}
	
	if( $("#title_m").val() == ""){
		swal.fire("경고","Title을 입력해주세요.", "error");
	}else if( $("#fileType_m").val() == "picture" ){
		if(items.length > 1){
			swal.fire("경고","JPEG2000 파일을 포함한 폴더 하나를 선택하세요.", "error");
		}else if(pos !== -1){
			swal.fire("경고","JPEG2000 포맷의 파일이 있는 폴더를 선택하세요.", "error");
		}else{
			mxfConvert(items);
		}
	}else if( $("#fileType_m").val() == "sound" ){
		if(items.length > 1){
			swal.fire("경고","WAV 파일을 포함한 폴더 하나를 선택하세요.", "error");
		}else if(pos !== -1){
			swal.fire("경고","WAV 포맷의 파일이 있는 폴더를 선택하세요.", "error");
		}else{
			mxfConvert(items);
		}
	}else if( $("#fileType_m").val() == "subtitle" ){
		if(items.length > 1){
			swal.fire("경고","SRT 포맷의 파일 하나를 선택하세요.", "error");
		}else if(ext != "srt"){
			swal.fire("경고","SRT 포맷의 파일을 선택하세요.", "error");
		}else{
			mxfConvert(items);
		}
	}else{
		mxfConvert(items);
	}
});

function mxfConvert(items){
	var encryption;
	if ($("#encryption").prop("checked")) {
		encryption = true;
	}else{
		encryption = false;
	}
	
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
			"encryption" : encryption,
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
			swal.fire("성공","MXF 변환완료", "success");
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
		var pos = items[0].lastIndexOf(".");
		var ext = items[0].substring(pos + 1, items[0].length);
		if(pos !== -1){
			ext.toLowerCase();
		}
	}else{
		swal.fire("경고","파일을 선택해주세요.", "error");
		return;
	}
	
	if( $("#title_d").val() == ""){
		swal.fire("경고","Title을 입력해주세요.", "error");
	}else if( $("#annotation_d").val() == "" ){
		swal.fire("경고","Annotation을 입력해주세요.", "error");
	}else if( $("#issuer_d").val() == "" ){
		swal.fire("경고","Issuer를 입력해주세요.", "error");
	}else if(pos === -1 ){
		swal.fire("경고","mxf 포맷의 파일을 선택하세요.", "error");
	}else if( ext != "mxf"){
		swal.fire("경고","mxf 포맷의 파일을 선택하세요.", "error");
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
				swal.fire("성공","DCP 변환완료", "success");
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
		var pos = items[0].lastIndexOf(".");
		var ext = items[0].substring(pos + 1, items[0].length);
		if(pos !== -1){
			ext.toLowerCase();
		}
	}else{
		swal.fire("경고","파일을 선택해주세요.", "error");
		return;
	}
	
	if ( $("#title_o").val() == ""){
		swal.fire("경고","Title을 입력해주세요.", "error");
	}else if( $("#quality_o").val() == ""){
		swal.fire("경고","Quality를 입력해주세요.", "error");
	}else if( !($.isNumeric($("#quality_o").val()))){
		swal.fire("경고","Quality 필드에는 숫자만 입력해주세요.", "error");
	}else if( $("#bandWidth_o").val() == ""){
		swal.fire("경고","BandWidth를 입력해주세요.", "error");
	}else if( !($.isNumeric($("#bandWidth_o").val()))){
		swal.fire("경고","BandWidth 필드에는 숫자만 입력해주세요.", "error");
	}else if( $("#annotation_o").val() == "" ){
		swal.fire("경고","Annotation을 입력해주세요.", "error");
	}else if( $("#issuer_o").val() == "" ){
		swal.fire("경고","Issuer를 입력해주세요.", "error");
	}else {
		for(var i=0;i<items.length;i++){
			var pos = items[i].lastIndexOf(".");
			var ext = items[i].substring(pos + 1, items[0].length);
			if(pos === -1){
				swal.fire("경고","폴더는 선택 불가능합니다.", "error");
				return;
			}else{
				ext = ext.toLowerCase();
				if(ext != "mp4" && ext != "ts" && ext != "mkv" && ext != "avi" && ext != "mov" && ext != "wmv" && ext != "mpeg" && ext != "m4v" && ext != "asx" && ext != "mpg"&& ext != "ogm" 
						&& ext != "wav" && ext != "srt"){
					swal.fire("경고","파일 포맷을 확인하세요.", "error");
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
				swal.fire("성공","OneStop 변환완료", "success");
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

//모달창 닫을때 내용 초기화
$(".reset").on("shown.bs.modal",function(){
	var promise = getDirPromise();
	promise.done(convertCheckFunction);
});

//변환시 로딩창 활성화
function showLoding(){
	$(".lodingDiv").removeClass("d-none");
};

//변환시 로딩창 비활성화
function hideLoding(){
	$(".lodingDiv").addClass("d-none");
};