package com.spring.vo;

import java.util.Date;

public class UserVo {
    int user_no;
	String user_id;
	String user_name;
	int user_usingGpu;
	int user_storageCapa;
	int user_approve;
	boolean user_admin;
	Date user_joined;
	Date user_connect;
	String user_status;
	String user_email; 
	String user_grade;
	
	public int getUser_no() {
		return user_no;
	}
	public void setUser_no(int user_no) {
		this.user_no = user_no;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public int getUser_usingGpu() {
		return user_usingGpu;
	}
	public void setUser_usingGpu(int user_usingGpu) {
		this.user_usingGpu = user_usingGpu;
	}
	public int getUser_storageCapa() {
		return user_storageCapa;
	}
	public void setUser_storageCapa(int user_storageCapa) {
		this.user_storageCapa = user_storageCapa;
	}
	public int getUser_approve() {
		return user_approve;
	}
	public void setUser_approve(int user_approve) {
		this.user_approve = user_approve;
	}
	public boolean isUser_admin() {
		return user_admin;
	}
	public void setUser_admin(boolean user_admin) {
		this.user_admin = user_admin;
	}
	public Date getUser_joined() {
		return user_joined;
	}
	public void setUser_joined(Date user_joined) {
		this.user_joined = user_joined;
	}
	public Date getUser_connect() {
		return user_connect;
	}
	public void setUser_connect(Date user_connect) {
		this.user_connect = user_connect;
	}
	public String getUser_status() {
		return user_status;
	}
	public void setUser_status(String user_status) {
		this.user_status = user_status;
	}
	public String getUser_email() {
		return user_email;
	}
	public void setUser_email(String user_email) {
		this.user_email = user_email;
	}
	public String getUser_grade() {
		return user_grade;
	}
	public void setUser_grade(String user_grade) {
		this.user_grade = user_grade;
	}

	@Override
	public String toString() {
		return "UserVo [user_no=" + user_no + ", user_id=" + user_id + ", user_name=" + user_name + ", user_usingGpu="
				+ user_usingGpu + ", user_storageCapa=" + user_storageCapa + ", user_approve=" + user_approve
				+ ", user_admin=" + user_admin + ", user_joined=" + user_joined + ", user_connect=" + user_connect
				+ ", user_status=" + user_status + ", user_email=" + user_email + ", user_grade=" + user_grade + "]";
	}
    
}
