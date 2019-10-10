package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.DcpHistoryDao;
import com.spring.vo.HistoryVo;
import com.spring.vo.PaginationVo;
import com.spring.vo.UserVo;

@Service
public class DcpHistoryService {

	@Autowired
	DcpHistoryDao dcpHistoryDao;
	
	public List<HistoryVo> getHistoryList(PaginationVo pagination) {
		return dcpHistoryDao.getHistoryList(pagination);
	}

	public int getHistoryListCnt(UserVo userVo){
		return dcpHistoryDao.getHistoryListCnt(userVo);
	}
	
	public void writeHistory(HistoryVo historyVo) {
		dcpHistoryDao.writeHistory(historyVo);
	}

}
