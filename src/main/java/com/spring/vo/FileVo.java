package com.spring.vo;

public class FileVo {
	String fileType;
	String fileName;
	
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	@Override
	public String toString() {
		return "FileVo [fileType=" + fileType + ", fileName=" + fileName + "]";
	}
}
