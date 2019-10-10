//package com.spring.controller;
//
//import java.io.File;
//import java.io.IOException;
//import java.io.OutputStream;
//import java.io.RandomAccessFile;
//import java.io.UnsupportedEncodingException;
//import java.util.Date;
//import java.util.UUID;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.social.connect.Connection;
//import org.springframework.social.google.api.Google;
//import org.springframework.social.google.api.impl.GoogleTemplate;
//import org.springframework.social.google.api.plus.Person;
//import org.springframework.social.google.api.plus.PlusOperations;
//import org.springframework.social.google.connect.GoogleConnectionFactory;
//import org.springframework.social.oauth2.AccessGrant;
//import org.springframework.social.oauth2.GrantType;
//import org.springframework.social.oauth2.OAuth2Operations;
//import org.springframework.social.oauth2.OAuth2Parameters;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.ModelAttribute;
//import org.springframework.web.bind.annotation.PathVariable;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestMethod;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.ResponseBody;
//import org.springframework.web.multipart.MultipartFile;
//import org.springframework.web.multipart.MultipartHttpServletRequest;
//import org.springframework.web.servlet.ModelAndView;
//
//import com.spring.service.DcpService;
//import com.spring.vo.DcpVo;
//import com.spring.vo.JpegVo;
//import com.spring.vo.MxfVo;
//import com.spring.vo.OneStopVo;
//import com.spring.vo.TiffVo;
//import com.spring.vo.UserVo;
//
//@Controller
//public class BackupDcpController {
//
//	@Autowired
//	DcpService dcpService;
//	
//	@Autowired
//	private GoogleConnectionFactory googleConnectionFactory;
//
//	@Autowired
//	private OAuth2Parameters googleOAuth2Parameters;
//	
//	final String localDir = "C:\\Users\\seok\\Desktop\\test\\WEB\\";
//	String personalUUID = "";
//	final Logger logger = LoggerFactory.getLogger(DcpContoller.class);
//	
//	@RequestMapping(value = "/dcp", method = RequestMethod.GET)
//	public String index(HttpSession session) {
//		if(checkLogin(session)) {
//			return "main";
//		}else {
//			return "redirect:/login";
//		}
//	}
//	
//	// 濡쒓렇�씤 泥� �솕硫� �슂泥� 硫붿냼�뱶
//	@RequestMapping(value = "/login", method = { RequestMethod.GET, RequestMethod.POST })
//	public String login(Model model, HttpSession session) {
//		if(checkLogin(session)) {
//			return "redirect:/dcp";
//		}else {
//			/* 援ш�code 諛쒗뻾 */
//			OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
//			String url = oauthOperations.buildAuthorizeUrl(GrantType.AUTHORIZATION_CODE, googleOAuth2Parameters);
//
//			model.addAttribute("google_url", url);
//
//			/* �깮�꽦�븳 �씤利� URL�쓣 View濡� �쟾�떖 */
//			return "login";
//		}
//	}
//	
//	@RequestMapping(value = "/logout", method = { RequestMethod.GET, RequestMethod.POST })
//	public String logout(HttpSession session) {
//		session.invalidate();
//		return "redirect:/login";
//	}
//    
//    @RequestMapping(value = "/oauth2callback", method = { RequestMethod.GET, RequestMethod.POST })
//    public String googleCallback(Model model, @RequestParam String code, HttpServletRequest request, HttpSession session) throws IOException {
//
//    	OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
//        AccessGrant accessGrant = oauthOperations.exchangeForAccess(code , googleOAuth2Parameters.getRedirectUri(), null);
//        
//        String accessToken = accessGrant.getAccessToken();
//        Long expireTime = accessGrant.getExpireTime();
//        
//        if (expireTime != null && expireTime < System.currentTimeMillis()) {
//            accessToken = accessGrant.getRefreshToken();
//            System.out.printf("accessToken is expired. refresh token = {}", accessToken);
//        }
//        Connection<Google> connection = googleConnectionFactory.createConnection(accessGrant);
//        Google google = connection == null ? new GoogleTemplate(accessToken) : connection.getApi();
//        
//        PlusOperations plusOperations = google.plusOperations();
//        Person profile = plusOperations.getGoogleProfile();
//
//        //Save into DB
//        UserVo user = new UserVo();
//        
//        user.setUid(profile.getAccountEmail());
//        user.setOauth_code(profile.getId());
//        
//        session.setAttribute("ID", user.getUid());
//        
//    	return "redirect:/dcp";
//    }
//	
//	public void setSession(HttpSession session) {
//		if (session.getAttribute("UUID") == null) {
//			personalUUID = System.currentTimeMillis() + UUID.randomUUID().toString();
//			session.setAttribute("UUID", personalUUID);
//		}else {
//			personalUUID = (String) session.getAttribute("UUID");
//		}
//	}
//	
//	@RequestMapping(value = "/dcp/tiff", method = RequestMethod.POST)
//	public String tiff(@ModelAttribute TiffVo tiffVo, HttpSession session) {
//		if(checkLogin(session)) {
//			setSession(session);
//			
//			String workDir = localDir + personalUUID;
//			dcpService.convertTiff(tiffVo, workDir);
//			
//			return "redirect:/dcp";
//		}else {
//			return "redirect:/login";
//		}
//	}
//	
//	@RequestMapping(value = "/dcp/jpeg", method = RequestMethod.POST)
//	public String jpeg(@ModelAttribute JpegVo jpegVo, HttpSession session) {
//		if(checkLogin(session)) {
//			setSession(session);
//			
//			String workDir = localDir + personalUUID;
//			dcpService.convertJpeg(jpegVo, workDir);
//			
//			return "redirect:/dcp";
//		}else {
//			return "redirect:/login";
//		}
//	}
//	
//	@RequestMapping(value = "/dcp/mxf", method = RequestMethod.POST)
//	public String mxf(@ModelAttribute MxfVo mxfVo, HttpSession session) {
//		if(checkLogin(session)) {
//			setSession(session);
//			
//			String workDir = localDir + personalUUID;
//			dcpService.convertMxf(mxfVo, workDir);
//			
//			return "redirect:/dcp";
//		}else {
//			return "redirect:/login";
//		}
//	}
//	
//	@RequestMapping(value = "/dcp/dcp", method = RequestMethod.POST)
//	public String dcp(@ModelAttribute DcpVo dcpVo, HttpSession session) {
//		if(checkLogin(session)) {
//			setSession(session);
//			
//			String workDir = localDir + personalUUID;
//			dcpService.convertDcp(dcpVo, workDir);
//			
//			return "redirect:/dcp";
//		}else {
//			return "redirect:/login";
//		}
//	}
//	
//	@RequestMapping(value = "/dcp/onestop", method = RequestMethod.POST)
//	public String onestop(@ModelAttribute OneStopVo oneStopVo, HttpSession session) {
//		if(checkLogin(session)) {
//			setSession(session);
//			
//			String workDir = localDir + personalUUID;
//			
//			logger.info("Start uploadFile / " + new Date());
//			dcpService.uploadFile(oneStopVo, workDir);
//			int frame = dcpService.getPlayTime(oneStopVo.getPictureReel().getOriginalFilename(), workDir);
//			logger.info("Start convertToTiffJ2c / " + new Date() + " / fame = " + frame);
//			dcpService.convertToTiffJ2c(oneStopVo, workDir, frame);
//			logger.info("Start convertToMxf / " + new Date());
//			dcpService.convertToMxf(oneStopVo, workDir);
//			logger.info("Start convertToDcp / " + new Date());
//			dcpService.convertToDcp(oneStopVo, workDir);
//			logger.info("End convertToDcp / " + new Date());
//		
//			return "redirect:/dcp";
//		}else {
//			return "redirect:/login";
//		}
//	}
//	
//	public Boolean checkLogin(HttpSession session) {
//		if(session.getAttribute("ID") == null) {
//			return false;
//		}else {
//			return true;
//		}
//	}
//	
//	@ResponseBody
//	@RequestMapping(value = "/dcp/checkdownload", method = RequestMethod.POST)
//	public String checkdownload(@RequestParam("filename")String filename, HttpSession session) {
//		String fileFullPath = localDir +  (String) session.getAttribute("UUID") + "\\";
//	    File downloadFile = new File(fileFullPath + filename + ".zip");
//	    
//	    if(downloadFile.exists()) {
//	    	return "true";
//	    }else {
//	    	return "false";
//	    }
//	}
//	
//	@RequestMapping(value = "/dcp/download")
//	public ModelAndView callDownload(@RequestParam("dw") String dw, HttpSession session) {
//		String fileFullPath = localDir +  (String) session.getAttribute("UUID") + "\\";
//	    File downloadFile = new File(fileFullPath + dw + ".zip");
//	    return new ModelAndView("fileDownloadView", "downloadFile",downloadFile);
//	}
//	
//	@ResponseBody
//	@RequestMapping(value = "/dcp/uploadmedia")
//	public void uploadMedia(MultipartHttpServletRequest req, HttpSession session) {
//		setSession(session);
//
//		String workDir = localDir + personalUUID;
//		
//		MultipartFile file = req.getFile("pictureReel");
//		dcpService.uploadMedia(file, workDir);
//	}
//	
//    @RequestMapping(value="/dcp/stream/{fileName:.+}", method= RequestMethod.GET) 
//    public String getContentMediaVideo(@PathVariable("fileName")String fileName,HttpServletRequest request, 
//    		HttpServletResponse response,HttpSession session) throws UnsupportedEncodingException, IOException {
//    	setSession(session);
//    	
//    	int pos = fileName .lastIndexOf(".");
//		String _fileName = fileName.substring(0, pos);
//		fileName = _fileName + ".mp4";
//		
//		//progressbar 占쎈퓠占쎄퐣 占쎈뱟占쎌젟 占쎌맄燁살꼶占쏙옙 占쎄깻�뵳占쏙옙釉�椰꾧퀡援� 占쎈퉸占쎄퐣 占쎌뿫占쎌벥 占쎌맄燁살꼷�벥 占쎄땀占쎌뒠占쎌뱽 占쎌뒄筌ｏ옙占쎈막 占쎈땾 占쎌뿳占쎌몵沃섓옙嚥∽옙
//		//占쎈솁占쎌뵬占쎌벥 占쎌뿫占쎌벥占쎌벥 占쎌맄燁살꼷肉됵옙苑� 占쎌뵭占쎈선占쎌궎疫뀐옙 占쎌맄占쎈퉸 RandomAccessFile 占쎄깻占쎌삋占쎈뮞�몴占� 占쎄텢占쎌뒠占쎈립占쎈뼄.
//		//占쎈퉸占쎈뼣 占쎈솁占쎌뵬占쎌뵠 占쎈씨占쎌뱽 野껋럩�뒭 占쎌굙占쎌뇚 獄쏆뮇源�
//		File file = new File(localDir + personalUUID + "\\" + fileName);
//      
//		RandomAccessFile randomFile = new RandomAccessFile(file, "r");
//
//		long rangeStart = 0; //占쎌뒄筌ｏ옙 甕곕뗄�맄占쎌벥 占쎈뻻占쎌삂 占쎌맄燁삼옙
//		long rangeEnd = 0;  //占쎌뒄筌ｏ옙 甕곕뗄�맄占쎌벥 占쎄국 占쎌맄燁삼옙
//		boolean isPart=false; //�겫占썽겫占� 占쎌뒄筌ｏ옙占쎌뵬 野껋럩�뒭 true, 占쎌읈筌ｏ옙 占쎌뒄筌ｏ옙占쎌벥 野껋럩�뒭 false
//
//		//randomFile 占쎌뱽 占쎄깻嚥≪뮇已� 占쎈릭疫뀐옙 占쎌맄占쎈릭占쎈연 try~finally 占쎄텢占쎌뒠
//		try{
//			//占쎈짗占쎌겫占쎄맒 占쎈솁占쎌뵬 占쎄쾿疫뀐옙
//			long movieSize = randomFile.length(); 
//			//占쎈뮞占쎈뱜�뵳占� 占쎌뒄筌ｏ옙 甕곕뗄�맄, request占쎌벥 占쎈엘占쎈쐭占쎈퓠占쎄퐣 range�몴占� 占쎌뵭占쎈뮉占쎈뼄.
//			String range = request.getHeader("range");
//
//
//			//�뇡�슢�뵬占쎌뒭占쏙옙占쎈퓠 占쎈뎡占쎌뵬 range 占쎌굨占쎈뻼占쎌뵠 占쎈뼄�몴紐껊쑓, 疫꿸퀡�궚 占쎌굨占쎈뻼占쏙옙 "bytes={start}-{end}" 占쎌굨占쎈뻼占쎌뵠占쎈뼄.
//			//range揶쏉옙 null占쎌뵠椰꾧퀡援�, reqStart揶쏉옙  0占쎌뵠�⑨옙 end揶쏉옙 占쎈씨占쎌뱽 野껋럩�뒭 占쎌읈筌ｏ옙 占쎌뒄筌ｏ옙占쎌뵠占쎈뼄.
//			//占쎌뒄筌ｏ옙 甕곕뗄�맄�몴占� �뤃�뗫립占쎈뼄.
//			if(range!=null) {
//				//筌ｌ꼶�봺占쎌벥 占쎈젶占쎌벥�몴占� 占쎌맄占쎈퉸 占쎌뒄筌ｏ옙 range占쎈퓠 end 揶쏅�れ뵠 占쎈씨占쎌뱽 野껋럩�뒭 占쎄퐫占쎈선餓ο옙
//				if(range.endsWith("-")){
//					range = range+(movieSize - 1); 
//				}
//				int idxm = range.trim().indexOf("-");                           //"-" 占쎌맄燁삼옙
//				rangeStart = Long.parseLong(range.substring(6,idxm));
//				rangeEnd = Long.parseLong(range.substring(idxm+1));
//				if(rangeStart > 0){
//					isPart = true;
//				}
//			}else{   //range揶쏉옙 null占쎌뵥 野껋럩�뒭 占쎈짗占쎌겫占쎄맒 占쎌읈筌ｏ옙 占쎄쾿疫꿸퀡以� �룯�뜃由겼첎誘れ뱽 占쎄퐫占쎈선餓ο옙. 0�겫占쏙옙苑� 占쎈뻻占쎌삂占쎈릭沃섓옙嚥∽옙 -1
//				rangeStart = 0;
//              	rangeEnd = movieSize - 1;
//			}
//
//			//占쎌읈占쎈꽊 占쎈솁占쎌뵬 占쎄쾿疫뀐옙
//			long partSize = rangeEnd - rangeStart + 1;
//
//			//占쎌읈占쎈꽊占쎈뻻占쎌삂
//			response.reset();
//
//			//占쎌읈筌ｏ옙 占쎌뒄筌ｏ옙占쎌뵬 野껋럩�뒭 200, �겫占썽겫占� 占쎌뒄筌ｏ옙占쎌뵬 野껋럩�뒭 206占쎌뱽 獄쏆꼹�넎占쎄맒占쎄묶 �굜遺얜굡嚥∽옙 筌욑옙占쎌젟
//			response.setStatus(isPart ? 206 : 200);
//
//			//mime type 筌욑옙占쎌젟
//			response.setContentType("video/mp4");
//
//			//占쎌읈占쎈꽊 占쎄땀占쎌뒠占쎌뱽 占쎈엘占쎈굡占쎈퓠 占쎄퐫占쎈선餓ο옙占쎈뼄. 筌띾뜆占쏙쭕�맩肉� 占쎈솁占쎌뵬 占쎌읈筌ｏ옙 占쎄쾿疫꿸퀡占쏙옙 占쎄퐫占쎈뮉占쎈뼄.
//			response.setHeader("Content-Range", "bytes "+rangeStart+"-"+rangeEnd+"/"+movieSize);
//			response.setHeader("Accept-Ranges", "bytes");
//			response.setHeader("Content-Length", ""+partSize);
//
//			OutputStream out = response.getOutputStream();
//			//占쎈짗占쎌겫占쎄맒 占쎈솁占쎌뵬占쎌벥 占쎌읈占쎈꽊占쎈뻻占쎌삂 占쎌맄燁삼옙 筌욑옙占쎌젟
//			randomFile.seek(rangeStart);
//
//			//占쎈솁占쎌뵬 占쎌읈占쎈꽊...  java io占쎈뮉 1占쎌돳 占쎌읈占쎈꽊 byte占쎈땾揶쏉옙 int嚥∽옙 筌욑옙占쎌젟占쎈쭡
//			//占쎈짗占쎌겫占쎄맒 占쎈솁占쎌뵬占쎌벥 野껋럩�뒭 int占쎌굨占쎌몵嚥≪뮆�뮉 筌ｌ꼶�봺 占쎈툧占쎈┷占쎈뮉 占쎄쾿疫꿸퀣�벥 占쎈솁占쎌뵬占쎌뵠 占쎌뿳占쎌몵沃섓옙嚥∽옙
//			//8kb嚥∽옙 占쎌삋占쎌뵬占쎄퐣 占쎈솁占쎌뵬占쎌벥 占쎄쾿疫꿸퀗占� 占쎄쾿占쎈쐭占쎌뵬占쎈즲 �눧紐꾩젫揶쏉옙 占쎈┷筌욑옙 占쎈륫占쎈즲嚥∽옙 �뤃�뗭겱
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
//			//占쎌읈占쎈꽊 餓λ쵐肉� �뇡�슢�뵬占쎌뒭占쏙옙�몴占� 占쎈뼍椰꾧퀡援�, 占쎌넅筌롫똻�뱽 占쎌읈占쎌넎占쎈립 野껋럩�뒭 �넫�굝利븝옙鍮먲옙鍮� 占쎈릭沃섓옙嚥∽옙 占쎌읈占쎈꽊�뿆�뫁�꺖.
//			// progressBar�몴占� 占쎄깻�뵳占쏙옙釉� 野껋럩�뒭占쎈퓠占쎈뮉 占쎄깻�뵳占쏙옙釉� 占쎌맄燁살꼵而わ옙�몵嚥∽옙 占쎌삺占쎌뒄筌ｏ옙占쎌뵠 占쎈굶占쎈선占쎌궎沃섓옙嚥∽옙 占쎌읈占쎈꽊 �뿆�뫁�꺖.
//		}finally{
//         randomFile.close();
//		}
//		return null;
//    }
//    
//}
