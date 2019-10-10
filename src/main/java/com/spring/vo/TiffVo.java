package com.spring.vo;

import org.springframework.web.multipart.MultipartFile;

public class TiffVo {
	String title;
	int length;
	int quality;
	String scale;
	int frameRate;
	MultipartFile pictureReel;
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getLength() {
		return length;
	}
	public void setLength(int length) {
		this.length = length;
	}
	public int getQuality() {
		return quality;
	}
	public void setQuality(int quality) {
		this.quality = quality;
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
	public MultipartFile getPictureReel() {
		return pictureReel;
	}
	public void setPictureReel(MultipartFile pictureReel) {
		this.pictureReel = pictureReel;
	}
	
	@Override
	public String toString() {
		return "TiffVo [title=" + title + ", length=" + length + ", quality=" + quality + ", scale=" + scale
				+ ", frameRate=" + frameRate + ", pictureReel=" + pictureReel + "]";
	}
}
