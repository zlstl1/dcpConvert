<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<div class="modal fade" id="explorerModal" tabindex="-1" role="dialog" aria-labelledby="explorerModal" aria-hidden="true">
	<div class="modal-dialog" role="document">
    	<div class="modal-content">
      		<div class="modal-header">
        		<h5 class="modal-title" id="explorerModalTitle">파일 탐색기</h5>
        		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
          			<span aria-hidden="true">&times;</span>
        		</button>
      		</div>
	      	<div class="modal-body">
	      		
	      		<button type="button" class="button small" onclick="expandFunc()">전체 열기</button>
	      		<button type="button" class="button small" onclick="collapseFunc()">전체 닫기</button>
	      		
	      		<div id="tree" class="mt-2">
				    <ul id="treeData" style="display: none;">
				    </ul>
				 </div>
	      
	      	</div>
	      	<div class="modal-footer">
	        	<button type="button" class="button" data-dismiss="modal">닫기</button>
	        	<button type="button" class="button special" id="explorerModalSelect">선택</button>
	        	<button type="button" class="button special" id="convertModalSelect">선택</button>
	      	</div>
    	</div>
  	</div>
</div>