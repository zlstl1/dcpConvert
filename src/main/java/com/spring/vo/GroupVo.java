package com.spring.vo;

import java.util.Date;

public class GroupVo {
	int group_no;
	String group_name;
	int group_usingGpu;
	int group_storageCapa;
	Date group_create;
	Date group_update;
	//DB에는 없음 web에서 표시해주기 위함
	int group_count;
	
	
	public int getGroup_no() {
		return group_no;
	}
	public void setGroup_no(int group_no) {
		this.group_no = group_no;
	}
	public String getGroup_name() {
		return group_name;
	}
	public void setGroup_name(String group_name) {
		this.group_name = group_name;
	}
	public int getGroup_usingGpu() {
		return group_usingGpu;
	}
	public void setGroup_usingGpu(int group_usingGpu) {
		this.group_usingGpu = group_usingGpu;
	}
	public int getGroup_storageCapa() {
		return group_storageCapa;
	}
	public void setGroup_storageCapa(int group_storageCapa) {
		this.group_storageCapa = group_storageCapa;
	}
	public Date getGroup_create() {
		return group_create;
	}
	public void setGroup_create(Date group_create) {
		this.group_create = group_create;
	}
	public Date getGroup_update() {
		return group_update;
	}
	public void setGroup_update(Date group_update) {
		this.group_update = group_update;
	}
	
	public int getGroup_count() {
		return group_count;
	}
	public void setGroup_count(int group_count) {
		this.group_count = group_count;
	}
	@Override
	public String toString() {
		return "GroupVo [group_no=" + group_no + ", group_name=" + group_name + ", group_usingGpu=" + group_usingGpu
				+ ", group_storageCapa=" + group_storageCapa + ", group_create=" + group_create + ", group_update="
				+ group_update + ", group_count=" + group_count + "]";
	}
	
	
}
