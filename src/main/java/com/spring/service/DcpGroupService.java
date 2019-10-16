package com.spring.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.DcpGroupDao;
import com.spring.vo.GroupVo;

@Service
public class DcpGroupService {

	@Autowired
	DcpGroupDao dcpGroupDao;

	public void insertgroup(GroupVo groupVo) {

		dcpGroupDao.insertgroup(groupVo);
	}
	
	public ArrayList<GroupVo> getGroupList() throws Exception {

		return dcpGroupDao.getGroupList();
	}
	
	public GroupVo getGroup(String group_name) throws Exception {

		return dcpGroupDao.getGroup(group_name);
	}
	
	public String delGroup(String group_name) throws Exception {

		return dcpGroupDao.delGroup(group_name);
	}
	
	public void updateGroup(GroupVo groupVo) throws Exception {

		dcpGroupDao.updateGroup(groupVo);
	}
}
