package jp.co.sss.shop.form;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * レビュー投稿用フォーム
 */
public class ReviewForm {
	/**
	 * 商品ID
	 */
	private Integer itemId;

	/**
	 * 評価
	 */
	@NotNull
	@Min(1)
	@Max(5)
	private Integer evaluation;

	/**
	 * 内容
	 */
	@Size(max = 1000)
	private String content;

	/**
	 * スタンプ
	 */
	private Integer stamp;

	public Integer getItemId() {
		return itemId;
	}

	public void setItemId(Integer itemId) {
		this.itemId = itemId;
	}

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
}
