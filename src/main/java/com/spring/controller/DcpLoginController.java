package com.spring.controller;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.social.connect.Connection;
import org.springframework.social.google.api.Google;
import org.springframework.social.google.api.impl.GoogleTemplate;
import org.springframework.social.google.api.plus.Person;
import org.springframework.social.google.api.plus.PlusOperations;
import org.springframework.social.google.connect.GoogleConnectionFactory;
import org.springframework.social.oauth2.AccessGrant;
import org.springframework.social.oauth2.GrantType;
import org.springframework.social.oauth2.OAuth2Operations;
import org.springframework.social.oauth2.OAuth2Parameters;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.service.DcpCommonService;
import com.spring.service.DcpHistoryService;
import com.spring.service.DcpLoginService;
import com.spring.service.DcpUserService;
import com.spring.util.Common;
import com.spring.vo.HistoryVo;
import com.spring.vo.UserVo;

@Controller
public class DcpLoginController {
	@Autowired
	private GoogleConnectionFactory googleConnectionFactory;
	@Autowired
	private OAuth2Parameters googleOAuth2Parameters;
	@Autowired
	Common common;
	@Autowired
	DcpLoginService dcpLoginService;
	@Autowired
	DcpHistoryService dcpHistoryService;
	@Autowired
	DcpCommonService dcpCommonService;
	@Autowired
	DcpUserService dcpUserService;
	
	@RequestMapping(value = "dcp/login", method = { RequestMethod.GET, RequestMethod.POST })
	public String login(Model model, HttpSession session) {
		common.dbug("login - DcpLoginController ::: ");
		if(common.checkLogin(session)) {
			UserVo userVo = (UserVo)session.getAttribute("user");
			model.addAttribute("user", userVo);
			
			String email = userVo.getUser_id();
			common.dbug("login - DcpLoginController ::: " + email + " already loggedin");
			return "redirect:/dcp/" + email;
		}else {
			OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
			String url = oauthOperations.buildAuthorizeUrl(GrantType.AUTHORIZATION_CODE, googleOAuth2Parameters);

			model.addAttribute("google_url", url);

			common.dbug("login - DcpLoginController ::: send google login url");
			return "main";
		}
	}
	
	@RequestMapping(value = "dcp/logout", method = { RequestMethod.GET, RequestMethod.POST })
	public String logout(HttpSession session) {
		UserVo userVo = (UserVo)session.getAttribute("user");
		common.dbug("logout - DcpLoginController ::: " + userVo.getUser_id());
		session.invalidate();
		return "redirect:/dcp/login";
	}
    
    @RequestMapping(value = "dcp/oauth2callback", method = { RequestMethod.GET, RequestMethod.POST })
    public String googleCallback(Model model, @RequestParam String code, HttpServletRequest request, HttpSession session) throws IOException {
    	common.dbug("googleCallback - DcpLoginController ::: ");
    	OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
       AccessGrant accessGrant = oauthOperations.exchangeForAccess(code , googleOAuth2Parameters.getRedirectUri(), null);
        
       String accessToken = accessGrant.getAccessToken();
       Long expireTime = accessGrant.getExpireTime();
        
       if (expireTime != null && expireTime < System.currentTimeMillis()) {
    	   accessToken = accessGrant.getRefreshToken();
    	   System.out.printf("accessToken is expired. refresh token = {}", accessToken);
        }
       Connection<Google> connection = googleConnectionFactory.createConnection(accessGrant);
       Google google = connection == null ? new GoogleTemplate(accessToken) : connection.getApi();
        
       PlusOperations plusOperations = google.plusOperations();
       Person profile = plusOperations.getGoogleProfile();
       
       //Save into DB
       UserVo user = new UserVo();
       
       String email = profile.getAccountEmail();
       if(email == null) {
    	   for( String key : profile.getEmails().keySet()) {
        	   if("ACCOUNT".equals(profile.getEmails().get(key))) {
        		   email=key;
        	   }
           	}
       	}
       user.setUser_email(email);
       email = email.split("@")[0];
       user.setUser_id(email);
       user.setUser_name(profile.getDisplayName());
        
        ///김규아 추가
       user.setUser_joined(new Date());
        
       if(dcpLoginService.checkRegist(email)) {
    	   common.dbug("googleCallback - DcpLoginController ::: first visit this page " + email);
    	   user = dcpLoginService.registId(user);
    	   dcpCommonService.makeDir(common.getLocalDir() + user.getUser_id());
       }else {
    	   common.dbug("googleCallback - DcpLoginController ::: found in DB " + email);
    	   user = dcpLoginService.getUserInfo(user);
        	HistoryVo historyVo = new HistoryVo();
        	historyVo.setUser_no(user.getUser_no());
        	historyVo.setHistory_msg("로그인");
        	dcpHistoryService.writeHistory(historyVo);
        	
        	try {
				dcpUserService.updateconnect(email);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }
        
       session.setAttribute("user", user);
        
    	return "redirect:/dcp/" + email;
    }
    
    @RequestMapping(value = "/dcp/error", method = RequestMethod.GET)
	public String error(HttpServletResponse res) {
    	res.setStatus(HttpServletResponse.SC_OK);
		return "404error";
	}
}
