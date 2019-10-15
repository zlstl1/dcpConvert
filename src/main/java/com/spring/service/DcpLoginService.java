package com.spring.service;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.DcpLoginDao;
import com.spring.util.Common;
import com.spring.vo.UserVo;

@Service
public class DcpLoginService {

	@Autowired
	DcpLoginDao dcpLoginDao;
	@Autowired
	Common common;
	
	public Boolean checkRegist(String email) {
		UserVo userVo = dcpLoginDao.checkRegist(email);
		if(userVo == null) {
			return true;
		}else {
			return false;
		}
	}
	
	public UserVo registId(UserVo userVo) {
		userVo.setUser_storageCapa(common.getDefaultStorage());
		userVo.setUser_usingGpu(common.getDefaultGpu());
		userVo.setUser_status("미승인");
		userVo.setUser_grade("회원");
		userVo.setUser_joined(new Date());
		
		return dcpLoginDao.registId(userVo);
	}
	
	public UserVo getUserInfo(UserVo userVo) {
		userVo = dcpLoginDao.getUserInfo(userVo);
		UserVo user = dcpLoginDao.isAdmin(userVo);
		if(user != null) {
			userVo.setUser_admin(true);
		}
		return userVo;
	}
	
}
