package com.spring.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.vo.UserVo;

@Repository
public class DcpUserDao {

	@Autowired
	private SqlSession sqlSession;

	public ArrayList<UserVo> getUserList() {

		return (ArrayList) sqlSession.selectList("user_login.getUserList");
	}

	public void updateconnect(String user_id) throws Exception {
		// TODO Auto-generated method stub
		sqlSession.update("user_login.updateconnect", user_id);
	}
	
	public String deleteuser(String user_id) throws Exception {
		sqlSession.delete("user_login.deleteuser", user_id);
		return "true";
	}
	
	public UserVo getuser(String user_id) throws Exception {
		
		return sqlSession.selectOne("user_login.getuser", user_id);
	}
	
	public void updateuser(UserVo user) throws Exception {
		// TODO Auto-generated method stub
		sqlSession.update("user_login.updateuser", user);
	}
	
	public ArrayList<UserVo> getUnapprovedUserList() {

		return (ArrayList) sqlSession.selectList("user_login.getUnapprovedUserList");
	}
	
	public int getGroupCount(String group_name) {

		return sqlSession.selectOne("user_login.getGroupCount", group_name);
	}
	
	public void updateDefaultGroup(UserVo user) throws Exception {
		// TODO Auto-generated method stub
		sqlSession.update("user_login.updateDefaultGroup", user);
	}
	
	public void updateGroup(UserVo user) throws Exception {
		// TODO Auto-generated method stub
		sqlSession.update("user_login.updateGroup", user);
	}
	
	public void insertAdmin(int user_no) {
		
		sqlSession.insert("user_login.insertAdmin", user_no);
	}
	
	public String deleteAdmin(int user_no) throws Exception {
		sqlSession.delete("user_login.deleteAdmin", user_no);
		return "true";
	}
}
