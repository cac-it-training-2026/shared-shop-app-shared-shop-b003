package jp.co.sss.shop.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.SaleSchedule;

/**
 * 商品関連のサービスクラス
 */
@Service
public class ItemService {

	@Autowired
	SaleService saleService;

	/**
	 * 商品のセール価格を計算する
	 *
	 * 処理フロー:
	 * 現在時刻取得 -> 開催中セール取得 -> カテゴリ一致判定 -> 価格再計算
	 *
	 * @param item 商品エンティティ
	 * @return セール価格（セール対象外の場合は通常価格）
	 */
	public Integer calculateSalePrice(Item item) {
		if (item == null || item.getCategory() == null) {
			return item != null ? item.getPrice() : null;
		}

		// 開催中のセール情報をカテゴリIDに基づいて取得（キャッシュ利用）
		SaleSchedule sale = saleService.getActiveSaleByCategoryCached(item.getCategory().getId());

		if (sale != null) {
			// 計算式: salePrice = price - (price × discountRate ÷ 100)
			return saleService.calculateDiscountedPrice(item.getPrice(), sale.getDiscountRate());
		}

		return item.getPrice();
	}
}
