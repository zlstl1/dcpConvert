package com.spring.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.spring.service.DcpCommonService;
import com.spring.service.DcpDcpService;
import com.spring.service.DcpJpegService;
import com.spring.service.DcpMxfService;
import com.spring.service.DcpOneStopService;
import com.spring.service.DcpTiffService;
import com.spring.util.Common;
import com.spring.vo.DcpVo;
import com.spring.vo.HistoryVo;
import com.spring.vo.JpegVo;
import com.spring.vo.MxfVo;
import com.spring.vo.OneStopVo;
import com.spring.vo.TiffVo;
import com.spring.vo.UserVo;

@Controller
public class DcpConvertController {
	@Autowired
	Common common;
	@Autowired
	DcpCommonService dcpCommonService;
	@Autowired
	DcpTiffService dcpTiffService;
	@Autowired
	DcpJpegService dcpJpegService;
	@Autowired
	DcpMxfService dcpMxfService;
	@Autowired
	DcpDcpService dcpDcpService;
	@Autowired
	DcpOneStopService dcpService;
	
	final Logger logger = LoggerFactory.getLogger(DcpContoller.class);
	
	@ResponseBody
	@ResponseStatus(value = HttpStatus.OK)
	@RequestMapping(value = "/dcp/{email}/tiff", method = RequestMethod.POST)
	public void tiff(@ModelAttribute TiffVo tiffVo, HttpSession session, @RequestParam("items") List<String> items, @PathVariable("email") String email, @RequestParam("path") String path) {
		common.dbug("convertToTiff - DcpConvertController ::: " + email);
		UserVo user = (UserVo)session.getAttribute("user");
		HistoryVo historyVo = new HistoryVo();
		historyVo.setUser_no(user.getUser_no());
		logger.info("convertToTiff - DcpConvertController ::: Start convertToTiff / " + new Date());
		dcpTiffService.convertTiff(tiffVo, common.getLocalDir()+email, items, path, historyVo);
		logger.info("convertToTiff - DcpConvertController ::: End convertToTiff / " + new Date());
	}
	
	@ResponseBody
	@ResponseStatus(value = HttpStatus.OK)
	@RequestMapping(value = "/dcp/{email}/jpeg", method = RequestMethod.POST)
	public void jpeg(@ModelAttribute JpegVo jpegVo, HttpSession session, @RequestParam("items") List<String> items, @PathVariable("email") String email, @RequestParam("path") String path) {
		common.dbug("convertToJ2C - DcpConvertController ::: " + email);
		UserVo user = (UserVo)session.getAttribute("user");
		HistoryVo historyVo = new HistoryVo();
		historyVo.setUser_no(user.getUser_no());
		logger.info("convertToJ2C - DcpConvertController ::: Start convertToJ2c / " + new Date());
		dcpJpegService.convertJpeg(jpegVo, common.getLocalDir()+email, items, path, historyVo);
		logger.info("convertToJ2C - DcpConvertController ::: End convertToJ2c / " + new Date());
	}
	
	@ResponseBody
	@ResponseStatus(value = HttpStatus.OK)
	@RequestMapping(value = "/dcp/{email}/mxf", method = RequestMethod.POST)
	public void mxf(@ModelAttribute MxfVo mxfVo, HttpSession session, @RequestParam("items") List<String> items, @PathVariable("email") String email, @RequestParam("path") String path) {
		common.dbug("convertToMxf - DcpConvertController ::: " + email);
		UserVo user = (UserVo)session.getAttribute("user");
		HistoryVo historyVo = new HistoryVo();
		historyVo.setUser_no(user.getUser_no());
		logger.info("convertToMxf - DcpConvertController ::: Start convertToMxf / " + new Date());
		dcpMxfService.convertMxf(mxfVo, common.getLocalDir()+email, items, path, historyVo);
		logger.info("convertToMxf - DcpConvertController ::: End convertToMxf / " + new Date());
	}
	
	@ResponseBody
	@ResponseStatus(value = HttpStatus.OK)
	@RequestMapping(value = "/dcp/{email}/dcp", method = RequestMethod.POST)
	public void dcp(@ModelAttribute DcpVo dcpVo, HttpSession session, @RequestParam("items") List<String> items, @PathVariable("email") String email, @RequestParam("path") String path) {
		common.dbug("convertToDcp - DcpConvertController ::: " + email);
		UserVo user = (UserVo)session.getAttribute("user");
		HistoryVo historyVo = new HistoryVo();
		historyVo.setUser_no(user.getUser_no());
		logger.info("convertToDcp - DcpConvertController ::: Start convertToDcp / " + new Date());
		dcpDcpService.convertDcp(dcpVo, common.getLocalDir()+email, items, path, historyVo);
		logger.info("convertToDcp - DcpConvertController ::: End convertToDcp / " + new Date());
	}
	
	@ResponseBody
	@ResponseStatus(value = HttpStatus.OK)
	@RequestMapping(value = "/dcp/{email}/onestop", method = RequestMethod.POST)
	public void onestop(@ModelAttribute OneStopVo oneStopVo, HttpSession session, @RequestParam("items") List<String> items, @PathVariable("email") String email, @RequestParam("path") String path) {
		common.dbug("convertToOneStop - DcpConvertController ::: " + email);
		UserVo user = (UserVo)session.getAttribute("user");
		HistoryVo historyVo = new HistoryVo();
		historyVo.setUser_no(user.getUser_no());
		dcpService.convertOneStop(oneStopVo, common.getLocalDir()+email, items, path, historyVo);
	}
}
