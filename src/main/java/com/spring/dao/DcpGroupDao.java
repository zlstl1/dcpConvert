package com.spring.dao;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.vo.GroupVo;

@Repository
public class DcpGroupDao {
	
	@Autowired
	private SqlSession sqlSession;
	
	public void insertgroup(GroupVo groupVo) {
		
		sqlSession.insert("group_mapper.insertgroup", groupVo);	
	}
	
	public ArrayList<GroupVo> getGroupList() {

		return (ArrayList) sqlSession.selectList("group_mapper.getGroupList");
	}
	
	public GroupVo getGroup(String group_name) throws Exception {
		
		return sqlSession.selectOne("group_mapper.getGroup", group_name);
	}
	
	public String delGroup(String group_name) throws Exception {
		
		sqlSession.delete("group_mapper.delGroup", group_name);
		
		return "true";
	}
	
	public void updateGroup(GroupVo groupVo) throws Exception {
		// TODO Auto-generated method stub
		sqlSession.update("group_mapper.updateGroup", groupVo);
	}
}
