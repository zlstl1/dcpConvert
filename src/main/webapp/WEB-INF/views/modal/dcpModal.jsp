<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<div class="modal fade reset" id="dcpModal" tabindex="-1" role="dialog" aria-labelledby="dcpModal" aria-hidden="true">
	<div class="modal-dialog" role="document">
    	<div class="modal-content">
      		<div class="modal-header">
        		<h5 class="modal-title" id="dcpModalTitle">DCP 변환</h5>
        		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
          			<span aria-hidden="true">&times;</span>
        		</button>
      		</div>
	      	<div class="modal-body">
	      		
	      		<form>
					<label for="title_d">Title : </label>
   					<input type="text" id="title_d" name="title"  placeholder="Title">
					
					<label for="annotation_d">Annotation : </label>
   					<input type="text" id="annotation_d" name="annotation"  placeholder="Annotation">
					
					<label for="issuer_d">Issuer : </label>
   					<input type="text" id="issuer_d" name="issuer"  placeholder="Issuer">
				
					<label for="rating_d">Rating : </label>
					<div class="select-wrapper">
						<select id="rating_d" name="rating">
							<option value="G">G</option>
							<option value="PG">PG</option>
							<option value="PG-13">PG-13</option>
							<option value="R">R</option>
							<option value="NC-17">NC-17</option>
						</select>
					</div>
					
					<label for="kind_d">Kind : </label>
					<div class="select-wrapper">
						<select id="kind_d" name="kind">
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

				</form>
	      
	      	</div>
	      	<div class="modal-footer">
	        	<button type="button" class="button" data-dismiss="modal">닫기</button>
	        	<button type="button" class="button special" id="dcpConvert">변환</button>
	      	</div>
    	</div>
  	</div>
</div>