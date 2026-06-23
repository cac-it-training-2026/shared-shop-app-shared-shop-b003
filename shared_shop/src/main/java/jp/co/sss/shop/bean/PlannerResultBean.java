package jp.co.sss.shop.bean;

import java.util.List;

/**
 * スマート購入プランナーの結果表示用Bean
 */
public class PlannerResultBean {
	/**
	 * 提案された商品リスト
	 */
	private List<ItemBean> itemList;

	/**
	 * 合計金額
	 */
	private Integer totalAmount;

	/**
	 * 選択された用途の名前
	 */
	private String purposeName;

	/**
	 * 指定された予算
	 */
	private Integer budget;

	public List<ItemBean> getItemList() {
		return itemList;
	}

	public void setItemList(List<ItemBean> itemList) {
		this.itemList = itemList;
	}

	public Integer getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(Integer totalAmount) {
		this.totalAmount = totalAmount;
	}

	public String getPurposeName() {
		return purposeName;
	}

	public void setPurposeName(String purposeName) {
		this.purposeName = purposeName;
	}

	public Integer getBudget() {
		return budget;
	}

	public void setBudget(Integer budget) {
		this.budget = budget;
	}
}
