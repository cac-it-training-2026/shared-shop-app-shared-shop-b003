package jp.co.sss.shop.form;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

/**
 * スマート購入プランナー用フォーム
 */
public class PlannerForm {
	/**
	 * 用途 (1:パーティー, 2:自分へのご褒美, 3:日常)
	 */
	@NotNull
	private Integer purpose;

	/**
	 * 予算
	 */
	@NotNull
	@Min(100)
	private Integer budget;

	public Integer getPurpose() {
		return purpose;
	}

	public void setPurpose(Integer purpose) {
		this.purpose = purpose;
	}

	public Integer getBudget() {
		return budget;
	}

	public void setBudget(Integer budget) {
		this.budget = budget;
	}
}
