package com.spring.service;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring.dao.DcpHistoryDao;
import com.spring.util.Common;
import com.spring.util.RemoveDir;
import com.spring.vo.HistoryVo;
import com.spring.vo.OneStopVo;

@Service
public class DcpOneStopService {
	@Autowired
	DcpCommonService dcpCommon;
	@Autowired
	DcpHistoryDao dcpHistoryDao;
	@Autowired
	Common common;
	
	final Logger logger = LoggerFactory.getLogger(DcpOneStopService.class);
	
	static int folder1 =0;
	static int folder2 =0;
	static int folder3 =0;
	
	public void convertOneStop(OneStopVo oneStopVo, String workDir, List<String> items, String path, HistoryVo historyVo) {
		oneStopVo = classification(oneStopVo, workDir, items);
		int frame = dcpCommon.getPlayTime(oneStopVo.getPictureReel().getOriginalFilename(), oneStopVo.getOriginalPath());
		if(frame == -1) {
			 frame = dcpCommon.getPlayTime2(oneStopVo.getPictureReel().getOriginalFilename(), oneStopVo.getOriginalPath());
		}
		
		logger.info("Start convertToTiffJ2c / " + new Date());
		convertToTiffJ2c(oneStopVo, workDir, path, frame);
		logger.info("End convertToTiffJ2c / " + new Date());
		logger.info("Start convertToMxf / " + new Date());
		convertToMxf(oneStopVo, workDir+path);
		logger.info("End convertToMxf / " + new Date());
		logger.info("Start convertToDcp / " + new Date());
		convertToDcp(oneStopVo, workDir+path);
		logger.info("End convertToDcp / " + new Date());
		historyVo.setHistory_msg("ONESTOP 변환");
		dcpHistoryDao.writeHistory(historyVo);
	}
	
	public OneStopVo classification(OneStopVo oneStopVo, String workDir, List<String> items) {
		MultipartFile picturedumpfiles = null;
		MultipartFile[] sounddumpfiles = new MultipartFile[items.size()];
		MultipartFile subtitledumpfiles = null;
		MultipartFile savefile = null;
		int j=0;
		
		for(int i=0; i<items.size(); i++) {
			int pos = items.get(i).lastIndexOf(".");
			String ext = items.get(i).substring(pos + 1).toLowerCase();
			
			File dumpfile = new File(workDir+items.get(i));
			try {
				FileInputStream input = new FileInputStream(dumpfile);
				savefile = new MockMultipartFile("file",dumpfile.getName(), "text/plain", IOUtils.toByteArray(input));
			} catch (Exception e) {
				e.printStackTrace();
			}
			if(ext.equals("mp4") || ext.equals("mkv") || ext.equals("avi") || ext.equals("mov") || ext.equals("wmv") || ext.equals("mpeg")
					|| ext.equals("m4v") || ext.equals("asx") || ext.equals("mpg") || ext.equals("ogm")) {
				String originalPath = dumpfile.getParent();
				oneStopVo.setOriginalPath(originalPath);
				picturedumpfiles = savefile;
			}else if(ext.equals("wav")) {
				sounddumpfiles[j] = savefile;
				j++;
			}else if(ext.equals("srt")) {
				subtitledumpfiles = savefile;
			}
		}
		
		if(picturedumpfiles != null) {
			oneStopVo.setPictureReel(picturedumpfiles);
		}
		
		MultipartFile[] sounddumpfilesResize = new MultipartFile[j];
		for(int i=0; i<j; i++) {
			sounddumpfilesResize[i] = sounddumpfiles[i];
		}
		oneStopVo.setSoundReel(sounddumpfilesResize);
		
		if(subtitledumpfiles != null) {
			oneStopVo.setSubtitleReel(subtitledumpfiles);
		}
		
		return oneStopVo;
	}
	
