package com.spring.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring.vo.DcpVo;
import com.spring.vo.JpegVo;
import com.spring.vo.MxfVo;
import com.spring.vo.OneStopVo;
import com.spring.vo.TiffVo;

import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.util.Zip4jConstants;

@Service
public class DcpServiceBackup {
	
	final String libDir = "C:\\Users\\seok\\Desktop\\test\\spring-tool-suite-3.9.8.RELEASE-e4.11.0-win32-x86_64\\sts-bundle\\workspace\\opendcp\\src\\main\\webapp\\resources\\lib\\";
							
	final Logger logger = LoggerFactory.getLogger(DcpOneStopService.class);
	
	static int folder1 =0;
	static int folder2 =0;
	
	public void convertTiff(TiffVo tiffVo,String workDir) {
		if(tiffVo.getPictureReel().getSize()!=0) {
			logger.info("Start saveFile / " + new Date());
			MultipartFile file = tiffVo.getPictureReel();
			saveFile(workDir, file);
			
			makeDir(workDir + "\\TIFF");
			int frame = getPlayTime(tiffVo.getPictureReel().getOriginalFilename(), workDir);
			int startnum = 1;
	    	int halfFrame = frame/2;
	    	
	    	logger.info("Start div / " + new Date());
			Thread divTiff = new DivideTiff(tiffVo, workDir, startnum - 1, halfFrame - 1);
	    	Thread divTiff2 = new DivideTiff(tiffVo, workDir, halfFrame, frame -1);
	    	
	    	divTiff.start();
			divTiff2.start();
			
			try {
				divTiff.join();
				divTiff2.join();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			logger.info("Start zip / " + new Date());
			zipDir(workDir + "\\TIFF"); // 66s 2.03GB
			logger.info("End zip / " + new Date());
			
			RemoveDir removeDir = new RemoveDir(workDir + "\\TIFF");
			removeDir.start();
		}
	}
	
	public class DivideTiff extends Thread{
		TiffVo tiffVo;
    	String workDir;
    	int start;
    	int end;
    	
    	public DivideTiff(TiffVo tiffVo, String workDir, int start, int end) {
    		this.tiffVo = tiffVo;
    		this.workDir = workDir;
    		this.start = start;
    		this.end = end;
    	}
    	
    	public void run() {
    		MultipartFile file = tiffVo.getPictureReel();
    		
    		if(file.getSize()!=0) {
    			String orgName = file.getOriginalFilename();
    			String ffmpeg = libDir + "\\ffmpeg\\ffmpeg.exe ";
    			String cli = "-n -i " + orgName + " -q:v " + tiffVo.getQuality();
    			if(tiffVo.getScale().equals("scope")) {
    				cli += " -aspect 2.39 -s 2048:858 ";
    			}else {
    				cli += " -aspect 1.85 -s 1988:1080 ";
    			}
    			cli += "-an -pix_fmt rgb48le -src_range 1 -dst_range 1 -r " + tiffVo.getFrameRate() 
    			+ " -vf \"select=between(n\\," + start + "\\," + end +"),setpts=PTS-STARTPTS\" -start_number " + (start + 1)
    					+ " .\\TIFF\\" + tiffVo.getTitle() + "%0" + tiffVo.getLength() + "d.tiff";
    			runCli(ffmpeg + cli,workDir);
    		}
    	}
    }
	
	public void convertJpeg(JpegVo jpegVo,String workDir) {
		makeDir(workDir + "\\J2C");
		
		MultipartFile[] files = jpegVo.getPictureReel();
		for(MultipartFile file : files) {
			saveFile(workDir + "\\J2C", file);
		}

		double audioBitrate = 6.9; //audioBitrate = bitDepth(24) * sampleRate(48000,96000) * channel (6.9Mbps)
		double videoBitrate = ( jpegVo.getBandWidth() - audioBitrate ) / 8; // (MB) 
		double perFrame = videoBitrate / jpegVo.getFrameRate() * 1000; // (KB)  => -size perFrame K
		
		int tiffslength = files.length;
		int end = 0;
		int totalThreads = 2;				
		
		ExecutorService executorService = Executors.newFixedThreadPool(totalThreads);
		List<Future<?>> futureList = new ArrayList<Future<?>>(totalThreads);
		
		try {
			Thread.sleep(5000);
			int startnum = 1;
			int j2cBundle = 50;
			int gpu = 0;
			while(true) {
				if(futureList.size() < totalThreads && (startnum < tiffslength)) {
					end = startnum+j2cBundle < tiffslength?startnum+j2cBundle:tiffslength;
					futureList.add(executorService.submit(new JpThread(startnum,end,workDir,files,perFrame,gpu)));
					startnum+=j2cBundle;
					gpu++;
				}
				
				Iterator<Future<?>> iterator = futureList.iterator();
				while (iterator.hasNext()){
					if(iterator.next().isDone()) {
						iterator.remove();
					}
				}
				
				if(startnum >= tiffslength) {
					executorService.shutdown();
			        while(!executorService.isTerminated()) { }
			        break;
				}
				
			}
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
        zipDir(workDir + "\\J2C");
        
		RemoveDir removeDir = new RemoveDir(workDir + "\\J2C");
		removeDir.start();
	}
	
	public class JpThread implements Runnable{
		int start;
		int end;
		String workDir;
		double perFrame;
		MultipartFile[] files;
		int gpu;
		
		public JpThread(int start, int end, String workDir, MultipartFile[] files, double perFrame, int gpu) {
			this.start = start;
			this.end = end;
			this.workDir = workDir;
			this.files = files;
			this.perFrame = perFrame;
			this.gpu = gpu;
		}
		
		public void run() {
			String cuj2k = libDir + "cuj2k\\Encoding_CUDA.exe ";
			String cli = "-setdev " + gpu%2 + " -format j2c -cb 32 -irrev -size " + perFrame + "K";
			for (int i=start; i<=end;i++) {
				cli += " \"" + workDir + "\\J2C\\" + files[i-1].getOriginalFilename() + "\" " ;
			}
			runCli(cuj2k + cli,workDir);
			
			for (int i=start; i<=end;i++) {
				File file = new File(workDir + "\\J2C\\" + files[i-1].getOriginalFilename());
				file.delete();
			}
		}
	}
	
	public void convertMxf(MxfVo mxfVo,String workDir) {		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		String opendcp_mxf = libDir + "\\opendcp\\opendcp_mxf.exe ";
		
		String title = "";
		String cli = "";
		ExecutorService executorService = Executors.newFixedThreadPool(3);
		
		if(mxfVo.getPictureReel()[0].getSize() != 0) {
			makeDir(workDir + "\\MXF");
			MultipartFile[] files = mxfVo.getPictureReel();
			for(MultipartFile file : files) {
				saveFile(workDir + "\\PICTURE", file);
			}
			title = workDir + "\\MXF\\" + mxfVo.getTitle() + "picture.mxf";
			cli = "-i " + workDir + "\\PICTURE" + " -o " + title + " -n " + mxfVo.getLabel() + " -r " + mxfVo.getFrameRate();
			if(mxfVo.isEncryption()) {
				cli += " -k " + mxfVo.getKey() + " -u " + mxfVo.getKeyID();
			}
			runCli(opendcp_mxf + cli,workDir);
			
			executorService.submit(new RemoveDir(workDir + "\\PICTURE"));
		}
		
		if(mxfVo.getSoundReel()[0].getSize() != 0) {
			makeDir(workDir + "\\MXF");
			MultipartFile[] files = mxfVo.getSoundReel();
			for(MultipartFile file : files) {
				saveFile(workDir + "\\SOUND", file);
			}
			title = workDir + "\\MXF\\" + mxfVo.getTitle() + "sound.mxf";
			cli = "-i " + workDir + "\\SOUND" + " -o " + title + " -n " + mxfVo.getLabel() + " -r " + mxfVo.getFrameRate();
			if(mxfVo.isEncryption()) {
				cli += " -k " + mxfVo.getKey() + " -u " + mxfVo.getKeyID();
			}
			runCli(opendcp_mxf + cli,workDir);
			
			executorService.submit(new RemoveDir(workDir + "\\SOUND"));
		}
		
		if(mxfVo.getSubtitleReel().getSize()!=0) {
			makeDir(workDir + "\\MXF");
			saveFile(workDir + "\\SUBTITLE", mxfVo.getSubtitleReel());

			String dcp_create = libDir + "\\dcpomatic\\dcpomatic2_create.exe ";
			String dcp_cli = libDir + "\\dcpomatic\\dcpomatic2_cli.exe ";
			int ratio = mxfVo.getScale().equals("scope")?239:185;
			
			cli = "-o " + workDir + "\\SUBTITLE --container-ratio " + ratio + " --content-ratio " + ratio + " -f " + mxfVo.getFrameRate()
				+ " --no-use-isdcf-name --no-sign --j2k-bandwidth 10 -n subtitleMXF " + workDir + "\\SUBTITLE\\" + mxfVo.getSubtitleReel().getOriginalFilename(); 
			
			runCli(dcp_create + cli,workDir);
			runCli(dcp_cli + workDir + "\\SUBTITLE",workDir);
			
			String FilePath = workDir + "\\SUBTITLE\\subtitleMXF";
			File FileList = new File(FilePath);
			
			String fileList[] = FileList.list();
			
			for(int i=0; i<fileList.length; i++){
				String FileName = fileList[i];
				
				if(FileName.contains("sub")){
					File file = new File(workDir + "\\SUBTITLE\\subtitleMXF\\" + FileName);
					File fileToMove = new File(workDir+"\\MXF\\" + mxfVo.getTitle() + "subtitle.mxf");
					file.renameTo(fileToMove);
				}
			}
			
			executorService.submit(new RemoveDir(workDir + "\\SUBTITLE"));
		}
		
		zipDir(workDir+"\\MXF");
		
		RemoveDir removeDir = new RemoveDir(workDir + "\\MXF");
		removeDir.start();
		
		executorService.shutdown();
        while(!executorService.isTerminated()) {}
	}
	
	public void convertDcp(DcpVo dcpVo, String workDir) {
		workDir +="\\DCP";
		String opendcp_xml = libDir + "opendcp\\opendcp_xml.exe ";
		String cli = " -r ";
		
		if(dcpVo.getDcpReel()[0].getSize() != 0) {
			MultipartFile[] files = dcpVo.getDcpReel();
			for(MultipartFile file : files) {
				saveFile(workDir, file);
				cli += workDir + "\\" + file.getOriginalFilename() + " ";
			}
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
		cli = cli + "-s -m " + dcpVo.getRating() + " -k " + dcpVo.getKind();
		
		runCli(opendcp_xml + cli,workDir);
		
		zipDir(workDir);
		
		RemoveDir removeDir = new RemoveDir(workDir);
		removeDir.start();
	}
	
	// ONE STOP###############################################################################################
	public void uploadFile(OneStopVo oneStopVo, String workDir) {
		MultipartFile[] files = oneStopVo.getSoundReel();
		for(MultipartFile file : files) {
			if(file.getSize()!=0) {
				saveFile(workDir + "\\SOUND", file);
			}
		}
		
		if(oneStopVo.getPictureReel().getSize()!=0) {
			saveFile(workDir, oneStopVo.getPictureReel());
		}
		
		if(oneStopVo.getSubtitleReel().getSize()!=0) {
			saveFile(workDir + "\\SUBTITLE", oneStopVo.getSubtitleReel());
		}
	}
	
	public int getPlayTime(String originalFilename, String workDir) {
    	String ffmpeg = libDir + "ffmpeg\\ffprobe.exe ";
    	String cmd = ffmpeg + "-select_streams v -show_streams " + workDir + "\\" + originalFilename;
    	int frame = 0;
    	BufferedReader br = null;
    	
    	try {
				Process p = Runtime.getRuntime().exec(cmd, null, new File(workDir)); 
				p.getErrorStream().close(); 
				p.getOutputStream().close(); 
				
				br = new BufferedReader(new InputStreamReader(p.getInputStream()));
				String line;
				while ((line = br.readLine()) != null) {
					if(line.contains("nb_frames=")) {
						line = line.replaceFirst("nb_frames=", ""); 
						line = line.trim();
	                  
						frame = Integer.parseInt(line);
						
						break;
					}
				}
				p.waitFor();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
		    try {
		        if( br!=null ) {
		        	br.close();
		        }
		    } catch(IOException e) {
		    }
		}
    	return frame;
    }
	
	public void convertToTiffJ2c(OneStopVo oneStopVo, String workDir, int frame) {
    	//int totalThreads = Runtime.getRuntime().availableProcessors();
    	int totalThreads = 6;
    	int j2cBundle = 50;
    	ExecutorService executorService = Executors.newFixedThreadPool(totalThreads);
    	int startnum = 1;
    	int halfFrame = frame/2;
    	int startnum2 = halfFrame;
    	List<Future<?>> futureList = new ArrayList<Future<?>>(totalThreads);
    	
    	Thread divTiff = new DivideToTiff(oneStopVo, workDir, startnum - 1, halfFrame - 1, 1);
    	Thread divTiff2 = new DivideToTiff(oneStopVo, workDir, halfFrame, frame -1, 2);
    	Thread subtitleDcp = new subtitleDcp(oneStopVo, workDir);
		divTiff.start();
		divTiff2.start();
		subtitleDcp.start();
		
		double audioBitrate = 6.9; //audioBitrate = bitDepth(24) * sampleRate(/*48000*/,96000) * channel (6.9Mbps)
		double videoBitrate = ( oneStopVo.getBandWidth() - audioBitrate ) / 8; // (MB) 
		double perFrame = videoBitrate / oneStopVo.getFrameRate() * 1000; // (KB)  => -size perFrame K
		
    	try {
    		makeDir(workDir + "\\J2C");
    		Thread.sleep(2000);
    		halfFrame++;
    		int flag = 1;
    		int end = 0;
    		int gpu = 0;
    		while(true) {
    			File tiffDir = new File(workDir + "\\TIFF" + flag);
				File[] tiffs = tiffDir.listFiles();
				int tiffslength = tiffs.length;
				
				if(futureList.size() < totalThreads && (startnum < (startnum2-j2cBundle) || halfFrame < (frame-j2cBundle))) {
					if(flag == 1 && tiffslength-(folder1*j2cBundle) >= j2cBundle) {
						futureList.add(executorService.submit(new J2cThread(startnum,startnum+(j2cBundle-1),workDir,perFrame,flag,gpu)));
						startnum+=j2cBundle;
						folder1++;gpu++;
					}else if(flag == 2 && tiffslength-(folder2*j2cBundle) >= j2cBundle){
						futureList.add(executorService.submit(new J2cThread(halfFrame,halfFrame+(j2cBundle-1),workDir,perFrame,flag,gpu))); 
						halfFrame+=j2cBundle;
						folder2++;gpu++;
					}
				}else{
					if(futureList.size() < totalThreads && flag == 1 && startnum <= startnum2) {
						end = startnum+(j2cBundle-1)<=startnum2?startnum+(j2cBundle-1):startnum2;
						futureList.add(executorService.submit(new J2cThread(startnum,end,workDir,perFrame,flag,gpu)));
						startnum+=j2cBundle;
						folder1++;gpu++;
					}else if(futureList.size() < totalThreads && flag == 2 && halfFrame <= frame){
						end = halfFrame+(j2cBundle-1)<=frame?halfFrame+(j2cBundle-1):frame;
						futureList.add(executorService.submit(new J2cThread(halfFrame,end,workDir,perFrame,flag,gpu))); 
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
    		subtitleDcp.join();
    	} catch (Exception e) {
			e.printStackTrace();
		}
    }
	
	public class DivideToTiff extends Thread{
		OneStopVo oneStopVo;
    	String workDir;
    	int start;
    	int end;
    	int folderNum;
    	
    	public DivideToTiff(OneStopVo oneStopVo, String workDir, int start, int end, int folderNum) {
    		this.oneStopVo = oneStopVo;
    		this.workDir = workDir;
    		this.start = start;
    		this.end = end;
    		this.folderNum = folderNum;
    	}
    	
    	public void run() {
    		MultipartFile file = oneStopVo.getPictureReel();
    		
    		if(file.getSize()!=0) {
    			makeDir(workDir + "\\TIFF" + folderNum);
    			String orgName = file.getOriginalFilename();
    			String ffmpeg = libDir + "\\ffmpeg\\ffmpeg.exe ";
    			String cli = "-n -i " + orgName + " -q:v " + oneStopVo.getQuality();
    			if(oneStopVo.getScale().equals("scope")) {
    				cli += " -aspect 2.39 -s 2048:858 ";
    			}else {
    				cli += " -aspect 1.85 -s 1988:1080 ";
    			}
    			cli += "-an -pix_fmt rgb48le -src_range 1 -dst_range 1 -r " + oneStopVo.getFrameRate() 
    			+ " -vf \"select=between(n\\," + start + "\\," + end +"),setpts=PTS-STARTPTS\" -start_number " + (start + 1)
    					+ " .\\TIFF" + folderNum + "\\tiff%010d.tiff";
    			runCli(ffmpeg + cli,workDir);
    		}
    	}
    }
	
	public class subtitleDcp extends Thread{
		OneStopVo oneStopVo;
    	String workDir;
    	
    	public subtitleDcp(OneStopVo oneStopVo, String workDir) {
    		this.oneStopVo = oneStopVo;
    		this.workDir = workDir;
    	}
    	
    	public void run() {
    		String dcp_create = libDir + "\\dcpomatic\\dcpomatic2_create.exe ";
			String dcp_cli = libDir + "\\dcpomatic\\dcpomatic2_cli.exe ";
			String cli = "";
			int ratio = oneStopVo.getScale().equals("scope")?239:185;
			
			cli = "-o " + workDir + "\\SUBTITLE --container-ratio " + ratio + " --content-ratio " + ratio + " -f " + oneStopVo.getFrameRate()
				+ " --no-use-isdcf-name --no-sign --j2k-bandwidth 10 -n subtitleMXF " + workDir + "\\SUBTITLE\\" + oneStopVo.getSubtitleReel().getOriginalFilename(); 
			
			runCli(dcp_create + cli,workDir);
			runCli(dcp_cli + workDir + "\\SUBTITLE",workDir);
    	}
	}
	
	
	public class J2cThread implements Runnable{
		int start;
		int end;
		String workDir;
		double perFrame;
		int folderNum;
		int gpu;
		
		public J2cThread(int start, int end, String workDir, double perFrame, int folderNum, int gpu) {
			this.start = start;
			this.end = end;
			this.workDir = workDir;
			this.perFrame = perFrame;
			this.folderNum = folderNum;
			this.gpu = gpu;
		}
		
		public void run() {
			String cuj2k = libDir + "cuj2k\\Encoding_CUDA.exe ";
//			String cli = "";
//			if(gpu%2 == 0) {
//				cli = "-setdev 0 -format j2c -cb 32 -irrev -size " + perFrame +"k";
//			}else {
//				cli = "-setdev 1 -format j2c -cb 32 -irrev -size " + perFrame +"k";
//			}
			String cli = "-setdev " + gpu%2 + " -format j2c -cb 32 -irrev -size " + perFrame +"k";
			//String cli = "-format j2c -cb 32 -irrev -size " + perFrame +"k";
			for (int i=start; i<=end;i++) {
				cli += " \"" + workDir + "\\TIFF" + folderNum + "\\tiff" + String.format("%010d", i) + ".tiff\"" ;
			}
			runCli(cuj2k + cli,workDir);
			
			for (int i=start; i<=end;i++) {
				File file = new File(workDir + "\\TIFF" + folderNum + "\\tiff" + String.format("%010d", i) + ".tiff");
				file.delete();
			}
			if(folderNum == 1) {
				folder1--;
			}else {
				folder2--;
			}
		}
	}
	
	public void convertToMxf(OneStopVo oneStopVo, String workDir) {
		makeDir(workDir + "\\DCP");
		String opendcp_mxf = libDir + "\\opendcp\\opendcp_mxf.exe ";
		
		RemoveDir removeDir1 = new RemoveDir(workDir + "\\TIFF1");
		RemoveDir removeDir2 = new RemoveDir(workDir + "\\TIFF2");
		removeDir1.start();
		removeDir2.start();
		File video = new File(workDir + "\\" + oneStopVo.getPictureReel().getOriginalFilename());
		video.delete();
		
		String title = "";
		String cli = "";
		
		if(oneStopVo.getPictureReel().getSize()!=0) {
			title = workDir + "\\DCP\\" + oneStopVo.getTitle() + "picture.mxf";
			cli = "-i " + workDir + "\\J2C" + " -o " + title + " -n " + oneStopVo.getLabel() + " -r " + oneStopVo.getFrameRate();
			runCli(opendcp_mxf + cli,workDir);
		}
		
		if(oneStopVo.getSoundReel()[0].getSize() != 0) {	
			title = workDir + "\\DCP\\" + oneStopVo.getTitle() + "sound.mxf";
			cli = "-i " + workDir + "\\SOUND" + " -o " + title + " -n " + oneStopVo.getLabel() + " -r " + oneStopVo.getFrameRate();
			runCli(opendcp_mxf + cli,workDir);
			
			RemoveDir removeDir = new RemoveDir(workDir + "\\SOUND");
			removeDir.start();
		}
		
		if(oneStopVo.getSubtitleReel().getSize()!=0) {
			String FilePath = workDir + "\\SUBTITLE\\subtitleMXF";
			File FileList = new File(FilePath);
			
			String fileList[] = FileList.list();
			
			for(int i=0; i<fileList.length; i++){
				String FileName = fileList[i];
				
				if(FileName.contains("sub")){
					File file = new File(workDir + "\\SUBTITLE\\subtitleMXF\\" + FileName);
					File fileToMove = new File(workDir+"\\DCP\\" + oneStopVo.getTitle() + "subtitle.mxf");
					file.renameTo(fileToMove);
				}
			}
		}
		RemoveDir removeDir = new RemoveDir(workDir + "\\SUBTITLE");
		removeDir.start();
	}
	
	public void convertToDcp(OneStopVo oneStopVo, String workDir) {
//		RemoveDir removeDir = new RemoveDir(workDir + "\\J2C");
//		removeDir.start();
		
		workDir +="\\DCP";
		String opendcp_xml = libDir + "opendcp\\opendcp_xml.exe ";
		String cli = " -r " + workDir + "\\" + oneStopVo.getTitle() + "picture.mxf ";		
		if(oneStopVo.getSoundReel()[0].getSize() != 0) {
			cli += workDir + "\\" + oneStopVo.getTitle() + "sound.mxf ";
		}
		if(oneStopVo.getSubtitleReel().getSize() != 0) {
			cli += workDir + "\\" + oneStopVo.getTitle() + "subtitle.mxf ";
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
		cli = cli + "-s -m " + oneStopVo.getRating() + " -k " + oneStopVo.getKind();
		
		runCli(opendcp_xml + cli,workDir);
		logger.info("End convertToDcp without zip / " + new Date());
		
		zipDir(workDir);
		
		RemoveDir removeDirDCP = new RemoveDir(workDir);
		removeDirDCP.start();
	}
	
	public void uploadMedia(MultipartFile file, String workDir) {
		saveFile(workDir, file);
		String ffmpeg = libDir + "\\ffmpeg\\ffmpeg.exe ";
		String orgName = file.getOriginalFilename();
		String cli = "-n -i " + orgName;
		
		String fileName = FilenameUtils.getBaseName(file.getOriginalFilename());
		
		cli += " -c:v h264_nvenc -preset fast -b:v 1000K -maxrate 1000K .\\" + fileName + ".mp4";
		runCli(ffmpeg + cli,workDir);
	}
	
	public void saveFile(String workDir, MultipartFile file) {
		try {
			makeDir(workDir);
			File dumpfile = new File(workDir + "\\" + file.getOriginalFilename());
			file.transferTo(dumpfile);
		} catch (IllegalStateException e) {
		} catch (IOException e) {
		}
	}
	
	public class RemoveDir extends Thread {
		String removeDir;
		
		public RemoveDir (String removeDir) {
			this.removeDir = removeDir;
		}
		
		public void run(){
			File folder = new File(removeDir);
			try {
				if(folder.exists()){
					File[] folder_list = folder.listFiles();
					
					for (int i = 0; i < folder_list.length; i++) {
						if(folder_list[i].isFile()) {
							folder_list[i].delete();
						}else {
							RemoveDir removeDir = new RemoveDir(folder_list[i].getPath());
							removeDir.start();
							removeDir.join();
						}
						folder_list[i].delete();
					}
					folder.delete(); //폴더 삭제
				}
			} catch (Exception e) {
				e.getStackTrace();
			}
		}
	}
	
    public void zipDir(String zip_path) {
        String zipFileName = zip_path+".zip";       
        
        try {
             ZipFile zipfile = new ZipFile(zipFileName);
             ZipParameters parameters = new ZipParameters();
             parameters.setCompressionMethod(Zip4jConstants.COMP_DEFLATE);
             parameters.setCompressionLevel(Zip4jConstants.DEFLATE_LEVEL_FASTEST);
             zipfile.addFolder(zip_path, parameters);
         } catch (Exception e) {
         }
    }
    
	public void makeDir(String outputDir) {
		File desti = new File(outputDir);	
		
		if(!desti.exists()){				
			desti.mkdirs(); 
		}
	}
	
	public void runCli(String cli, String workDir) {
		try{ 
			Process p = Runtime.getRuntime().exec(cli, null, new File(workDir)); 
			p.getErrorStream().close(); 
			p.getInputStream().close(); 
			p.getOutputStream().close(); 
			p.waitFor();
		}catch(Exception e){ 
			System.out.println(e); 
		}
	}
	
}
