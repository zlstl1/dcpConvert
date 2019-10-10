package com.spring.vo;

import java.util.Arrays;

import org.springframework.web.multipart.MultipartFile;

public class MxfVo {
	String title;
	String Label;
	String scale;
	int frameRate;
	String fileType;
	boolean encryption;
	String key;
	String keyID;
	MultipartFile[] pictureReel;
	MultipartFile[] soundReel;
	MultipartFile subtitleReel;
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getLabel() {
		return Label;
	}
	public void setLabel(String label) {
		Label = label;
	}
	public String getScale() {
		return scale;
	}
	public void setScale(String scale) {
		this.scale = scale;
	}
	public int getFrameRate() {
		return frameRate;
	}
	public void setFrameRate(int frameRate) {
		this.frameRate = frameRate;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public boolean isEncryption() {
		return encryption;
	}
	public void setEncryption(boolean encryption) {
		this.encryption = encryption;
	}
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getKeyID() {
		return keyID;
	}
	public void setKeyID(String keyID) {
		this.keyID = keyID;
	}
	public MultipartFile[] getPictureReel() {
		return pictureReel;
	}
	public void setPictureReel(MultipartFile[] pictureReel) {
		this.pictureReel = pictureReel;
	}
	public MultipartFile[] getSoundReel() {
		return soundReel;
	}
	public void setSoundReel(MultipartFile[] soundReel) {
		this.soundReel = soundReel;
	}
	public MultipartFile getSubtitleReel() {
		return subtitleReel;
	}
	public void setSubtitleReel(MultipartFile subtitleReel) {
		this.subtitleReel = subtitleReel;
	}
	
	@Override
	public String toString() {
		return "MxfVo [title=" + title + ", Label=" + Label + ", scale=" + scale + ", frameRate=" + frameRate
				+ ", fileType=" + fileType + ", encryption=" + encryption + ", key=" + key + ", keyID=" + keyID
				+ ", pictureReel=" + Arrays.toString(pictureReel) + ", soundReel=" + Arrays.toString(soundReel)
				+ ", subtitleReel=" + subtitleReel + "]";
	}
}
