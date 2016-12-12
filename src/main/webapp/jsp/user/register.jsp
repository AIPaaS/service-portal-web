<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/jsp/common/common.jsp"%>
<title>用户中心</title>
</head>
<body>
	<div class="big_k">
	<jsp:include page="/jsp/common/header.jsp"></jsp:include>
	<div class="row help shenq">


		<div class="steps">

			<div class="steps-tow">
				<div class="steps-tow_A">
					<table width="100%" border="0" cellspacing="1">
						<tr>
							<td class="lan_xi">
								<table border="0" cellspacing="1" align="center">
									<tr>
										<td height="23" align="center" valign="middle"
											class="lan_yuan"><img src="${_base }/resources/images/zc1.png"></td>
									</tr>
								</table>
							</td>
							<td class="hui_xi">
								<table border="0" cellspacing="1" align="center">
									<tr>
										<td height="23" align="center" valign="middle"
											class="hui_yuan"><img src="${_base }/resources/images/zc2.png"></td>
									</tr>
								</table>
							</td>
							<td class="hui_xi">
								<table border="0" cellspacing="1" align="center">
									<tr>
										<td height="23" align="center" valign="middle"
											class="hui_yuan"><img src="${_base }/resources/images/zc3.png"></td>
									</tr>
								</table>
							</td>

						</tr>
						<tr>
							<td height="23" align="center" valign="middle" class="lan_zi">用户注册</td>
							<td height="23" align="center" valign="middle" class="hui_zi">邮箱激活</td>
							<td height="23" align="center" valign="middle" class="hui_zi">注册完成</td>
						</tr>
					</table>
				</div>
			</div>

		</div>
		<form id="registerF">
		<div class="zc_xinxi">

			<ul>
				<li class="you_zi">邮箱：</li>
				<li style="position:relative;">
					<input id="user_name" name="user_name" type="text" class="you_input input-s" style="display:inline-block">
					<!-- <span  class="yaxin-mail">@asiainfo.com</span> -->
				</li>
				<label for="user_name"></label>
			</ul>
			
			<ul>
	          	<li class="you_zi">组织：</li>
	          	<li>
	          	    <select id="orgnize"  name="orgnize" class="pei_select">
	          		  <c:forEach items="${orgList}" var="my_orgnize">
	          			<option value="${my_orgnize.orgId}" style="width:50px;font-size:16px;">${my_orgnize.orgCode}:${my_orgnize.orgName}</option>
	          		  </c:forEach>
	          		</select>
	            </li>
	            <label for="orgnize">组织与资源相对应</label>	
	         </ul>			
			
			<ul>
				<li class="you_zi">电话：</li>
				<li><input id="phone" name="phone"  class="you_input" maxlength="11"></li>
				<label for="phone"></label>
			</ul>

			<ul>
				<li class="you_zi">输入密码：</li>
				<li><input id="user_password" name="user_password" type="password" class="you_input"></li>
				<label for="user_password" class="label"></label>
			</ul>

			<ul>
				<li class="you_zi">确认密码：</li>
				<li><input id="user_password_rep" name="user_password_rep" type="password" class="you_input"></li>
				<label for="user_password_rep" class="label"></label>
			</ul>

			

			<ul>
				<li class="zhuc_btn"><a style ="margin-left: 10px;" id="register" href="javascript:void(0);">注册</a></li>
			</ul>


		</div>
		</form>

	</div>
	
	</div>
	<!--页脚-->
	<jsp:include page="/jsp/common/footer_new.jsp"></jsp:include>
<script type="text/javascript">
		$(function() {
			$(".head").wrap(document.createElement("div")).closest("div").addClass("navigation");
			var registerF = $("#registerF");
			registerF.validate({
				rules : {
					user_name : {
						required : true,
						maxlength : 24,
						email : false,  //只允许是亚信邮箱，不用加邮箱验证
						remote : {
							url : "${_base}/audit/uniqueEmail", //后台处理程序
							type : "post", //数据发送方式
							dataType : "json", //接受数据格式   
							data : { //要传递的数据
								email : function() {
									return $.trim( $("#user_name").val());
								}
							}
						}
					},
					phone : {
						required : true,
						isPhone : true
						
					},
					user_password : {
						required : true,
						rangelength : [ 6, 20 ]
					},
					user_password_rep : {
						equalTo : "#user_password"
					},
					dept : {
						required : true
					}

				}

			});

			$("#register").on("click",
				function() {
			
					var _this = this;
					$(_this).addClass("disabled");
					var user_name = $.trim($("#user_name").val());
					//alert(00+user_name);
					var user_password = $.trim($("#user_password").val());
					var user_password_rep = $.trim($("#user_password_rep").val());
					var phone = $.trim($("#phone").val());
					var dept = "xxx";
					var orgid = $("#orgnize").val()
					if (registerF.valid() && phone.match(/^((1)+\d{10})$/)) {
						$("#register").unbind();
						var url = "${_base}/audit/doRegister";
						$.ajax({
							type : "post",
							url : url,
							data : {
								"email" : user_name,
								"mobileNumber" : phone,
								"userOrgName" : dept,
								"password" : user_password,
								"orgId" : orgid
							},
							success : function(data) {
								//alert(11);
								var url = "${_base}/audit/toActiveAccount?email="
										+ user_name;
								window.location.href = url;
							},
							error : function(msg) {
								//alert(22);
							}
						});
				}
			});
			jQuery.validator.addMethod("stringCheck", function(value, element) {
				return this.optional(element) || /^[a-zA-Z0-9_]+$/.test(value);
			}, "只能包括中文字、英文字母、数字和下划线");
			jQuery.validator.addMethod("isPhone", function(value, element) {
				var tel = /^((1)+\d{10})$/;
				return this.optional(element) || (tel.test(value));
			}, "请正确填写您的电话号码");
			jQuery.extend(jQuery.validator.messages, {
				required : "输入不能为空",
				remote : "已存在",
				email : "请输入正确格式的电子邮件111",
				url : "请输入合法的网址",
				date : "请输入合法的日期",
				dateISO : "请输入合法的日期 (ISO).",
				number : "请输入合法的数字",
				digits : "只能输入整数",
				creditcard : "请输入合法的信用卡号",
				equalTo : "两次输入的密码不一致哦",
				accept : "请输入拥有合法后缀名的字符串",
				maxlength : jQuery.validator.format("请输入一个 长度最多是 {0} 的字符串"),
				minlength : jQuery.validator.format("请输入一个 长度最少是 {0} 的字符串"),
				rangelength : jQuery.validator
						.format("请输入 一个长度介于 {0} 和 {1} 之间的字符串"),
				range : jQuery.validator.format("请输入一个介于 {0} 和 {1} 之间的值"),
				max : jQuery.validator.format("请输入一个最大为{0} 的值"),
				min : jQuery.validator.format("请输入一个最小为{0} 的值")
			});
		});
		
		
	</script>
	
	

</body>
</html>