package jp.co.sss.shop.form;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * レビュー情報のフォームクラス
 */
public class ReviewForm {

	/**
	 * 商品ID
	 */
	@NotNull
	private Integer itemId;

	/**
	 * 評価
	 */
	@NotNull
	@Min(1)
	@Max(5)
	private Integer rating;

	/**
	 * 本文
	 */
	@Size(max = 500)
	private String body;

	/**
	 * スタンプID
	 */
	private Integer stampId;

	/**
	 * 商品IDの取得
	 * @return 商品ID
	 */
	public Integer getItemId() {
		return itemId;
	}

	/**
	 * 商品IDのセット
	 * @param itemId 商品ID
	 */
	public void setItemId(Integer itemId) {
		this.itemId = itemId;
	}

	/**
	 * 評価の取得
	 * @return 評価
	 */
	public Integer getRating() {
		return rating;
	}

	/**
	 * 評価のセット
	 * @param rating 評価
	 */
	public void setRating(Integer rating) {
		this.rating = rating;
	}

	/**
	 * 本文の取得
	 * @return 本文
	 */
	public String getBody() {
		return body;
	}

	/**
	 * 本文のセット
	 * @param body 本文
	 */
	public void setBody(String body) {
		this.body = body;
	}

	/**
	 * スタンプIDの取得
	 * @return スタンプID
	 */
	public Integer getStampId() {
		return stampId;
	}

	/**
	 * スタンプIDのセット
	 * @param stampId スタンプID
	 */
	public void setStampId(Integer stampId) {
		this.stampId = stampId;
	}
}
