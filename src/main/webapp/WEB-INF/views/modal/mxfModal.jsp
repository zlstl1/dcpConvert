<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<div class="modal fade reset" id="mxfModal" tabindex="-1" role="dialog" aria-labelledby="mxfModal" aria-hidden="true">
	<div class="modal-dialog" role="document">
    	<div class="modal-content">
      		<div class="modal-header">
        		<h5 class="modal-title" id="mxfModalTitle">MXF 변환</h5>
        		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
          			<span aria-hidden="true">&times;</span>
        		</button>
      		</div>
	      	<div class="modal-body">
	      		
	      		<form>
					<label for="title_m">Title : </label>
   					<input type="text" id="title_m" name="title"  placeholder="Title">
				
					<label for="label_m">label : </label>
					<div class="select-wrapper">
						<select id="label_m" name="label">
							<option value="smpte">SMPTE</option>
							<option value="interop">INTEROP</option>
						</select>
					</div>
					
					<label for="scale_m">Scale : </label>
					<div class="select-wrapper">
						<select id="scale_m" name="scale">
							<option value="scope" >Scope (2048:858 / 2.39)</option>
							<option value="flat">Flat (1988:1080 / 1.85)</option>
						</select>
					</div>
					
					<label for="frameRate_m">FrameRate : </label>
					<div class="select-wrapper">
						<select id="frameRate_m" name="frameRate">
							<option value="24">24</option>
							<option value="25">25</option>
							<option value="30">30</option>
							<option value="48">48</option>
							<option value="50">50</option>
							<option value="60">60</option>
							<option value="96">96</option>
						</select>
					</div>
					
					<label for="fileType_m">FileType : </label>
					<div class="select-wrapper">
						<select id="fileType_m" name="fileType">
							<option value="picture">picture</option>
							<option value="sound">sound</option>
							<option value="subtitle">subtitle</option>
						</select>
					</div>

					<div class="mt-2 mb-2">
						<input type="checkbox" class="encryption" id="encryption_m" name="encryption_m" value="mxf">
						<label for="encryption_m">Enable Encryption</label>
					</div>
					
					<div class="input-group mb-3">
						<div class="input-group-prepend">
					    	<span class="input-group-text"><label for="key_mxf">Key(32 char) : </label></span>
						</div>
						<input type="text" id="key_mxf" name="key_mxf" aria-describedby="key_mxf" disabled="disabled" value="00000000000000000000000000000000">
					</div>
					
					<div class="input-group mb-3">
						<div class="input-group-prepend">
					    	<span class="input-group-text"><label for="keyID_mxf">Key ID(32 char) : </label></span>
						</div>
						<input type="text" id="keyID_mxf" name="keyID_mxf" aria-describedby="keyID_mxf" disabled="disabled" value="00000000-0000-0000-0000-000000000000">
					</div>
					
					<div class="form-group">
						<label for="quality_t">파일 경로 : </label>
						<div class="d-flex">
			  				<input type="text" class="form-control w-75 flex-fill path" id="path_m" name="path" placeholder="File Path (Default : Home Folder)" disabled="disabled">
			  				<button type="button" class="button special flex-fill" id="explorerBtn" data-toggle="modal" data-target="#explorerModal">파일 경로</button>
						</div>
					</div>
				</form>
	      
	      	</div>
	      	<div class="modal-footer">
	        	<button type="button" class="button" data-dismiss="modal">닫기</button>
	        	<button type="button" class="button special" id="mxfConvert">변환</button>
	      	</div>
    	</div>
  	</div>
</div>