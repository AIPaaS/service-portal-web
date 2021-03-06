package com.ai.paas.ipaas.storm.order.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.paas.ipaas.email.EmailServiceImpl;
import com.ai.paas.ipaas.storm.sys.BaseController;
import com.ai.paas.ipaas.system.constants.Constants;
import com.ai.paas.ipaas.system.util.UserUtil;
import com.ai.paas.ipaas.user.dubbo.interfaces.IOrder;
import com.ai.paas.ipaas.user.dubbo.interfaces.ISysParamDubbo;
import com.ai.paas.ipaas.user.dubbo.vo.EmailDetail;
import com.ai.paas.ipaas.user.dubbo.vo.OrderDetailRequest;
import com.ai.paas.ipaas.user.dubbo.vo.OrderDetailResponse;
import com.ai.paas.ipaas.user.dubbo.vo.SysParamVo;
import com.ai.paas.ipaas.user.dubbo.vo.SysParmRequest;
import com.ai.paas.ipaas.user.vo.UserInfoVo;
import com.alibaba.dubbo.config.annotation.Reference;
import com.google.gson.JsonObject;

@Controller
@RequestMapping(value = "/rcs")
public class StormOrderController extends BaseController {
	private static final Logger log = LogManager
			.getLogger(StormOrderController.class.getName());
	@Reference
	private IOrder iOrder;
	@Reference
	private ISysParamDubbo iSysParam;
	@Autowired
	private EmailServiceImpl emailSrv;
	
	@RequestMapping(value="/introduce")
	public String toIndex(HttpServletRequest request,HttpServletResponse response){
        request.getSession().removeAttribute("list_index");
        request.getSession().setAttribute("list_index", "list_04");
		return "/storm/task/introduce";
	}
	
	@RequestMapping(value = "/toOrder")
	public String toOrder(HttpServletRequest request, HttpServletResponse response) {
	    SysParmRequest req = new SysParmRequest();
	    req.setTypeCode(Constants.serviceName.RCS);
		req.setParamCode(Constants.paramCode.OPTIONS);
		List<SysParamVo> list = iSysParam.getSysParams(req);
		request.setAttribute("list", list);
		System.out.println(request.getRequestURI());
		return "/storm/task/orderOpen";
	}
	
	@RequestMapping(value = "/add",produces = {"application/json;charset=UTF-8"})
	public @ResponseBody String add(HttpServletRequest request,
			HttpServletResponse response) {
		String prodCluster=request.getParameter("rcsSelect");
		String userServIpaasPwd=request.getParameter("userServIpaasPwd");
		UserInfoVo userVo = UserUtil.getUserSession(request.getSession());
		OrderDetailRequest orderDetailRequest=new OrderDetailRequest();
		orderDetailRequest.setUserId(userVo.getUserId());								//用户ID
		orderDetailRequest.setOperateType(Constants.OperateType.APPLY);		//操作类型
		orderDetailRequest.setProdId("4");									//产品ID
		orderDetailRequest.setProdType(Constants.ProductType.IPAAS_JiSuan);	//PROD_IAAS	//产品类型  // 1存储  2计算   3 数据库服务
		orderDetailRequest.setProdByname(Constants.serviceName.RCS);		//产品类型简写
		orderDetailRequest.setUserServIpaasPwd(userServIpaasPwd); 			//服务密码
				
		JsonObject prodClusterJson = new JsonObject();
		prodClusterJson.addProperty("prodCluster", prodCluster);
		prodClusterJson.addProperty("orgCode", userVo.getOrgCode());
		log.info("产品参数："+prodClusterJson.toString());
		orderDetailRequest.setProdParam(prodClusterJson.toString());			//产品参数
		
		JsonObject resultJson = new JsonObject();
		log.info("调用saveOrderDetail----------");
		OrderDetailResponse orderDetailResponse=new OrderDetailResponse();
		try{
			orderDetailResponse=iOrder.saveOrderDetail(orderDetailRequest);
			log.info("--------- 根据orderDetailResponse结果，发送RCS服务开通的待审核提醒邮件----------");
			if (orderDetailResponse.isNeedSend() && orderDetailResponse.getEmail() != null) {
				for (EmailDetail email : orderDetailResponse.getEmail()) {
					emailSrv.sendEmail(email);
				}
			}
		}catch(Exception e){
			log.info(e.getCause().getMessage()+e.getMessage()+"---------");
			resultJson.addProperty("resultCode", "999999");
			resultJson.addProperty("resultMessage", "rcs add error");
		}
		
		log.info("saveOrderDetail返回结果："+orderDetailResponse.getResponseHeader().getResultCode()+":"+orderDetailResponse.getResponseHeader().getResultMessage());
		resultJson.addProperty("resultCode",orderDetailResponse.getResponseHeader().getResultCode());
		resultJson.addProperty("resultMessage", orderDetailResponse.getResponseHeader().getResultMessage());
		
		return resultJson.toString();
	}
	
}
