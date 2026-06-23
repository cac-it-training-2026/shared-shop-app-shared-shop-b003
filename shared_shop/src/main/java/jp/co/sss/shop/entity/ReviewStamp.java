package jp.co.sss.shop.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;

/**
 * レビュースタンプ情報のエンティティクラス
 */
@Entity
@Table(name = "review_stamps")
public class ReviewStamp {
	/**
	 * スタンプID
	 */
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_review_stamps_gen")
	@SequenceGenerator(name = "seq_review_stamps_gen", sequenceName = "seq_review_stamps", allocationSize = 1)
	private Integer id;

	/**
	 * スタンプ名
	 */
	@Column
	private String name;

	/**
	 * 画像パス
	 */
	@Column
	private String imagePath;

	/**
	 * 有効フラグ (1: 有効, 0: 無効)
	 */
	@Column
	private Integer active;

	/**
	 * スタンプIDの取得
	 * @return スタンプID
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * スタンプIDのセット
	 * @param id スタンプID
	 */
	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * スタンプ名の取得
	 * @return スタンプ名
	 */
	public String getName() {
		return name;
	}

	/**
	 * スタンプ名のセット
	 * @param name スタンプ名
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * 画像パスの取得
	 * @return 画像パス
	 */
	public String getImagePath() {
		return imagePath;
	}

	/**
	 * 画像パスのセット
	 * @param imagePath 画像パス
	 */
	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	/**
	 * 有効フラグの取得
	 * @return 有効フラグ
	 */
	public Integer getActive() {
		return active;
	}

	/**
	 * 有効フラグのセット
	 * @param active 有効フラグ
	 */
	public void setActive(Integer active) {
		this.active = active;
	}
}
