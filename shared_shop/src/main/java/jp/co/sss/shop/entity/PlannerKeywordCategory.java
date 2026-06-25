package jp.co.sss.shop.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;

/**
 * 用途キーワードとカテゴリのマッピング用エンティティ
 */
@Entity
@Table(name = "planner_keyword_categories")
public class PlannerKeywordCategory {
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_planner_gen")
	@SequenceGenerator(name = "seq_planner_gen", sequenceName = "seq_planner_keyword_categories", allocationSize = 1)
	private Integer id;

	@Column
	private String keyword;

	@Column(name = "category_name")
	private String categoryName;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
}
