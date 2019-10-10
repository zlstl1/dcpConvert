package com.spring.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.vo.HistoryVo;
import com.spring.vo.PaginationVo;
import com.spring.vo.UserVo;

@Repository
public class DcpHistoryDao {

	@Autowired
    private SqlSession sqlSession;

	public List<HistoryVo> getHistoryList(PaginationVo pagination) {
		return sqlSession.selectList("user_history.getHistoryList",pagination);
	}

	public void writeHistory(HistoryVo historyVo) {
		sqlSession.insert("user_history.writeHistory",historyVo);
	}
	
	public int getHistoryListCnt(UserVo userVo) {
		return sqlSession.selectOne("user_history.getHistoryListCnt",userVo);
	}
}
