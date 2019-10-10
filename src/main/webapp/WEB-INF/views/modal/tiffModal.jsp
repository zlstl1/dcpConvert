<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<div class="modal fade reset" id="tiffModal" tabindex="-1" role="dialog" aria-labelledby="tiffModal" aria-hidden="true">
	<div class="modal-dialog" role="document">
    	<div class="modal-content">
      		<div class="modal-header">
        		<h5 class="modal-title" id="tiffModalTitle">TIFF 변환</h5>
        		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
          			<span aria-hidden="true">&times;</span>
        		</button>
      		</div>
	      	<div class="modal-body">
	      		
	      		<form>
					<label for="title_t">Title : </label>
  					<input type="text" id="title_t" name="title" placeholder="Title">
					
					<label for="length">Length : </label>
  					<input type="text" id="length_t" name="length" placeholder="Length of Title">
					
					<label for="quality_t">Quality : </label>
  					<input type="text" id="quality_t" name="quality" placeholder="Compress Quality (1:high, 31:low)">
					
					<label for="scale_t">Scale : </label>
					<div class="select-wrapper">
						<select id="scale_t" name="scale">
							<option value="scope" >Scope (2048:858 / 2.39)</option>
							<option value="flat">Flat (1988:1080 / 1.85)</option>
						</select>
					</div>
					
					<label for="frameRate_t">FrameRate : </label>
					<div class="select-wrapper">
						<select id="frameRate_t" name="frameRate">
							<option value="24">24</option>
							<option value="25">25</option>
							<option value="30">30</option>
							<option value="48">48</option>
							<option value="50">50</option>
							<option value="60">60</option>
							<option value="96">96</option>
						</select>
					</div>
					
					<div class="form-group">
						<label for="quality_t">파일 경로 : </label>
						<div class="d-flex">
			  				<input type="text" class="form-control w-75 flex-fill path" id="path_t" name="path" placeholder="File Path (Default : Home Folder)" disabled="disabled">
			  				<button type="button" class="button special flex-fill" id="explorerBtn" data-toggle="modal" data-target="#explorerModal">파일 경로</button>
						</div>
					</div>
					
				</form>
	      
	      	</div>
	      	<div class="modal-footer">
	        	<button type="button" class="button" data-dismiss="modal">닫기</button>
	        	<button type="button" class="button special" id="tiffConvert">변환</button>
	      	</div>
    	</div>
  	</div>
</div>