	// ONE STOP###############################################################################################
	public void convertToTiffJ2c(OneStopVo oneStopVo, String workDir, String path, int frame) {
		//int totalThreads = Runtime.getRuntime().availableProcessors();
    	int totalThreads = 2;
    	int j2cBundle = 50;
    	ExecutorService executorService = Executors.newFixedThreadPool(totalThreads);
    	int startnum = 1;
    	int halfFrame = frame/2;
    	int startnum2 = halfFrame;
    	List<Future<?>> futureList = new ArrayList<Future<?>>(totalThreads);
    	
    	Thread divTiff = new DivideToTiff(oneStopVo, workDir, path, startnum - 1, halfFrame - 1, 1);
    	Thread divTiff2 = new DivideToTiff(oneStopVo, workDir, path, halfFrame, frame -1, 2);
		divTiff.start();
		divTiff2.start();
		Thread subtitleDcp = null;
		if(oneStopVo.getSubtitleReel() != null) {
			subtitleDcp = new subtitleDcp(oneStopVo, workDir, path);
			subtitleDcp.start();
		}
		
		double audioBitrate = 6.9; //audioBitrate = bitDepth(24) * sampleRate(/*48000*/,96000) * channel (6.9Mbps)
		double videoBitrate = ( oneStopVo.getBandWidth() - audioBitrate ) / 8; // (MB) 
		double perFrame = videoBitrate / oneStopVo.getFrameRate() * 1000; // (KB)  => -size perFrame K
		
    	try {
    		dcpCommon.makeDir(workDir + path + "/J2C");
    		Thread.sleep(2000);
    		halfFrame++;
    		int flag = 1;
    		int end = 0;
    		int gpu = 0;
    		while(true) {
    			File tiffDir = new File(workDir + path + "/TIFF" + flag);
				File[] tiffs = tiffDir.listFiles();
				int tiffslength = tiffs.length;
				
				if(futureList.size() < totalThreads && (startnum < (startnum2-j2cBundle) || halfFrame < (frame-j2cBundle))) {
					if(flag == 1 && tiffslength-(folder1*j2cBundle) >= j2cBundle && startnum < (startnum2-j2cBundle)) {
						futureList.add(executorService.submit(new J2cThread(startnum,startnum+(j2cBundle-1),workDir,path,perFrame,flag,gpu)));
						startnum+=j2cBundle;
						folder1++;gpu++;
					}else if(flag == 2 && tiffslength-(folder2*j2cBundle) >= j2cBundle && halfFrame < (frame-j2cBundle)){
						futureList.add(executorService.submit(new J2cThread(halfFrame,halfFrame+(j2cBundle-1),workDir,path,perFrame,flag,gpu))); 
						halfFrame+=j2cBundle;
						folder2++;gpu++;
					}
				}else{
					if(futureList.size() < totalThreads && flag == 1 && startnum <= startnum2) {
						end = startnum+(j2cBundle-1)<=startnum2?startnum+(j2cBundle-1):startnum2;
						futureList.add(executorService.submit(new J2cThread(startnum,end,workDir,path,perFrame,flag,gpu)));
						startnum+=j2cBundle;
						folder1++;gpu++;
					}else if(futureList.size() < totalThreads && flag == 2 && halfFrame <= frame){
						end = halfFrame+(j2cBundle-1)<=frame?halfFrame+(j2cBundle-1):frame;
						futureList.add(executorService.submit(new J2cThread(halfFrame,end,workDir,path,perFrame,flag,gpu))); 
						halfFrame+=j2cBundle;
						folder2++;gpu++;
					}
				}
				
				Iterator<Future<?>> iterator = futureList.iterator();
				while (iterator.hasNext()){
					if(iterator.next().isDone()) {
						iterator.remove();
					}
				}
				
				if(startnum >= startnum2 && halfFrame >= frame) {
					executorService.shutdown();
			        while(!executorService.isTerminated()) { }
			        break;
				}
				
				flag = flag==1?2:1;
    		}
    		divTiff.join();
    		divTiff2.join();
    		if(subtitleDcp != null) {
    			subtitleDcp.join();
    		}
    	} catch (Exception e) {
			e.printStackTrace();
		}
    }
	
