<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/jsp/common/common.jsp"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/"+path;
%>

<title>登录</title>
<style type="text/css">
.dialog_main .input-s .yon_input{width:200px;}
</style>
</head>

<body onload="document.forms[0].reset()">
	<div class="big_k">
		<!--包含头部 主体-->
		<!--导航-->
		<div class="navigation" style="background-image: none;height:78px;">
			<jsp:include page="/jsp/common/header.jsp"></jsp:include>  
		</div>
<form id="loginF">
		<div class="container new_login">
			<div class="login_big">
				<div class="logi_bigbj">
					<div class="dialog_main">
	
						<ul class="dia_input input-s">
							<li><img src="${_base }/resources/images/login_a.png"></li>
							<li style="position:relative">
								<input id="userName" name="userName" type="text" class="yon_input" placeholder="请输入邮箱"/>
								<!--<span style="font-size:15px;line-height:35px;margin-left:3px;">@asiainfo.com</span>  -->
							</li>
							<label id="passWordInvlid"></label>
						</ul>
	
						<ul class="dia_input">
							<li><img src="${_base }/resources/images/login_b.png"></li>
							<li><input name="passWord" id="passWord" type="password" class="yon_input" placeholder="请输入密码"/></li>
							<label id="passWordInvlid"></label>
						</ul>
	
						<%-- <ul class="dia_yz">
							<li><input name="image" id ="image" type="text" class="yon_input_yz"/><a class="di_yzm" href="#"><img src="${_base }/clinicCountManager/captcha-image" width="148" height="38" id="kaptchaImage"  style="margin-top: -3px"/></a></li>
						</ul> --%>
						<ul class="dia_yz">
			       		  <li> 
					       		<span style="float: left;"><input name="image" id ="image" type="text" class="yon_input_yz"  style="color:#000000;" /></span>
					       </li>
					       <li><a class="di_yzm" href="#"><img src="${_base }/clinicCountManager/captcha-image" width="148" height="38" id="kaptchaImage" /></a></li>
					       <label id="loginInvlid"></label>
				       </ul>
	
						<ul class="dia_btn">
							<li><a href="javascript:void(0);" id="login">登录</a></li>
							
						</ul>
	
						<ul class="dia_nt">
							<li>
							<!--  <a id="ntlogin" href="${_base}/audit/toNTLogin?urlInfo=${urlInfo}">NT账号直接登录>></a>-->
							<!--  <a id="" href="#" style="font-size:16px;">忘记密码</a>-->
							<a style="color:white;float:right;font-size:16px;" href="${_base}/audit/toRegister">注册</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	</form>
	<jsp:include page="/jsp/common/footer_new.jsp"></jsp:include>
</body>
<script type="text/javascript">
var urlInfo = "${urlInfo}";

$(document).ready(function(){
	var loginF = $("#loginF");
	loginF.validate({
		rules : {
			userName : {
				required : true
			},
			passWord : {
				required : true
			},
			image : {
				required : true
			}
		}

	}); 
	
	
	

	$('#userName').blur(function() { 
		emailCheck();
	});
	function emailCheck(){
		var userName =$.trim($("#userName").val());
		if(userName == null || userName==""){
			//alert("indexOf")
			$("#loginInvlid").text("邮箱不能为空").addClass("error");
			$("#loginInvlid").removeClass("hidden");
			$("#kaptchaImage").hide().attr('src', '${_base}/clinicCountManager/captcha-image?' + Math.floor(Math.random()*100) ).fadeIn();
			return false;
		}else{
			$("#loginInvlid").addClass("hidden");
			return true;
		}
	}
	
	
	
	
	$("#login").click(function(){
		$("#passWordInvlid").addClass("hidden");
		if(emailCheck()){
			login();
		}
		
	});
	function login(){
		var userName =$.trim($("#userName").val());
		var passWord = $.trim($("#passWord").val());
		var image =$.trim($("#image").val());
		if (loginF.valid()) {
			var url = "${_base}/audit/doLogin";
			$.ajax({
				type : "post",
				url : url,
				data : {
					"userName" : userName,
					"passWord" : passWord,
					"image"    : image
				},
				success : function(data) {
					if(data.returnFlag =="success"){
						var redirectUrl = urlInfo;
						if(redirectUrl =="" || redirectUrl=="undefined"){
							redirectUrl = "<%=basePath%>";
						}else{
							redirectUrl = decodeURI(urlInfo);
						}
						window.location.href=redirectUrl;
					}else{
						if(data.returnFlag=="0"){
							$("#image").val("");
							$("#loginInvlid").text("用户名或密码错误").addClass("error");
							$("#loginInvlid").removeClass("hidden").show();
							$("#kaptchaImage").hide().attr('src', '${_base}/clinicCountManager/captcha-image?' + Math.floor(Math.random()*100) ).fadeIn();
						}
						
						if(data.returnFlag=="false_1"){
							$("#image").val("");
							$("#loginInvlid").text("账户未激活，请登录邮箱激活").addClass("error");
							$("#loginInvlid").removeClass("hidden").show();
							$("#kaptchaImage").hide().attr('src', '${_base}/clinicCountManager/captcha-image?' + Math.floor(Math.random()*100) ).fadeIn();
						}
						
						if(data.returnFlag=="false"){
							$("#image").val("");
							$("#loginInvlid").text("验证码错误").addClass("error");
							$("#loginInvlid").removeClass("hidden").show();
							$("#kaptchaImage").hide().attr('src', '${_base}/clinicCountManager/captcha-image?' + Math.floor(Math.random()*100) ).fadeIn();
						}
						
						if(data.returnFlag=="false_2"){
							$("#image").val("");
							$("#loginInvlid").text("用户未加入到组织").addClass("error");
							$("#loginInvlid").removeClass("hidden").show();
							$("#kaptchaImage").hide().attr('src', '${_base}/clinicCountManager/captcha-image?' + Math.floor(Math.random()*100) ).fadeIn();
						}
					}
				}
			});
		}
	}
	
	
	
	document.onkeydown=function(event){
        var e = event || window.event || arguments.callee.caller.arguments[0];
        if(e && e.keyCode==13){ // enter 键
        	 login();
        }
    }; 
	
    
		
	$("#kaptchaImage").click(function(){
			$(this).hide().attr('src', '${_base}/clinicCountManager/captcha-image?' + Math.floor(Math.random()*100) ).fadeIn();
	})
	
    
    jQuery.validator.addMethod("stringCheck", function(value, element) {
		return this.optional(element) || /^[a-zA-Z0-9_]+$/.test(value);
	}, "只能包括中文字、英文字母、数字和下划线");
	jQuery.validator.addMethod("isPhone", function(value, element) {    
      	var tel = /^(\d{3,4}-?)?\d{7,9}$/g;    
      	return this.optional(element) || (tel.test(value));    
    }, "请正确填写您的电话号码");
	jQuery.extend(jQuery.validator.messages, {
		required : "输入不能为空",
		remote : "已存在",
		email : "请输入正确格式的电子邮件",
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


</html>