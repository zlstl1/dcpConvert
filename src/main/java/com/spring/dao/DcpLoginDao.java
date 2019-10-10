package com.spring.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.vo.UserVo;

@Repository
public class DcpLoginDao {
	@Autowired
    private SqlSession sqlSession;

	public UserVo checkRegist(String email) {
		return sqlSession.selectOne("user_login.checkRegist",email);
	}
	
	public UserVo registId(UserVo userVo) {
		sqlSession.insert("user_login.registId",userVo);
		return userVo;
	}
	
	public UserVo isAdmin(UserVo userVo) {
		return sqlSession.selectOne("user_login.isAdmin",userVo);
	}
	
	public UserVo getUserInfo(UserVo userVo) {
		return sqlSession.selectOne("user_login.getUserInfo",userVo);
	}
}
