package com.spring.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.spring.service.DcpCommonService;
import com.spring.service.DcpFileService;
import com.spring.util.Common;
import com.spring.vo.FileVo;

@Controller
public class DcpFileController {

	@Autowired
	DcpCommonService dcpCommonService;
	@Autowired
	DcpFileService dcpFileService;
	@Autowired
	Common common;
	
	@ResponseBody
	@RequestMapping(value = "/dcp/{email}/getdirectorylist", method = RequestMethod.GET)
	public JSONArray getDirectoryList(@PathVariable("email") String email) {
		JSONArray fileList = dcpFileService.getDirectoryList(email);
		return fileList;
	}
	
	@ResponseBody
	@RequestMapping(value = "/dcp/{email}/fetchfilelist", method = RequestMethod.POST)
	public Map<String,Object> fetchFileList(@PathVariable("email") String email, @RequestParam("path") String path) {
		List<FileVo> fileList = dcpFileService.getFileList(email, path);
		Map<String,Object> map = new HashMap<String,Object>();
		String dirSize = dcpFileService.getDirectorySize(email);
		map.put("fileList", fileList);
		map.put("dirSize", dirSize);
		return map;
	}
	
	@ResponseBody
	@ResponseStatus(value = HttpStatus.OK)
	@RequestMapping(value = "/dcp/{email}/movefile", method = RequestMethod.POST)
	public void moveFile(@PathVariable("email") String email, @RequestParam("path") String path, @RequestParam("items") List<String> items) {
		dcpFileService.moveFile(email, path, items);
	}
	
	@ResponseBody
	@ResponseStatus(value = HttpStatus.OK)
	@RequestMapping(value = "/dcp/{email}/uploadfile", method = RequestMethod.POST)
	public void uploadFile(@PathVariable("email") String email, @RequestParam("uploadFile") MultipartFile[] uploadFile, @RequestParam("path") String path) {
		for(MultipartFile file : uploadFile) {
			dcpFileService.saveFile(common.getLocalDir()+email+path, file);
		}
	}
	
	@ResponseBody
	@ResponseStatus(value = HttpStatus.OK)
	@RequestMapping(value = "/dcp/{email}/deletefile", method = RequestMethod.POST)
	public void deleteFile(@PathVariable("email") String email, @RequestParam("items") List<String> items) {
		dcpFileService.deleteFile(items,email);
	}
	
	@ResponseBody
	@ResponseStatus(value = HttpStatus.OK)
	@RequestMapping(value = "/dcp/{email}/makefolder", method = RequestMethod.POST)
	public void makeFolder(@PathVariable("email") String email, @RequestParam("folderName") String folderName) {
		dcpCommonService.makeDir(common.getLocalDir()+email+folderName);
	}
	
	@RequestMapping(value = "/dcp/{email}/downloadfile")
	public ModelAndView callDownload(@PathVariable("email") String email, @RequestParam("path") List<String> path) {
		String fileName = "";
		for(int i=1; i<path.size();i++) {
			fileName += "/" + path.get(i);
		}
	    File downloadFile = new File(common.getLocalDir()+email+fileName);
	    return new ModelAndView("fileDownloadView", "downloadFile",downloadFile);
	}
	
	@RequestMapping(value = "/dcp/{email}/downloadfolder")
	public ModelAndView downloadfolder(@PathVariable("email") String email, @RequestParam("path") List<String> path) {
		String fileName = "";
		for(int i=1; i<path.size();i++) {
			fileName += "/" + path.get(i);
		}
	    dcpCommonService.zipDir(common.getLocalDir()+email+"/"+fileName);
	    File downloadFile = new File(common.getLocalDir()+email+fileName+".zip");
	    
	    return new ModelAndView("fileDownloadView", "downloadFile",downloadFile);
	}
}
