<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<div class="modal fade reset" id="renameModal" tabindex="-1" role="dialog" aria-labelledby="renameModal" aria-hidden="true">
	<div class="modal-dialog" role="document">
    	<div class="modal-content">
      		<div class="modal-header">
        		<h5 class="modal-title" id="renameModalTitle">폴더명 변경</h5>
        		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
          			<span aria-hidden="true">&times;</span>
        		</button>
      		</div>
	      	<div class="modal-body">
	      		
	      		<form>
   					<input type="text" id="rename" name="rename" placeholder="변경할 이름">
				</form>
	      
	      	</div>
	      	<div class="modal-footer">
	        	<button type="button" class="button" data-dismiss="modal">닫기</button>
	        	<button type="button" class="button special" id="renameFuncBtn">변경</button>
	      	</div>
    	</div>
  	</div>
</div>