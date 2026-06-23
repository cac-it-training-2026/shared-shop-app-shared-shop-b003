package jp.co.sss.shop.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;

/**
 * 用途キーワードとカテゴリのマッピング用エンティティクラス
 */
@Entity
@Table(name = "planner_keyword_categories")
public class PlannerKeywordCategory {
	/**
	 * ID
	 */
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_planner_gen")
	@SequenceGenerator(name = "seq_planner_gen", sequenceName = "seq_planner_keyword_categories", allocationSize = 1)
	private Integer id;

	/**
	 * 用途キーワード
	 */
	@Column
	private String keyword;

	/**
	 * カテゴリ名
	 */
	@Column(name = "category_name")
	private String categoryName;

	/**
	 * IDの取得
	 * @return ID
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * IDのセット
	 * @param id ID
	 */
	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * キーワードの取得
	 * @return キーワード
	 */
	public String getKeyword() {
		return keyword;
	}

	/**
	 * キーワードのセット
	 * @param keyword キーワード
	 */
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	/**
	 * カテゴリ名の取得
	 * @return カテゴリ名
	 */
	public String getCategoryName() {
		return categoryName;
	}

	/**
	 * カテゴリ名のセット
	 * @param categoryName カテゴリ名
	 */
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
}
