package jp.co.sss.shop.form;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * スマート購入プランナーのフォームクラス
 */
public class PlannerForm {

	/**
	 * 利用目的
	 */
	@NotBlank
	@Size(max = 100)
	private String usage;

	/**
	 * 予算
	 */
	@NotNull
	private Integer budget;

	/**
	 * 利用目的の取得
	 * @return 利用目的
	 */
	public String getUsage() {
		return usage;
	}

	/**
	 * 利用目的のセット
	 * @param usage 利用目的
	 */
	public void setUsage(String usage) {
		this.usage = usage;
	}

	/**
	 * 予算の取得
	 * @return 予算
	 */
	public Integer getBudget() {
		return budget;
	}

	/**
	 * 予算のセット
	 * @param budget 予算
	 */
	public void setBudget(Integer budget) {
		this.budget = budget;
	}
}