	//ffmpeg 3분할 버전 (frame 절삭 계산필요)
//	public void convertToTiffJ2c(OneStopVo oneStopVo, String workDir, String path, int frame) {
//		//int totalThreads = Runtime.getRuntime().availableProcessors();
//    	int totalThreads = 2;
//    	int j2cBundle = 50;
//    	ExecutorService executorService = Executors.newFixedThreadPool(totalThreads);
//    	int startnum = 1;
//    	int middleFrame = frame/3;
//    	int endFrame = (frame/3) * 2;
//    	int startnum2 = middleFrame;
//    	int startnum3 = endFrame;
//    	List<Future<?>> futureList = new ArrayList<Future<?>>(totalThreads);
//    	
//    	Thread divTiff = new DivideToTiff(oneStopVo, workDir, path, startnum - 1, middleFrame - 1, 1);
//    	Thread divTiff2 = new DivideToTiff(oneStopVo, workDir, path, middleFrame, endFrame -1, 2);
//    	Thread divTiff3 = new DivideToTiff(oneStopVo, workDir, path, endFrame, frame -1, 3);
//		divTiff.start();
//		divTiff2.start();
//		divTiff3.start();
//		Thread subtitleDcp = null;
//		if(oneStopVo.getSubtitleReel() != null) {
//			subtitleDcp = new subtitleDcp(oneStopVo, workDir, path);
//			subtitleDcp.start();
//		}
//		
//		double audioBitrate = 6.9; //audioBitrate = bitDepth(24) * sampleRate(/*48000*/,96000) * channel (6.9Mbps)
//		double videoBitrate = ( oneStopVo.getBandWidth() - audioBitrate ) / 8; // (MB) 
//		double perFrame = videoBitrate / oneStopVo.getFrameRate() * 1000; // (KB)  => -size perFrame K
//		
//    	try {
//    		dcpCommon.makeDir(workDir + path + "/J2C");
//    		Thread.sleep(2000);
//    		middleFrame++;
//    		endFrame++;
//    		int flag = 1;
//    		int end = 0;
//    		int gpu = 0;
//    		while(true) {
//    			File tiffDir = new File(workDir + path + "/TIFF" + flag);
//				File[] tiffs = tiffDir.listFiles();
//				int tiffslength = tiffs.length;
//				
//				if(futureList.size() < totalThreads && (startnum < (startnum2-j2cBundle) || middleFrame < (startnum3-j2cBundle) || endFrame < (frame-j2cBundle))) {
//					if(flag == 1 && tiffslength-(folder1*j2cBundle) >= j2cBundle && startnum < (startnum2-j2cBundle)) {
//						futureList.add(executorService.submit(new J2cThread(startnum,startnum+(j2cBundle-1),workDir,path,perFrame,flag,gpu)));
//						startnum+=j2cBundle;
//						folder1++;gpu++;
//					}else if(flag == 2 && tiffslength-(folder2*j2cBundle) >= j2cBundle && middleFrame < (startnum3-j2cBundle)){
//						futureList.add(executorService.submit(new J2cThread(middleFrame,middleFrame+(j2cBundle-1),workDir,path,perFrame,flag,gpu))); 
//						middleFrame+=j2cBundle;
//						folder2++;gpu++;
//					}else if(flag == 3 && tiffslength-(folder3*j2cBundle) >= j2cBundle && endFrame < (frame-j2cBundle)){
//						futureList.add(executorService.submit(new J2cThread(endFrame,endFrame+(j2cBundle-1),workDir,path,perFrame,flag,gpu))); 
//						endFrame+=j2cBundle;
//						folder3++;gpu++;
//					}
//				}else{
//					if(futureList.size() < totalThreads && flag == 1 && startnum <= startnum2) {
//						System.out.println("TIFF1 끝나기 1세트 전");
//						end = startnum+(j2cBundle-1)<=startnum2?startnum+(j2cBundle-1):startnum2;
//						futureList.add(executorService.submit(new J2cThread(startnum,end,workDir,path,perFrame,flag,gpu)));
//						startnum+=j2cBundle;
//						folder1++;gpu++;
//					}else if(futureList.size() < totalThreads && flag == 2 && middleFrame <= startnum3){
//						System.out.println("TIFF2 끝나기 1세트 전");
//						end = middleFrame+(j2cBundle-1)<=startnum3?middleFrame+(j2cBundle-1):startnum3;
//						futureList.add(executorService.submit(new J2cThread(middleFrame,end,workDir,path,perFrame,flag,gpu))); 
//						middleFrame+=j2cBundle;
//						folder2++;gpu++;
//					}else if(futureList.size() < totalThreads && flag == 3 && endFrame <= frame){
//						System.out.println("TIFF3 끝나기 1세트 전");
//						end = endFrame+(j2cBundle-1)<=frame?endFrame+(j2cBundle-1):frame;
//						futureList.add(executorService.submit(new J2cThread(endFrame,end,workDir,path,perFrame,flag,gpu))); 
//						endFrame+=j2cBundle;
//						folder3++;gpu++;
//					}
//				}
//				
//				Iterator<Future<?>> iterator = futureList.iterator();
//				while (iterator.hasNext()){
//					if(iterator.next().isDone()) {
//						iterator.remove();
//					}
//				}
//				
//				if(startnum >= startnum2 && middleFrame >= startnum3 && endFrame >= frame) {
//					System.out.println("종료");
//					executorService.shutdown();
//			        while(!executorService.isTerminated()) { }
//			        break;
//				}
//				
//				flag++;
//				flag = flag==4?1:flag;
//    		}
//    		divTiff.join();
//    		divTiff2.join();
//    		divTiff3.join();
//    		if(subtitleDcp != null) {
//    			subtitleDcp.join();
//    		}
//    	} catch (Exception e) {
//			e.printStackTrace();
//		}
//    }
	
