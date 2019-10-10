package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.DcpHistoryDao;
import com.spring.util.Common;
import com.spring.vo.DcpVo;
import com.spring.vo.HistoryVo;

@Service
public class DcpDcpService {
	@Autowired
	DcpCommonService dcpCommon;
	@Autowired
	DcpHistoryDao dcpHistoryDao;
	@Autowired
	Common common;
	
	public void convertDcp(DcpVo dcpVo,String workDir,List<String> items, String path, HistoryVo historyVo) {
		String cli = "opendcp_xml ";
		cli += " -r ";
		
		for(int i=0; i<items.size(); i++) {
			cli += workDir + items.get(i) + " ";
		}
		if(!(dcpVo.getIssuer().equals(""))) {
			cli += "-i " + dcpVo.getIssuer() + " ";
		}
		if(!(dcpVo.getAnnotation().equals(""))) {
			cli += "-a " + dcpVo.getAnnotation() + " ";
		}
		if(!(dcpVo.getTitle().equals(""))) {
			cli += "-t " + dcpVo.getTitle() + " ";
		}
		cli = cli + "-m " + dcpVo.getRating() + " -k " + dcpVo.getKind();
		
		dcpCommon.runCli(cli.split(" "), workDir+path);
		
		historyVo.setHistory_msg("DCP º¯È¯");
		dcpHistoryDao.writeHistory(historyVo);
		
//		dcpCommon.zipDir(workDir);
//		
//		RemoveDir removeDir = new RemoveDir(workDir+path);
//		removeDir.start();
	}
}
