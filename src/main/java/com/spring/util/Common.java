package com.spring.util;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.spring.service.DcpOneStopService;
import com.spring.vo.UserVo;

@Service
public class Common {
	
	final Logger logger = LoggerFactory.getLogger(DcpOneStopService.class);
	
	//final String localDir = "C:\\Users/gskim.DI-SOLUTION/Downloads/WEB/";
	final String localDir = "/home/ubuntu/Downloads/WEB/";
	
	//final String libDir = "C:\\Users\\gskim.DI-SOLUTION\\Downloads\\Tool\\spring-tool-suite-3.9.8.RELEASE-e4.11.0-win32-x86_64\\sts-bundle\\workspace\\opendcp\\src\\main\\webapp\\resources\\lib\\";
	final String libDir = "/home/ubuntu/Downloads/WEB/";
	
	String personalUUID = "";
	
	final int defaultGpu = 1;
	final int defaultStorage = 25;
	
	boolean DBUG = false;
	
	public String getPersonalUUID() {
		return personalUUID;
	}
	public void setPersonalUUID(String personalUUID) {
		this.personalUUID = personalUUID;
	}
	public int getDefaultGpu() {
		return defaultGpu;
	}
	public int getDefaultStorage() {
		return defaultStorage;
	}
	public String getLocalDir() {
		return localDir;
	}
	public String getLibDir() {
		return libDir;
	}
	public boolean isDBUG() {
		return DBUG;
	}
	public void setDBUG(boolean dBUG) {
		DBUG = dBUG;
	}
	
	public Boolean checkLogin(HttpSession session, String email) {
		UserVo userVo = (UserVo)session.getAttribute("user");
		if(userVo == null) {
			return false;
		}

		String cmpEmail = userVo.getUser_id();
		if(!email.equals(cmpEmail)) {
			return false;
		}else {
			return true;
		}
	}
	
	public Boolean checkLogin(HttpSession session) {
		if( session.getAttribute("user") == null ) {
			return false;
		}else {
			return true;
		}
	}
	
	public void setSession(HttpSession session) {
		if (session.getAttribute("UUID") == null) {
			UserVo userVo = (UserVo)session.getAttribute("user");
			personalUUID = userVo.getUser_id();
			session.setAttribute("UUID", personalUUID);
		}else {
			personalUUID = (String) session.getAttribute("UUID");
		}
	}
	
	public void dbug(String msg) {
		if(this.DBUG) {
			logger.info(msg);
		}
	}
}
