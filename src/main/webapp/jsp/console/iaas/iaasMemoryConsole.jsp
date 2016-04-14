<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<head>
<%@ include file="/jsp/common/common.jsp"%>

  
</head> 
<body>     
  <div class="big_k"><!--包含头部 主体-->   
   <!--导航-->
   <%@ include file="/jsp/common/header_console.jsp"%>
      
   <div class="container chanp">
   <%@ include file="/jsp/common/leftMenu_console.jsp"%>
  <div class="row chnap_row">
  
  <div class="col-md-6 right_list">
     
     <div class="Open_cache">
        <div class="Open_cache_table">
			<ul>
			<li><a href="#">Iaas存储</a></li> 
			</ul>  
        </div> 
		<div class="Open_cache_table" style="background:rgb(245,245,245);height:30px;vertical-align:middle;text-align:center;line-height:30px;padding-left:40%">
			 
		</div> 
     	<div class="Open_cache">  
	        <div class="Open_cache_list" style="margin:0"> 
	          	<div class="Open_cache_list_tow">
	          		 <table id="table_detail"  style="width:100%; ">
						<tr>
							<th>存储标签</th>
							<th>容量</th>
							<th>挂载虚拟机</th>
						</tr>
						<c:forEach items="${prodList }" var="prod">
							<tr>
								<td>${prod.userServParamMap.memoryType }</td>
								<td>${prod.userServParamMap.memorySize }</td>
								<td>${prod.userServParamMap.machineName }</td>
								
							</tr>
						</c:forEach>							
					 </table>
	           </div>                
	        </div>  
    	</div>   
     </div> 
 
  </div>
</div>

</div>
</div>  
<!-- 清理数据 -->
		<div class="modal fade bs-example-modal-sm" id="clean_model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-dialog">
			<div class="modal-content">
			  <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title" id="myModalLabel">全部清理数据</h4>
			  </div>
			  <div class="modal-body">
			       清理数据后将无法修复，您确认此操作吗？
				   <button type="button" class="btn btn-default" data-dismiss="modal" id = "cleanAll_back">取消</button>
				<button type="button" class="btn btn-primary" onclick="cleanAll()">确认</button>
			  </div> 
			</div>
		  </div>
		</div>
		<div class="modal fade bs-example-modal-sm" id="cancle_model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-dialog">
			<div class="modal-content">
			  <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title" id="myModalLabel">注销</h4>
			  </div>
			  <div class="modal-body">
			       注销后将无法修复，您确认此操作吗？
				   <button type="button" class="btn btn-default" data-dismiss="modal" id = "cancle_back">取消</button>
				<button type="button" class="btn btn-primary" onclick="cancle()">确认</button>
			  </div> 
			</div>
		  </div>
		</div>
<!--页脚-->
<jsp:include page="/jsp/common/footer_new.jsp"></jsp:include>
 
  </body>
</html>
