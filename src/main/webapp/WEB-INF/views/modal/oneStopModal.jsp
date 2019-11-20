<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<div class="modal fade reset" id="oneStopModal" tabindex="-1" role="dialog" aria-labelledby="oneStopModal" aria-hidden="true">
	<div class="modal-dialog" role="document">
    	<div class="modal-content">
      		<div class="modal-header">
        		<h5 class="modal-title" id="oneStopModalTitle">OneStop 변환</h5>
        		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
          			<span aria-hidden="true">&times;</span>
        		</button>
      		</div>
	      	<div class="modal-body">
	      		
	      		<form>
					<label for="title_o">Title : </label>
   					<input type="text" id="title_o" name="title" placeholder="Title">
					
					<label for="quality_o">Quality : </label>
   					<input type="text" id="quality_o" name="quality" placeholder="Compress Quality (1:high, 31:low)">
					
					<label for="bandWidth_o">BandWidth : </label>
   					<input type="text" id="bandWidth_o" name="bandWidth" placeholder="BandWidth(10~250 mb/s)">
					
					<label for="annotation_o">Annotation : </label>
   					<input type="text" id="annotation_o" name="annotation"  placeholder="Annotation">
					
					<label for="issuer_o">Issuer : </label>
   					<input type="text" id="issuer_o" name="issuer"  placeholder="Issuer">
				
					<label for="rating_o">Rating : </label>
					<div class="select-wrapper">
						<select id="rating_o" name="rating">
							<option value="G">G</option>
							<option value="PG">PG</option>
							<option value="PG-13">PG-13</option>
							<option value="R">R</option>
							<option value="NC-17">NC-17</option>
						</select>
					</div>
					
					<label for="kind_o">Kind : </label>
					<div class="select-wrapper">
						<select id="kind_o" name="kind">
							<option value="advertisement">advertisement</option>
							<option value="feature">feature</option>
							<option value="policy">policy</option>
							<option value="psa">psa</option>
							<option value="rating">rating</option>
							<option value="short">short</option>
							<option value="teaser">teaser</option>
							<option value="test">test</option>
							<option value="trailer">trailer</option>
							<option value="transitional">transitional</option>
						</select>
					</div>
					
					<label for="label_o">label : </label>
					<div class="select-wrapper">
						<select id="label_o" name="label">
							<option value="smpte">SMPTE</option>
							<option value="interop">INTEROP</option>
						</select>
					</div>
					
					<label for="scale_o">Scale : </label>
					<div class="select-wrapper">
						<select id="scale_o" name="scale">
							<option value="scope" >Scope (2048:858 / 2.39)</option>
							<option value="flat">Flat (1998:1080 / 1.85)</option>
						</select>
					</div>
					
					<label for="frameRate_o">FrameRate : </label>
					<div class="select-wrapper">
						<select id="frameRate_o" name="frameRate">
							<option value="24">24</option>
							<option value="25">25</option>
							<option value="30">30</option>
							<option value="48">48</option>
							<option value="50">50</option>
							<option value="60">60</option>
							<option value="96">96</option>
						</select>
					</div>
					
					<div class="mt-2 mb-2">
						<input type="checkbox" class="encryption" id="encryption_o" name="encryption_o" value="onestop">
						<label for="encryption_o">Enable Encryption</label>
					</div>
					
					<div class="input-group mb-3">
						<div class="input-group-prepend">
					    	<span class="input-group-text"><label for="key_onestop">Key(32 char) : </label></span>
						</div>
						<input type="text" id="key_onestop" name="key_onestop" aria-describedby="key_onestop" disabled="disabled" value="00000000000000000000000000000000">
					</div>
					
					<div class="input-group mb-3">
						<div class="input-group-prepend">
					    	<span class="input-group-text"><label for="keyID_onestop">Key ID(32 char) : </label></span>
						</div>
						<input type="text" id="keyID_onestop" name="keyID_onestop" aria-describedby="keyID_onestop" disabled="disabled" value="00000000-0000-0000-0000-000000000000">
					</div>
					
					<div class="form-group">
						<label for="quality_t">파일 경로 : </label>
						<div class="d-flex">
			  				<input type="text" class="form-control w-75 flex-fill path" id="path_o" name="path" placeholder="File Path (Default : Home Folder)" disabled="disabled">
			  				<button type="button" class="button special flex-fill" id="explorerBtn" data-toggle="modal" data-target="#explorerModal">파일 경로</button>
						</div>
					</div>
				</form>
	      
	      	</div>
	      	<div class="modal-footer">
	        	<button type="button" class="button" data-dismiss="modal">닫기</button>
	        	<button type="button" class="button special" id="oneStopConvert">변환</button>
	      	</div>
    	</div>
  	</div>
</div>