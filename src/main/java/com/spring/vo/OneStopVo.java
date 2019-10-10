package com.spring.vo;

import java.util.Arrays;

import org.springframework.web.multipart.MultipartFile;

public class OneStopVo {
	String title;
	int quality;
	int bandWidth;
	String annotation;
	String issuer;
	String rating;
	String kind;
	String label;
	String scale;
	int frameRate;
	String originalPath;
	MultipartFile pictureReel;
	MultipartFile[] soundReel;
	MultipartFile subtitleReel;
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getQuality() {
		return quality;
	}
	public void setQuality(int quality) {
		this.quality = quality;
	}
	public int getBandWidth() {
		return bandWidth;
	}
	public void setBandWidth(int bandWidth) {
		this.bandWidth = bandWidth;
	}
	public String getAnnotation() {
		return annotation;
	}
	public void setAnnotation(String annotation) {
		this.annotation = annotation;
	}
	public String getIssuer() {
		return issuer;
	}
	public void setIssuer(String issuer) {
		this.issuer = issuer;
	}
	public String getRating() {
		return rating;
	}
	public void setRating(String rating) {
		this.rating = rating;
	}
	public String getKind() {
		return kind;
	}
	public void setKind(String kind) {
		this.kind = kind;
	}
	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
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
	public String getOriginalPath() {
		return originalPath;
	}
	public void setOriginalPath(String originalPath) {
		this.originalPath = originalPath;
	}
	public MultipartFile getPictureReel() {
		return pictureReel;
	}
	public void setPictureReel(MultipartFile pictureReel) {
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
		return "OneStopVo [title=" + title + ", quality=" + quality + ", bandWidth=" + bandWidth + ", annotation="
				+ annotation + ", issuer=" + issuer + ", rating=" + rating + ", kind=" + kind + ", label=" + label
				+ ", scale=" + scale + ", frameRate=" + frameRate + ", originalPath=" + originalPath + ", pictureReel="
				+ pictureReel + ", soundReel=" + Arrays.toString(soundReel) + ", subtitleReel=" + subtitleReel + "]";
	}
	
}
