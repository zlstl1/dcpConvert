package com.spring.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.service.DcpTiffService;
import com.spring.util.Common;
import com.spring.vo.HistoryVo;
import com.spring.vo.TiffVo;
import com.spring.vo.UserVo;

@RestController
public class DcpRestController {
	
	@Autowired
	Common common;
	@Autowired
	DcpTiffService dcpTiffService;
	
	@RequestMapping(value = "/rest/{email}/tiff", method = RequestMethod.GET)
	public String tiff(@ModelAttribute TiffVo tiffVo, HttpSession session, @RequestParam("items") List<String> items, @PathVariable("email") String email, @RequestParam("path") String path) {
		UserVo user = (UserVo)session.getAttribute("user");
		HistoryVo historyVo = new HistoryVo();
		historyVo.setUser_no(user.getUser_no());
		
		path = path.replace("*", "/");
		items.set(0, items.get(0).replace("*", "/"));
		
		dcpTiffService.convertTiff(tiffVo, common.getLocalDir()+email, items, path, historyVo);
		
		return "TIFF Convert";
	}
}
