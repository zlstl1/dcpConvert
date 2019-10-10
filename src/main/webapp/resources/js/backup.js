	/* tiff ajax */
	$('#tiffConvert').on('click',function(){
	    var frm = document.getElementById('tiffForm');
	    frm.method = 'POST';
	    frm.enctype = 'multipart/form-data';
        
	    var formData = new FormData(frm);
        
        $.ajax({
            url:'${pageContext.request.contextPath }/dcp/tiff',
            type:'POST',
            data:formData,
            contentType:false,
            processData:false,
            success : function() {
            	alert("TIFF 변환완료");
			},
			error : function(XHR, status, error) {
				console.error(status + " : " + error);
			}

        })
	});
	
	$('#jpegConvert').on('click',function(){
	    var frm = document.getElementById('jpegForm');
	    frm.method = 'POST';
	    frm.enctype = 'multipart/form-data';
        
	    var formData = new FormData(frm);
        
        $.ajax({
            url:'${pageContext.request.contextPath }/dcp/jpeg',
            type:'POST',
            data:formData,
            contentType:false,
            processData:false,
            success : function() {
            	alert("JPEG 변환완료");
			},
			error : function(XHR, status, error) {
				console.error(status + " : " + error);
			}

        })
	});
	
	$('#mxfConvert').on('click',function(){
	    var frm = document.getElementById('mxfForm');
	    frm.method = 'POST';
	    frm.enctype = 'multipart/form-data';
        
	    var formData = new FormData(frm);
        
        $.ajax({
            url:'${pageContext.request.contextPath }/dcp/mxf',
            type:'POST',
            data:formData,
            contentType:false,
            processData:false,
            success : function() {
            	alert("MXF 변환완료");
			},
			error : function(XHR, status, error) {
				console.error(status + " : " + error);
			}

        })
	});
	
	$('#dcpConvert').on('click',function(){
	    var frm = document.getElementById('dcpForm');
	    frm.method = 'POST';
	    frm.enctype = 'multipart/form-data';
        
	    var formData = new FormData(frm);
        
        $.ajax({
            url:'${pageContext.request.contextPath }/dcp/dcp',
            type:'POST',
            data:formData,
            contentType:false,
            processData:false,
            success : function() {
            	alert("DCP 변환완료");
			},
			error : function(XHR, status, error) {
				console.error(status + " : " + error);
			}

        })
	});
	
	$('#oneStopConvert').on('click',function(){
	    var frm = document.getElementById('oneStopForm');
	    frm.method = 'POST';
	    frm.enctype = 'multipart/form-data';
        
	    var formData = new FormData(frm);
        
        $.ajax({
            url:'${pageContext.request.contextPath }/dcp/onestop',
            type:'POST',
            data:formData,
            contentType:false,
            processData:false,
            timeout:0,
            async:false,
            success : function() {
            	alert("OneStop 변환완료");
			},
			error : function(XHR, status, error) {
				console.error(status + " : " + error);
			}

        })
	});