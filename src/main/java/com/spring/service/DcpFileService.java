package com.spring.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring.util.Common;
import com.spring.util.RemoveDir;
import com.spring.vo.FileVo;

@Service
public class DcpFileService {

	@Autowired
	Common common;
	@Autowired
	DcpCommonService dcpCommonService;
	
	public void moveFile(String email, String path, List<String> items){
		for(int i=0; i<items.size(); i++) {
			File file = new File(common.getLocalDir() + email + items.get(i));
			File fileToMove = new File(common.getLocalDir() + email + path + "/" + file.getName());
			file.renameTo(fileToMove);
		}
	}
	
	public void saveFile(String workDir, MultipartFile file) {
		try {
			dcpCommonService.makeDir(workDir);
			File dumpfile = new File(workDir + "/" + file.getOriginalFilename());
			file.transferTo(dumpfile);
		} catch (IllegalStateException e) {
		} catch (IOException e) {
		}
	}
	
	public void deleteFile(List<String> items, String email) {
		try {
			for(int i=0;i<items.size();i++) {
				File file = new File(common.getLocalDir()+email+"/"+items.get(i));
				if(file.isDirectory()) {
					RemoveDir removeDir = new RemoveDir(common.getLocalDir()+email+"/"+items.get(i));
					removeDir.start();
					removeDir.join();
				}else {
					file.delete();
				}
			}
		} catch (Exception e) {
		}
	}
	
	public List<FileVo> getFileList(String email, String path) {
		File folder = new File(common.getLocalDir()+email+"/"+path);
		List<FileVo> fileList = new ArrayList<FileVo>();
		String fileName;
		String fileType;
		try {
			if(folder.exists()){
				File[] folder_list = folder.listFiles();
				sortFileList(folder_list);
				
				for (int i = 0; i < folder_list.length; i++) {
					if(folder_list[i].isDirectory()) {
						fileName = folder_list[i].getName();
						fileType = "folder";
						FileVo fileVo = new FileVo();
						fileVo.setFileName(fileName);
						fileVo.setFileType(fileType);
						fileList.add(fileVo);
					}
				}
				
				for (int i = 0; i < folder_list.length; i++) {
					if(folder_list[i].isFile()) {
						fileName = folder_list[i].getName();
						fileType = "file";
						FileVo fileVo = new FileVo();
						fileVo.setFileName(fileName);
						fileVo.setFileType(fileType);
						fileList.add(fileVo);
					}
				}
				
			}
		} catch (Exception e) {
			e.getStackTrace();
		}
		return fileList;
	}
	
    public File[] sortFileList(File[] files) {
    	Arrays.sort(files,new Comparator<Object>(){
    		@Override
    		public int compare(Object object1, Object object2) {
    				String s1 = "";
    				String s2 = "";
         
    				s1 = ((File)object1).getName();
    				s2 = ((File)object2).getName();
         
    				return s1.compareTo(s2);
    		}
    	});
    	return files;
    }
	
	@SuppressWarnings("unchecked")
	public JSONArray getDirectoryList(String email) {
		JSONArray jsonArray = new JSONArray();
		JSONArray rtjsonArray = new JSONArray();
		try {
			jsonArray = getDirectoryListFunc(common.getLocalDir()+email, email);
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("key", "/");
			jsonObject.put("title", email);
			jsonObject.put("folder", true);
			jsonObject.put("children", jsonArray);
			rtjsonArray.add(jsonObject);
		} catch (Exception e) {
			e.getStackTrace();
		}
		return rtjsonArray;
	}
	
	@SuppressWarnings("unchecked")
	public JSONArray getDirectoryListFunc(String path, String email) {
		File folder = new File(path);
		JSONArray parentArray = new JSONArray();
		JSONArray childArray = new JSONArray();
		JSONObject jsonObject = null;
		String title = "";
		
		try {
			if(folder.exists()){
				File[] folder_list = folder.listFiles();
				
				for (int i = 0; i < folder_list.length; i++) {
					if(folder_list[i].isDirectory()) {
						title = folder_list[i].getName();
						jsonObject = new JSONObject();
						String key = folder_list[i].getAbsolutePath().substring(folder_list[i].getAbsolutePath().lastIndexOf(email)+email.length());
						jsonObject.put("key", key);
						jsonObject.put("title", title);
						jsonObject.put("folder", true);

						File nextFolder = new File(folder_list[i].getAbsolutePath());
						int count = 0;
						File[] nextFolder_list = nextFolder.listFiles();
						for(int j = 0; j < nextFolder_list.length; j++) {
							if(nextFolder_list[j].isDirectory()) {
								count++;
							}
						}
						if(count != 0) {
							childArray = getDirectoryListFunc(folder_list[i].getAbsolutePath(),email);
							jsonObject.put("children", childArray);
						}
						parentArray.add(jsonObject);
					}
				}
			}
		} catch (Exception e) {
			e.getStackTrace();
		}
		return parentArray;
	}
	
	public String getDirectorySize(String email) {
		long size = FileUtils.sizeOfDirectory(new File(common.getLocalDir()+email));
		double dSize = size / (double)1024 / (double)1024 / (double)1024;
		return String.format("%.2f", dSize);
	}
}
