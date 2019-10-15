package com.spring.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.DcpUserDao;
import com.spring.vo.UserVo;

@Service
public class DcpUserService {

	@Autowired
	DcpUserDao dao;

	public ArrayList<UserVo> getUserList() throws Exception {

		return dao.getUserList();
	}

	public void updateconnect(String user_id) throws Exception {

		dao.updateconnect(user_id);
	}

	public String deleteuser(String user_id) throws Exception {

		return dao.deleteuser(user_id);
	}

	public UserVo getuser(String user_id) throws Exception {

		return dao.getuser(user_id);
	}
}
