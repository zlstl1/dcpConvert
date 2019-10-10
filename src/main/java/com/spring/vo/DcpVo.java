package com.spring.vo;

import java.util.Arrays;

import org.springframework.web.multipart.MultipartFile;

public class DcpVo {
	String title;
	String annotation;
	String issuer;
	String rating;
	String kind;
	MultipartFile[] dcpReel;
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
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
	public MultipartFile[] getDcpReel() {
		return dcpReel;
	}
	public void setDcpReel(MultipartFile[] dcpReel) {
		this.dcpReel = dcpReel;
	}
	@Override
	public String toString() {
		return "DcpVo [title=" + title + ", annotation=" + annotation + ", issuer=" + issuer + ", rating=" + rating
				+ ", kind=" + kind + ", dcpReel=" + Arrays.toString(dcpReel) + "]";
	}
}
