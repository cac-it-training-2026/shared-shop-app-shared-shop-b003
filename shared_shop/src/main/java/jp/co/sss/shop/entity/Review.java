package jp.co.sss.shop.entity;

import java.sql.Date;
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
 * 商品レビュー情報のエンティティクラス
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
	 * 評価 (1-5)
	 */
	@Column
	private Integer rating;

	/**
	 * コメント
	 */
	@Column
	private String comment;

	/**
	 * スタンプ
	 */
	@Column
	private String stamp;

	/**
	 * 登録日付
	 */
	@Column(insertable = false, updatable = false)
	private Date insertDate;

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
	 * レビューIDの取得
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * レビューIDのセット
	 */
	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * 評価の取得
	 */
	public Integer getRating() {
		return rating;
	}

	/**
	 * 評価のセット
	 */
	public void setRating(Integer rating) {
		this.rating = rating;
	}

	/**
	 * コメントの取得
	 */
	public String getComment() {
		return comment;
	}

	/**
	 * コメントのセット
	 */
	public void setComment(String comment) {
		this.comment = comment;
	}

	/**
	 * スタンプの取得
	 */
	public String getStamp() {
		return stamp;
	}

	/**
	 * スタンプのセット
	 */
	public void setStamp(String stamp) {
		this.stamp = stamp;
	}

	/**
	 * 登録日付の取得
	 */
	public Date getInsertDate() {
		return insertDate;
	}

	/**
	 * 登録日付のセット
	 */
	public void setInsertDate(Date insertDate) {
		this.insertDate = insertDate;
	}

	/**
	 * 商品エンティティの取得
	 */
	public Item getItem() {
		return item;
	}

	/**
	 * 商品エンティティのセット
	 */
	public void setItem(Item item) {
		this.item = item;
	}

	/**
	 * 会員エンティティの取得
	 */
	public User getUser() {
		return user;
	}

	/**
	 * 会員エンティティのセット
	 */
	public void setUser(User user) {
		this.user = user;
	}
}
