package com.spring.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.service.DcpHistoryService;
import com.spring.util.Common;
import com.spring.vo.HistoryVo;
import com.spring.vo.PaginationVo;
import com.spring.vo.UserVo;

@Controller
public class DcpHistoryController {

	@Autowired
	DcpHistoryService dcpHistoryService;
	@Autowired
	Common common;
	
	@RequestMapping(value = "/dcp/{email}/history", method = RequestMethod.GET)
	public String history(Model model, HttpSession session, @PathVariable("email") String email, 
			@RequestParam(required = false, defaultValue = "1") int page, @RequestParam(required = false, defaultValue = "1") int range) {
		common.dbug("history - DcpHistoryController ::: " + email);
		UserVo userVo = (UserVo)session.getAttribute("user");
		
		int listCnt = dcpHistoryService.getHistoryListCnt(userVo);

		PaginationVo pagination = new PaginationVo();
		pagination.pageInfo(page, range, listCnt);
		pagination.setUser_no(userVo.getUser_no());
		
		List<HistoryVo> historyList = dcpHistoryService.getHistoryList(pagination);
		model.addAttribute("pagination", pagination);
		model.addAttribute("historyList", historyList);
		return "history";
	}
}
