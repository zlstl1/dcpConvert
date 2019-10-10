package com.spring.vo;

import java.util.Arrays;

import org.springframework.web.multipart.MultipartFile;

public class JpegVo {
	int bandWidth;
	int frameRate;
	MultipartFile[] pictureReel;
	
	public int getBandWidth() {
		return bandWidth;
	}
	public void setBandWidth(int bandWidth) {
		this.bandWidth = bandWidth;
	}
	public int getFrameRate() {
		return frameRate;
	}
	public void setFrameRate(int frameRate) {
		this.frameRate = frameRate;
	}
	public MultipartFile[] getPictureReel() {
		return pictureReel;
	}
	public void setPictureReel(MultipartFile[] pictureReel) {
		this.pictureReel = pictureReel;
	}
	
	@Override
	public String toString() {
		return "JpegVo [bandWidth=" + bandWidth + ", frameRate=" + frameRate + ", pictureReel="
				+ Arrays.toString(pictureReel) + "]";
	}
}
