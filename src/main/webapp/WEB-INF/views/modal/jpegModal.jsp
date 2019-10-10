<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<div class="modal fade reset" id="jpegModal" tabindex="-1" role="dialog" aria-labelledby="jpegModal" aria-hidden="true">
	<div class="modal-dialog" role="document">
    	<div class="modal-content">
      		<div class="modal-header">
        		<h5 class="modal-title" id="jpegModalTitle">JPEG 변환</h5>
        		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
          			<span aria-hidden="true">&times;</span>
        		</button>
      		</div>
	      	<div class="modal-body">
	      		
	      		<form>
					<label for="bandWidth_j">BandWidth : </label>
   					<input type="text" id="bandWidth_j" name="bandWidth" placeholder="BandWidth(10~250 mb/s)">
					
					<label for="frameRate_j">FrameRate : </label>
					<div class="select-wrapper">
						<select id="frameRate_j" name="frameRate">
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
			  				<input type="text" class="form-control w-75 flex-fill path" id="path_j" name="path" placeholder="File Path (Default : Home Folder)" disabled="disabled">
			  				<button type="button" class="button special flex-fill" id="explorerBtn" data-toggle="modal" data-target="#explorerModal">파일 경로</button>
						</div>
					</div>
					
				</form>
	      
	      	</div>
	      	<div class="modal-footer">
	        	<button type="button" class="button" data-dismiss="modal">닫기</button>
	        	<button type="button" class="button special" id="jpegConvert">변환</button>
	      	</div>
    	</div>
  	</div>
</div>