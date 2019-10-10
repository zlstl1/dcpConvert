package com.spring.vo;

public class PaginationVo {
	int listSize = 10;      // 한 페이지당 보여질 리스트의 개수          
	int rangeSize = 5;      // 한 페이지 범위에 보여질 페이지의 개수      
	int page;				// 현재 목록의 페이지 번호
	int range;				// 각 페이지 범위 시작 번호
	int listCnt;			// 전체 게시물의 개수
	int pageCnt;			// 전체 페이지 범위의 개수
	int startPage;			// 각 페이지 범위 시작 번호
	int startList;			// 현재 페이지의 게시물 시작 번호
	int endPage;			// 각 페이지 범위 끝 번호
	int user_no;
	boolean prev;			// 이전 페이지 여부
	boolean next;			// 다음 페이지 여부
	
	public int getListSize() {
		return listSize;
	}
	public void setListSize(int listSize) {
		this.listSize = listSize;
	}
	public int getRangeSize() {
		return rangeSize;
	}
	public void setRangeSize(int rangeSize) {
		this.rangeSize = rangeSize;
	}
	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		this.page = page;
	}
	public int getRange() {
		return range;
	}
	public void setRange(int range) {
		this.range = range;
	}
	public int getListCnt() {
		return listCnt;
	}
	public void setListCnt(int listCnt) {
		this.listCnt = listCnt;
	}
	public int getPageCnt() {
		return pageCnt;
	}
	public void setPageCnt(int pageCnt) {
		this.pageCnt = pageCnt;
	}
	public int getStartPage() {
		return startPage;
	}
	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}
	public int getStartList() {
		return startList;
	}
	public void setStartList(int startList) {
		this.startList = startList;
	}
	public int getEndPage() {
		return endPage;
	}
	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}
	public int getUser_no() {
		return user_no;
	}
	public void setUser_no(int user_no) {
		this.user_no = user_no;
	}
	public boolean isPrev() {
		return prev;
	}
	public void setPrev(boolean prev) {
		this.prev = prev;
	}
	public boolean isNext() {
		return next;
	}
	public void setNext(boolean next) {
		this.next = next;
	}
	
	@Override
	public String toString() {
		return "PaginationVo [listSize=" + listSize + ", rangeSize=" + rangeSize + ", page=" + page + ", range=" + range
				+ ", listCnt=" + listCnt + ", pageCnt=" + pageCnt + ", startPage=" + startPage + ", startList="
				+ startList + ", endPage=" + endPage + ", user_no=" + user_no + ", prev=" + prev + ", next=" + next
				+ "]";
	}
	
	public void pageInfo(int page, int range, int listCnt) {
		this.page = page;
		this.range = range;
		this.listCnt = listCnt;
		this.pageCnt = (int) Math.ceil((double)listCnt/(double)listSize);
		this.startPage = (range - 1) * rangeSize + 1 ;
		this.endPage = range * rangeSize;
		this.startList = (page - 1) * listSize;
		this.prev = range == 1 ? false : true;
		this.next = endPage >= pageCnt ? false : true;

		if (this.endPage >= this.pageCnt) {
			this.endPage = this.pageCnt;
			this.next = false;
		}
	}

}
