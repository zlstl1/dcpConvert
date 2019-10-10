package com.spring.service;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.DcpHistoryDao;
import com.spring.util.Common;
import com.spring.util.RemoveDir;
import com.spring.vo.HistoryVo;
import com.spring.vo.MxfVo;

@Service
public class DcpMxfService {
	@Autowired
	DcpCommonService dcpCommon;
	@Autowired
	DcpHistoryDao dcpHistoryDao;
	@Autowired
	Common common;
	
	public void convertMxf(MxfVo mxfVo,String workDir,List<String> items, String path, HistoryVo historyVo) {
		String title = "";
		
		switch(mxfVo.getFileType()) {
		case "picture":
			dcpCommon.makeDir(workDir + path + "/MXF");
			title = workDir + path + "/MXF/" + mxfVo.getTitle() + "picture.mxf";
			String[] cmd = new String[] {
				"opendcp_mxf",
				"-i",workDir + items.get(0),
				"-o",title,
				"-n",mxfVo.getLabel(),
				"-r",String.valueOf(mxfVo.getFrameRate())
			};
			dcpCommon.runCli(cmd,workDir);
			
			historyVo.setHistory_msg("MXF 변환 - PICTURE");
			dcpHistoryDao.writeHistory(historyVo);
			break;
		case "sound":
			dcpCommon.makeDir(workDir + path + "/MXF");
			title = workDir + path + "/MXF/" + mxfVo.getTitle() + "sound.mxf";
			String[] cmd2 = new String[] {
					"opendcp_mxf",
					"-i",workDir + items.get(0),
					"-o",title,
					"-n",mxfVo.getLabel(),
					"-r",String.valueOf(mxfVo.getFrameRate())
			};
			dcpCommon.runCli(cmd2,workDir);
			
			historyVo.setHistory_msg("MXF 변환 - SOUND");
			dcpHistoryDao.writeHistory(historyVo);
			break;
		case "subtitle":
			dcpCommon.makeDir(workDir + path + "/MXF");
			dcpCommon.makeDir(workDir + path + "/SUBTITLE");
			int ratio = mxfVo.getScale().equals("scope")?239:185;
			
			String[] cmd3 = new String[] {
					"dcpomatic2_create",
					"-o",workDir + path + "/SUBTITLE",
					"--container-ratio",String.valueOf(ratio),
					"--content-ratio",String.valueOf(ratio),
					"-f",String.valueOf(mxfVo.getFrameRate()),
					"--no-use-isdcf-name","--no-sign",
					"--j2k-bandwidth","10",
					"-n","subtitleMXF",
					workDir + items.get(0)
			};
			
			dcpCommon.runCli("whoami",workDir);
			dcpCommon.runCli(cmd3,workDir);
			String[] cmd4 = new String[] {
					"dcpomatic2_cli",
					workDir + path + "/SUBTITLE"
			};
			dcpCommon.runCli(cmd4,workDir);
		
			String FilePath = workDir + path + "/SUBTITLE/subtitleMXF";
			File FileList = new File(FilePath);
			
			String fileList[] = FileList.list();
			
			for(int i=0; i<fileList.length; i++){
				String FileName = fileList[i];
				
				if(FileName.contains("sub")){
					File file = new File(workDir + path + "/SUBTITLE/subtitleMXF/" + FileName);
					File fileToMove = new File(workDir + path + "/MXF/" + mxfVo.getTitle() + "subtitle.mxf");
					file.renameTo(fileToMove);
				}
			}
			
			RemoveDir removeDir = new RemoveDir(workDir + path + "/SUBTITLE");
			removeDir.start();
			
			historyVo.setHistory_msg("MXF 변환 - SUBTITLE");
			dcpHistoryDao.writeHistory(historyVo);
			break;
		}
	}
	
//	public void convertMxf(MxfVo mxfVo,String workDir) {
//		String opendcp_mxf = common.getLibDir() + "\\opendcp\\opendcp_mxf.exe ";
//		
//		String title = "";
//		String cli = "";
//		ExecutorService executorService = Executors.newFixedThreadPool(3);
//		
//		if(mxfVo.getPictureReel()[0].getSize() != 0) {
//			dcpCommon.makeDir(workDir + "\\MXF");
//			MultipartFile[] files = mxfVo.getPictureReel();
//			for(MultipartFile file : files) {
//				dcpCommon.saveFile(workDir + "\\PICTURE", file);
//			}
//			title = workDir + "\\MXF\\" + mxfVo.getTitle() + "picture.mxf";
//			cli = "-i " + workDir + "\\PICTURE" + " -o " + title + " -n " + mxfVo.getLabel() + " -r " + mxfVo.getFrameRate();
//			if(mxfVo.isEncryption()) {
//				cli += " -k " + mxfVo.getKey() + " -u " + mxfVo.getKeyID();
//			}
//			dcpCommon.runCli(opendcp_mxf + cli,workDir);
//			
//			executorService.submit(new RemoveDir(workDir + "\\PICTURE"));
//		}
//		
//		if(mxfVo.getSoundReel()[0].getSize() != 0) {
//			dcpCommon.makeDir(workDir + "\\MXF");
//			MultipartFile[] files = mxfVo.getSoundReel();
//			for(MultipartFile file : files) {
//				dcpCommon.saveFile(workDir + "\\SOUND", file);
//			}
//			title = workDir + "\\MXF\\" + mxfVo.getTitle() + "sound.mxf";
//			cli = "-i " + workDir + "\\SOUND" + " -o " + title + " -n " + mxfVo.getLabel() + " -r " + mxfVo.getFrameRate();
//			if(mxfVo.isEncryption()) {
//				cli += " -k " + mxfVo.getKey() + " -u " + mxfVo.getKeyID();
//			}
//			dcpCommon.runCli(opendcp_mxf + cli,workDir);
//			
//			executorService.submit(new RemoveDir(workDir + "\\SOUND"));
//		}
//		
//		if(mxfVo.getSubtitleReel().getSize()!=0) {
//			dcpCommon.makeDir(workDir + "\\MXF");
//			dcpCommon.saveFile(workDir + "\\SUBTITLE", mxfVo.getSubtitleReel());
//
//			String dcp_create = common.getLibDir() + "\\dcpomatic\\dcpomatic2_create.exe ";
//			String dcp_cli = common.getLibDir() + "\\dcpomatic\\dcpomatic2_cli.exe ";
//			int ratio = mxfVo.getScale().equals("scope")?239:185;
//			
//			cli = "-o " + workDir + "\\SUBTITLE --container-ratio " + ratio + " --content-ratio " + ratio + " -f " + mxfVo.getFrameRate()
//				+ " --no-use-isdcf-name --no-sign --j2k-bandwidth 10 -n subtitleMXF " + workDir + "\\SUBTITLE\\" + mxfVo.getSubtitleReel().getOriginalFilename(); 
//			
//			dcpCommon.runCli(dcp_create + cli,workDir);
//			dcpCommon.runCli(dcp_cli + workDir + "\\SUBTITLE",workDir);
//			
//			String FilePath = workDir + "\\SUBTITLE\\subtitleMXF";
//			File FileList = new File(FilePath);
//			
//			String fileList[] = FileList.list();
//			
//			for(int i=0; i<fileList.length; i++){
//				String FileName = fileList[i];
//				
//				if(FileName.contains("sub")){
//					File file = new File(workDir + "\\SUBTITLE\\subtitleMXF\\" + FileName);
//					File fileToMove = new File(workDir+"\\MXF\\" + mxfVo.getTitle() + "subtitle.mxf");
//					file.renameTo(fileToMove);
//				}
//			}
//			
//			executorService.submit(new RemoveDir(workDir + "\\SUBTITLE"));
//		}
//		
//		dcpCommon.zipDir(workDir+"\\MXF");
//		
//		RemoveDir removeDir = new RemoveDir(workDir + "\\MXF");
//		removeDir.start();
//		
//		executorService.shutdown();
//        while(!executorService.isTerminated()) {}
//	}
}
