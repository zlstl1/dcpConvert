package com.spring.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.dao.DcpHistoryDao;
import com.spring.service.DcpCommonService;
import com.spring.service.DcpFileService;
import com.spring.service.DcpOneStopService;
import com.spring.util.Common;
import com.spring.vo.FileVo;
import com.spring.vo.UserVo;

@Controller
public class DcpContoller {

	@Autowired
	DcpOneStopService dcpService;
	@Autowired
	DcpCommonService dcpCommonService;
	@Autowired
	DcpFileService dcpFileService;
	@Autowired
	Common common;
	
	@Autowired
	DcpHistoryDao dcpHistoryDao;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String root(Model model) {
		return "redirect:/dcp/login";
	}
	
	@RequestMapping(value = "/dcp", method = RequestMethod.GET)
	public String main(Model model) {
		return "redirect:/dcp/login";
	}
	
	@RequestMapping(value = "/dcp/{email}", method = RequestMethod.GET)
	public String myFile(Model model, HttpSession session, @PathVariable("email") String email) {
		common.dbug("myFile - DcpController ::: " + email);
		UserVo userVo = (UserVo)session.getAttribute("user");
		model.addAttribute("user", userVo);
		List<FileVo> fileList = dcpFileService.getFileList(email,"");
		model.addAttribute("fileList", fileList);
		String dirSize = dcpFileService.getDirectorySize(email);
		model.addAttribute("dirSize", dirSize);
		return "myFile";
	}
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
//	@ResponseBody
//	@RequestMapping(value = "/dcp/checkdownload", method = RequestMethod.POST)
//	public String checkdownload(@RequestParam("filename")String filename, HttpSession session) {
//		String fileFullPath = common.getLocalDir() +  (String) session.getAttribute("UUID") + "\\";
//	    File downloadFile = new File(fileFullPath + filename + ".zip");
//	    
//	    if(downloadFile.exists()) {
//	    	return "true";
//	    }else {
//	    	return "false";
//	    }
//	}
//	
//	@ResponseBody
//	@RequestMapping(value = "/dcp/uploadmedia")
//	public void uploadMedia(MultipartHttpServletRequest req, HttpSession session) {
//		common.setSession(session);
//
//		String workDir = common.getLocalDir() + common.getPersonalUUID();
//		
//		MultipartFile file = req.getFile("pictureReel");
//		dcpCommonService.uploadMedia(file, workDir);
//	}
//	
//    @RequestMapping(value="/dcp/stream/{fileName:.+}", method= RequestMethod.GET) 
//    public String getContentMediaVideo(@PathVariable("fileName")String fileName,HttpServletRequest request, 
//    		HttpServletResponse response,HttpSession session) throws UnsupportedEncodingException, IOException {
//    	common.setSession(session);
//    	
//    	int pos = fileName .lastIndexOf(".");
//		String _fileName = fileName.substring(0, pos);
//		fileName = _fileName + ".mp4";
//		
//		File file = new File(common.getLocalDir() + common.getPersonalUUID() + "\\" + fileName);
//      
//		RandomAccessFile randomFile = new RandomAccessFile(file, "r");
//
//		long rangeStart = 0; 
//		long rangeEnd = 0; 
//		boolean isPart=false; 
//
//		try{
//			long movieSize = randomFile.length(); 
//			String range = request.getHeader("range");
//
//
//			if(range!=null) {
//				if(range.endsWith("-")){
//					range = range+(movieSize - 1); 
//				}
//				int idxm = range.trim().indexOf("-");                           
//				rangeStart = Long.parseLong(range.substring(6,idxm));
//				rangeEnd = Long.parseLong(range.substring(idxm+1));
//				if(rangeStart > 0){
//					isPart = true;
//				}
//			}else{  
//				rangeStart = 0;
//              	rangeEnd = movieSize - 1;
//			}
//
//			long partSize = rangeEnd - rangeStart + 1;
//
//			response.reset();
//
//			response.setStatus(isPart ? 206 : 200);
//
//			response.setContentType("video/mp4");
//
//			response.setHeader("Content-Range", "bytes "+rangeStart+"-"+rangeEnd+"/"+movieSize);
//			response.setHeader("Accept-Ranges", "bytes");
//			response.setHeader("Content-Length", ""+partSize);
//
//			OutputStream out = response.getOutputStream();
//			randomFile.seek(rangeStart);
//
//			int bufferSize = 8*1024;
//			byte[] buf = new byte[bufferSize];
//			do{
//				int block = partSize > bufferSize ? bufferSize : (int)partSize;
//				int len = randomFile.read(buf, 0, block);
//				out.write(buf, 0, len);
//				partSize -= block;
//			}while(partSize > 0);
//
//		}catch(IOException e){
//		}finally{
//         randomFile.close();
//		}
//		return null;
//    }
    
}