	public class DivideToTiff extends Thread{
		OneStopVo oneStopVo;
    	String workDir;
    	String path;
    	int start;
    	int end;
    	int folderNum;
    	
    	public DivideToTiff(OneStopVo oneStopVo, String workDir, String path,int start, int end, int folderNum) {
    		this.oneStopVo = oneStopVo;
    		this.workDir = workDir;
    		this.path = path;
    		this.start = start;
    		this.end = end;
    		this.folderNum = folderNum;
    	}

    	public void run() {
    		MultipartFile file = oneStopVo.getPictureReel();
    		String orgName = oneStopVo.getOriginalPath() + "/" + file.getOriginalFilename();
    		String[] cmd;
    		
    		if(file.getSize()!=0) {
    			dcpCommon.makeDir(workDir + path + "/TIFF" + folderNum);
    			if(oneStopVo.getScale().equals("scope")) {
    				cmd = new String[] {
    	    				"ffmpeg",
    	    				"-n",
    	    				"-i",orgName,
    	    				"-q:v",String.valueOf(oneStopVo.getQuality()),
    	    				"-aspect","2.39",
    	    				"-s","2048:858",
    	    				"-an",
    	    				"-pix_fmt","rgb48le",
    	    				"-src_range","1",
    	    				"-dst_range","1",
    	    				"-r",String.valueOf(oneStopVo.getFrameRate()),
    	    				"-filter_complex","select=between(n\\," + start + "\\," + end +"),setpts=PTS-STARTPTS",
    	    				"-start_number",String.valueOf((start + 1)),
    	    				workDir + path + "/TIFF" + folderNum + "/tiff%010d.tiff"
    	    		};
    			}else {
	    			cmd = new String[] {
	    				"ffmpeg",
	    				"-n",
	    				"-i",orgName,
	    				"-q:v",String.valueOf(oneStopVo.getQuality()),
	    				"-aspect","1.85",
	    				"-s","1988:1080",
	    				"-an",
	    				"-pix_fmt","rgb48le",
	    				"-src_range","1",
	    				"-dst_range","1",
	    				"-r",String.valueOf(oneStopVo.getFrameRate()),
	    				"-filter_complex","select=between(n\\," + start + "\\," + end +"),setpts=PTS-STARTPTS",
	    				"-start_number",String.valueOf((start + 1)),
	    				workDir + path + "/TIFF" + folderNum + "/tiff%010d.tiff"
	    			};
    			}
    			dcpCommon.runCli(cmd,workDir);
    		}
    	}
    }
	
