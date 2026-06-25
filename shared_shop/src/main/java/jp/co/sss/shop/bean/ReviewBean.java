package jp.co.sss.shop.bean;

/**
 * レビュー情報クラス
 */
public class ReviewBean {
	/**
	 * 評価
	 */
	private Integer evaluation;

	/**
	 * 内容
	 */
	private String content;

	/**
	 * スタンプ
	 */
	private Integer stamp;

	/**
	 * 投稿者名
	 */
	private String userName;

	/**
	 * 投稿日
	 */
	private String insertDate;

	public Integer getEvaluation() {
		return evaluation;
	}

	public void setEvaluation(Integer evaluation) {
		this.evaluation = evaluation;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Integer getStamp() {
		return stamp;
	}

	public void setStamp(Integer stamp) {
		this.stamp = stamp;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getInsertDate() {
		return insertDate;
	}

	public void setInsertDate(String insertDate) {
		this.insertDate = insertDate;
	}
}
