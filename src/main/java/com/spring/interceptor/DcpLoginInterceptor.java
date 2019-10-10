package com.spring.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.spring.util.Common;

public class DcpLoginInterceptor extends HandlerInterceptorAdapter{
	@Autowired
	Common common;
	
	@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
		try {
			HttpSession session = request.getSession();
	    	Map<?, ?> pathVariables = (Map<?, ?>) request.getAttribute(HandlerMapping.URI_TEMPLATE_VARIABLES_ATTRIBUTE);
	    	String urlId = (String)pathVariables.get("email");
	    	
	    	if(!common.checkLogin(session, urlId)) {
	    		
	    		response.sendRedirect(request.getContextPath() + "/dcp/error");
	    		return false;
	    	}
	    	return true;
		}catch (Exception e) {
			response.sendRedirect(request.getContextPath() + "/dcp/error");
    		return false;
		}
        //return super.preHandle(request, response, handler);
    }
 
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {
        super.postHandle(request, response, handler, modelAndView);
    }
 
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        // TODO Auto-generated method stub
        super.afterCompletion(request, response, handler, ex);
    }

}