	public class subtitleDcp extends Thread{
		OneStopVo oneStopVo;
    	String workDir;
    	String path;
    	
    	public subtitleDcp(OneStopVo oneStopVo, String workDir, String path) {
    		this.oneStopVo = oneStopVo;
    		this.workDir = workDir;
    		this.path = path;
    	}
    	
    	public void run() {
			dcpCommon.makeDir(workDir + path + "/SUBTITLE");
			int ratio = oneStopVo.getScale().equals("scope")?239:185;
			
			String[] cmd1 = new String[] {
					"dcpomatic2_create",
					"-o", workDir + path + "/SUBTITLE",
					"--container-ratio",String.valueOf(ratio),
					"--content-ratio",String.valueOf(ratio),
					"-f",String.valueOf(oneStopVo.getFrameRate()),
					"--no-use-isdcf-name","--no-sign",
					"--j2k-bandwidth","10",
					"-n","subtitleMXF",
					oneStopVo.getOriginalPath() + "/" + oneStopVo.getSubtitleReel().getOriginalFilename()
			};
			
			String[] cmd2 = new String[] {
					"dcpomatic2_cli",
					workDir + path + "/SUBTITLE"
			};
			
			dcpCommon.runCli(cmd1,workDir);
			dcpCommon.runCli(cmd2,workDir);
    	}
	}
	
	
	public class J2cThread implements Runnable{
		int start;
		int end;
		String workDir;
		String path;
		double perFrame;
		int folderNum;
		int gpu;
		
		public J2cThread(int start, int end, String workDir, String path, double perFrame, int folderNum, int gpu) {
			this.start = start;
			this.end = end;
			this.workDir = workDir;
			this.path = path;
			this.perFrame = perFrame;
			this.folderNum = folderNum;
			this.gpu = gpu;
		}
		
		public void run() {
			String cli = common.getLibDir() + "cuj2k ";
			cli += "-setdev " + gpu%2 + " -format j2c -cb 32 -irrev -size " + perFrame + "K -setpath " + workDir+path+"/J2C ";
			for (int i=start; i<=end;i++) {
				cli += workDir + path + "/TIFF" + folderNum + "/tiff" + String.format("%010d", i) + ".tiff " ;
			}
			cli.trim();
			dcpCommon.runCli(cli.split(" "),workDir);
			
			for (int i=start; i<=end;i++) {
				File file = new File(workDir + path + "/TIFF" + folderNum + "/tiff" + String.format("%010d", i) + ".tiff");
				file.delete();
			}
			
			if(folderNum == 1) {
				folder1--;
			}else if (folderNum == 2){
				folder2--;
			}else {
				folder3--;
			}
		}
	}
	
