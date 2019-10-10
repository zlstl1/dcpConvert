package com.spring.vo;

public class HistoryVo {
	int history_no;
    int user_no;
    String history_msg;
    String history_date;
    
	public int getHistory_no() {
		return history_no;
	}
	public void setHistory_no(int history_no) {
		this.history_no = history_no;
	}
	public int getUser_no() {
		return user_no;
	}
	public void setUser_no(int user_no) {
		this.user_no = user_no;
	}
	public String getHistory_msg() {
		return history_msg;
	}
	public void setHistory_msg(String history_msg) {
		this.history_msg = history_msg;
	}
	public String getHistory_date() {
		return history_date;
	}
	public void setHistory_date(String history_date) {
		this.history_date = history_date;
	}
	
	@Override
	public String toString() {
		return "HistoryVo [history_no=" + history_no + ", user_no=" + user_no + ", history_msg=" + history_msg
				+ ", history_date=" + history_date + "]";
	}
    
}
