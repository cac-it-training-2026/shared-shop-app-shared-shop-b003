package jp.co.sss.shop.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jp.co.sss.shop.bean.OrderItemBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.OrderItem;
import jp.co.sss.shop.entity.SaleSchedule;

/**
 * 料金計算用クラス
 *
 * @author System Shared
 */
@Service
public class PriceCalc {

	@Autowired
	SaleService saleService;

	/**
	 * 商品の現在価格（セールを考慮）を取得
	 * @param item 商品情報
	 * @return 現在の価格
	 */
	public int getItemPrice(Item item) {
		if (item.getCategory() == null || item.getCategory().getId() == null) {
			return item.getPrice();
		}
		SaleSchedule sale = saleService.getActiveSaleByCategory(item.getCategory().getId());
		if (sale != null) {
			return saleService.calculateSalePrice(item.getPrice(), sale.getDiscountRate());
		}
		return item.getPrice();
	}

	/**
	 * 小計から注文した商品の合計金額を計算
	 *
	 * @param list
	 *            注文した商品情報
	 * @return 合計金額
	 */
	public int orderItemBeanPriceTotalUseSubtotal(List<OrderItemBean> list) {
		int total = 0;

		for (OrderItemBean bean : list) {
			total = total + bean.getSubtotal();
		}

		return total;
	}

	/**
	 * 単価と注文した商品の合計金額を計算
	 *
	 * @param list
	 *            注文した商品情報
	 * @return 合計金額
	 */
	public int orderItemBeanPriceTotal(List<OrderItemBean> list) {
		int total = 0;

		for (OrderItemBean orderItemBean : list) {
			total = total + (orderItemBean.getPrice() * orderItemBean.getOrderNum());
		}

		return total;
	}

	/**
	 * 注文時の単価と商品個数の合計金額を計算
	 *
	 * @param list
	 *            注文した商品情報
	 * @return 合計金額
	 */
	public int orderItemPriceTotal(List<OrderItem> list) {
		int total = 0;

		for (OrderItem orderItem : list) {
			total = total + (orderItem.getPrice() * orderItem.getQuantity() );
		}

		return total;
	}
}