	public void convertToMxf(OneStopVo oneStopVo, String workDir) {
		dcpCommon.makeDir(workDir + "/DCP");
		
		RemoveDir removeDir1 = new RemoveDir(workDir + "/TIFF1");
		RemoveDir removeDir2 = new RemoveDir(workDir + "/TIFF2");
		removeDir1.start();
		removeDir2.start();
		
		String title = "";
		
		if(oneStopVo.getPictureReel() != null) {
			title = workDir + "/DCP/" + oneStopVo.getTitle() + "picture.mxf";
			String[] cmd = new String[] {
				"opendcp_mxf",
				"-i",workDir + "/J2C",
				"-o",title,
				"-n",oneStopVo.getLabel(),
				"-r",String.valueOf(oneStopVo.getFrameRate())
			};
			dcpCommon.runCli(cmd,workDir);
		}
		
		if(oneStopVo.getSoundReel().length != 0) {	
			dcpCommon.makeDir(workDir + "/OneStopSound");
			title = workDir + "/DCP/" + oneStopVo.getTitle() + "sound.mxf";
			for(int i=0; i<oneStopVo.getSoundReel().length; i++) {
				File file = new File(oneStopVo.getOriginalPath() + "/" + oneStopVo.getSoundReel()[i].getOriginalFilename());
				File fileToMove = new File(workDir+"/OneStopSound/" + oneStopVo.getSoundReel()[i].getOriginalFilename());
				file.renameTo(fileToMove);
			}
			String[] cmd = new String[] {
					"opendcp_mxf",
					"-i",workDir + "/OneStopSound",
					"-o",title,
					"-n",oneStopVo.getLabel(),
					"-r",String.valueOf(oneStopVo.getFrameRate())
			};
			dcpCommon.runCli(cmd,workDir);
			
			for(int i=0; i<oneStopVo.getSoundReel().length; i++) {
				File file = new File(workDir+"/OneStopSound/" + oneStopVo.getSoundReel()[i].getOriginalFilename());
				File fileToMove = new File(oneStopVo.getOriginalPath() + "/" + oneStopVo.getSoundReel()[i].getOriginalFilename());
				file.renameTo(fileToMove);
			}
			
			RemoveDir removeDir = new RemoveDir(workDir + "/OneStopSound");
			removeDir.start();
			
		}
		
		if(oneStopVo.getSubtitleReel() != null) {
			dcpCommon.makeDir(workDir + "/SUBTITLE");
			String FilePath = workDir + "/SUBTITLE/subtitleMXF";
			File FileList = new File(FilePath);
			
			String fileList[] = FileList.list();
			
			for(int i=0; i<fileList.length; i++){
				String FileName = fileList[i];
				
				if(FileName.contains("sub")){
					File file = new File(workDir + "/SUBTITLE/subtitleMXF/" + FileName);
					File fileToMove = new File(workDir+"/DCP/" + oneStopVo.getTitle() + "subtitle.mxf");
					file.renameTo(fileToMove);
				}
			}
			RemoveDir removeDir = new RemoveDir(workDir + "/SUBTITLE");
			removeDir.start();
		}
	}
	
	public void convertToDcp(OneStopVo oneStopVo, String workDir) {
		RemoveDir removeDir = new RemoveDir(workDir + "/J2C");
		removeDir.start();
		
		workDir +="/DCP";
		String cli = "opendcp_xml ";
		if(oneStopVo.getPictureReel() != null) {
			cli += " -r " + workDir + "/" + oneStopVo.getTitle() + "picture.mxf ";	
		}
		if(oneStopVo.getSoundReel().length != 0) {
			cli += workDir + "/" + oneStopVo.getTitle() + "sound.mxf ";
		}
		if(oneStopVo.getSubtitleReel() != null) {
			cli += workDir + "/" + oneStopVo.getTitle() + "subtitle.mxf ";
		}
		if(!(oneStopVo.getIssuer().equals(""))) {
			cli += "-i " + oneStopVo.getIssuer() + " ";
		}
		if(!(oneStopVo.getAnnotation().equals(""))) {
			cli += "-a " + oneStopVo.getAnnotation() + " ";
		}
		if(!(oneStopVo.getTitle().equals(""))) {
			cli += "-t " + oneStopVo.getTitle() + " ";
		}
		cli = cli + "-m " + oneStopVo.getRating() + " -k " + oneStopVo.getKind();
		cli.trim();
		dcpCommon.runCli(cli.split(" "),workDir);
		
//		dcpCommon.zipDir(workDir);
//		
//		RemoveDir removeDirDCP = new RemoveDir(workDir);
//		removeDirDCP.start();
	}
	
	
}
