package jp.co.sss.shop.entity;

import java.sql.Timestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;

/**
 * レビュー情報のエンティティクラス
 */
@Entity
@Table(name = "reviews")
public class Review {
	/**
	 * レビューID
	 */
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_reviews_gen")
	@SequenceGenerator(name = "seq_reviews_gen", sequenceName = "seq_reviews", allocationSize = 1)
	private Integer id;

	/**
	 * 商品情報
	 */
	@ManyToOne
	@JoinColumn(name = "item_id", referencedColumnName = "id")
	private Item item;

	/**
	 * 会員情報
	 */
	@ManyToOne
	@JoinColumn(name = "user_id", referencedColumnName = "id")
	private User user;

	/**
	 * 評価
	 */
	@Column
	private Integer rating;

	/**
	 * 本文
	 */
	@Column
	private String body;

	/**
	 * スタンプ情報
	 */
	@ManyToOne
	@JoinColumn(name = "stamp_id", referencedColumnName = "id")
	private ReviewStamp stamp;

	/**
	 * 削除フラグ
	 */
	@Column(insertable = false)
	private Integer deleteFlag;

	/**
	 * 登録日付
	 */
	@Column(insertable = false, updatable = false)
	private Timestamp insertDate;

	/**
	 * レビューIDの取得
	 * @return レビューID
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * スタンプ情報の取得
	 * @return スタンプ情報
	 */
	public ReviewStamp getStamp() {
		return stamp;
	}

	/**
	 * スタンプ情報のセット
	 * @param stamp スタンプ情報
	 */
	public void setStamp(ReviewStamp stamp) {
		this.stamp = stamp;
	}

	/**
	 * レビューIDのセット
	 * @param id レビューID
	 */
	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * 商品情報の取得
	 * @return 商品情報
	 */
	public Item getItem() {
		return item;
	}

	/**
	 * 商品情報のセット
	 * @param item 商品情報
	 */
	public void setItem(Item item) {
		this.item = item;
	}

	/**
	 * 会員情報の取得
	 * @return 会員情報
	 */
	public User getUser() {
		return user;
	}

	/**
	 * 会員情報のセット
	 * @param user 会員情報
	 */
	public void setUser(User user) {
		this.user = user;
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
	 * 削除フラグの取得
	 * @return 削除フラグ
	 */
	public Integer getDeleteFlag() {
		return deleteFlag;
	}

	/**
	 * 削除フラグのセット
	 * @param deleteFlag 削除フラグ
	 */
	public void setDeleteFlag(Integer deleteFlag) {
		this.deleteFlag = deleteFlag;
	}

	/**
	 * 登録日付の取得
	 * @return 登録日付
	 */
	public Timestamp getInsertDate() {
		return insertDate;
	}

	/**
	 * 登録日付のセット
	 * @param insertDate 登録日付
	 */
	public void setInsertDate(Timestamp insertDate) {
		this.insertDate = insertDate;
	}
}
