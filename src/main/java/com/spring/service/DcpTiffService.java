package com.spring.service;

import java.io.File;
import java.io.FileInputStream;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring.dao.DcpHistoryDao;
import com.spring.util.Common;
import com.spring.vo.HistoryVo;
import com.spring.vo.TiffVo;

@Service
public class DcpTiffService {
	@Autowired
	DcpCommonService dcpCommon;
	@Autowired
	DcpHistoryDao dcpHistoryDao;
	@Autowired
	Common common;
	
	public void convertTiff(TiffVo tiffVo,String workDir,List<String> items, String path, HistoryVo historyVo) {
		common.dbug("convertTiff - DcpTiffService ::: ");
		File dumpfile = new File(workDir+items.get(0));
		
		try {
			FileInputStream input = new FileInputStream(dumpfile);
			MultipartFile tiffFile = new MockMultipartFile("file",dumpfile.getName(), "text/plain", IOUtils.toByteArray(input));
			tiffVo.setPictureReel(tiffFile);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		if(tiffVo.getPictureReel() != null) {
			dcpCommon.makeDir(workDir + path + "/TIFF");
			int frame = dcpCommon.getPlayTime(tiffVo.getPictureReel().getOriginalFilename(), dumpfile.getParent());
			if(frame == -1) {
				 frame = dcpCommon.getPlayTime2(tiffVo.getPictureReel().getOriginalFilename(), dumpfile.getParent());
			}
			int startnum = 1;
	    	int halfFrame = frame/2;
	    	
			Thread divTiff = new DivideTiff(tiffVo, workDir + path, dumpfile.getParent(), startnum - 1, halfFrame - 1);
	    	Thread divTiff2 = new DivideTiff(tiffVo, workDir + path, dumpfile.getParent(), halfFrame, frame -1);
	    	
			divTiff.start();
			divTiff2.start();
			
//	    	int startnum = 1;
//	    	int middleFrame = frame/3;
//	    	int thirdFrame = (frame/3) * 2;
//	    	
//	    	Thread divTiff = new DivideTiff(tiffVo, workDir + path, dumpfile.getParent(), startnum - 1, middleFrame - 1);
//	    	Thread divTiff2 = new DivideTiff(tiffVo, workDir + path, dumpfile.getParent(), middleFrame, thirdFrame -1);
//	    	Thread divTiff3 = new DivideTiff(tiffVo, workDir + path, dumpfile.getParent(), thirdFrame, frame -1);
//	    	
//	    	divTiff.start();
//			divTiff2.start();
//			divTiff3.start();
			
			historyVo.setHistory_msg("TIFF 변환");
			dcpHistoryDao.writeHistory(historyVo);
			
			try {
				divTiff.join();
				divTiff2.join();
				//divTiff3.join();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
//			logger.info("Start zip / " + new Date());
//			dcpCommon.zipDir(workDir + "\\TIFF"); // 66s 2.03GB
//			logger.info("End zip / " + new Date());
//			RemoveDir removeDir = new RemoveDir(workDir + "\\TIFF");
//			removeDir.start();
		}
	}
	
	public class DivideTiff extends Thread{
		TiffVo tiffVo;
    	String workDir;
    	String originalPath;
    	int start;
    	int end;
    	
    	public DivideTiff(TiffVo tiffVo, String workDir, String originalPath, int start, int end) {
    		this.tiffVo = tiffVo;
    		this.workDir = workDir;
    		this.originalPath = originalPath;
    		this.start = start;
    		this.end = end;
    	}
    	
       	public void run() {
    		MultipartFile file = tiffVo.getPictureReel();
    		
    		if(file != null) {
    			String orgName = originalPath + "/" + file.getOriginalFilename();
    			String[] cmd;
    			
    			if(tiffVo.getScale().equals("scope")) {
    				cmd = new String[] {
    	    				"ffmpeg",
    	    				"-n",
    	    				"-i",orgName,
    	    				"-q:v",String.valueOf(tiffVo.getQuality()),
    	    				"-aspect","2.39",
    	    				"-s","2048:858",
    	    				"-an",
    	    				"-pix_fmt","rgb48le",
    	    				"-src_range","1",
    	    				"-dst_range","1",
    	    				"-r",String.valueOf(tiffVo.getFrameRate()),
    	    				"-filter_complex","select=between(n\\," + start + "\\," + end +"),setpts=PTS-STARTPTS",
    	    				"-start_number",String.valueOf((start + 1)),
    	    				workDir + "/TIFF/" + tiffVo.getTitle() + "%0" + tiffVo.getLength() + "d.tiff"
    	    		};
    			}else {
	    			cmd = new String[] {
	    				"ffmpeg",
	    				"-n",
	    				"-i",orgName,
	    				"-q:v",String.valueOf(tiffVo.getQuality()),
	    				"-aspect","1.85",
	    				"-s","1988:1080",
	    				"-an",
	    				"-pix_fmt","rgb48le",
	    				"-src_range","1",
	    				"-dst_range","1",
	    				"-r",String.valueOf(tiffVo.getFrameRate()),
	    				"-filter_complex","select=between(n\\," + start + "\\," + end +"),setpts=PTS-STARTPTS",
	    				"-start_number",String.valueOf((start + 1)),
	    				workDir + "/TIFF/" + tiffVo.getTitle() + "%0" + tiffVo.getLength() + "d.tiff"
	    			};
    			}
    			dcpCommon.runCli(cmd,workDir);
    			
    		}
       	}
    }
}
