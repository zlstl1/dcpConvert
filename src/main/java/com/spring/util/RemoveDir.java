package com.spring.util;

import java.io.File;

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
				folder.delete();
			}
		} catch (Exception e) {
			e.getStackTrace();
		}
	}
}
