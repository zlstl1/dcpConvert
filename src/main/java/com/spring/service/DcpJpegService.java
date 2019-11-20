package com.spring.service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.DcpHistoryDao;
import com.spring.util.Common;
import com.spring.vo.HistoryVo;
import com.spring.vo.JpegVo;

@Service
public class DcpJpegService {
	@Autowired
	DcpCommonService dcpCommon;
	@Autowired
	DcpHistoryDao dcpHistoryDao;
	@Autowired
	Common common;
	
	public void convertJpeg(JpegVo jpegVo,String workDir,List<String> items, String path, HistoryVo historyVo) {
		common.dbug("convertJpeg - DcpJpegService ::: ");
		dcpCommon.makeDir(workDir + path + "/J2C");
		
		double audioBitrate = 6.9; //audioBitrate = bitDepth(24) * sampleRate(48000,96000) * channel (6.9Mbps)
		double videoBitrate = ( jpegVo.getBandWidth() - audioBitrate ) / 8; // (MB) 
		double perFrame = videoBitrate / jpegVo.getFrameRate() * 1000; // (KB)  => -size perFrame K
		System.out.println("perFrame = " + perFrame);
		
		int tiffslength = items.size();
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
					futureList.add(executorService.submit(new JpThread(startnum,end,workDir,items,perFrame,gpu,path)));
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
			e.printStackTrace();
		}
		
		historyVo.setHistory_msg("JPEG 변환");
		dcpHistoryDao.writeHistory(historyVo);
		
//		dcpCommon.zipDir(workDir + "\\J2C");
//        
//		RemoveDir removeDir = new RemoveDir(workDir + "\\J2C");
//		removeDir.start();
	}
	
	public class JpThread implements Runnable{
		int start;
		int end;
		String workDir;
		double perFrame;
		List<String> items;
		int gpu;
		String path;
		
		public JpThread(int start, int end, String workDir, List<String> items, double perFrame, int gpu, String path) {
			this.start = start;
			this.end = end;
			this.workDir = workDir;
			this.items = items;
			this.perFrame = perFrame;
			this.gpu = gpu;
			this.path = path;
		}
		
		public void run() {
			String cli = common.getLibDir() + "cuj2k ";
			cli += "-setdev " + gpu%2 + " -format j2c -cb 32 -irrev -size " + perFrame + "K -setpath " + workDir+path+"/J2C ";
			for (int i=start; i<=end;i++) {
				cli += workDir + items.get(i-1) + " ";
			}
			cli.trim();
			dcpCommon.runCli(cli.split(" "),workDir);
			
//			for (int i=start; i<=end;i++) {
//				File file = new File(workDir + "\\J2C\\" + files[i-1].getOriginalFilename());
//				file.delete();
//			}
		}
	}
}
