package jp.co.sss.shop.service;

import java.time.LocalTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jp.co.sss.shop.entity.SaleSchedule;
import jp.co.sss.shop.repository.SaleRepository;

/**
 * タイムセール用サービスクラス
 */
@Service
public class SaleService {

	@Autowired
	SaleRepository saleRepository;

	/**
	 * 現在開催中の全てのセール情報を取得
	 * @return セール情報リスト
	 */
	public List<SaleSchedule> getActiveSales() {
		return saleRepository.findActiveSales(LocalTime.now());
	}

	/**
	 * 特定のカテゴリが現在セール中か確認し、セール情報を取得
	 * @param categoryId カテゴリID
	 * @return セール情報（セール中でない場合はnull）
	 */
	public SaleSchedule getActiveSaleByCategory(Integer categoryId) {
		if (categoryId == null) {
			return null;
		}
		return saleRepository.findActiveSaleByCategory(categoryId, LocalTime.now());
	}

	/**
	 * セール価格を計算する
	 * @param originalPrice 元の価格
	 * @param discountRate 割引率（％）
	 * @return セール価格
	 */
	public Integer calculateSalePrice(Integer originalPrice, Integer discountRate) {
		if (originalPrice == null || discountRate == null) {
			return originalPrice;
		}
		double discount = originalPrice * (discountRate / 100.0);
		return (int) Math.round(originalPrice - discount);
	}
}
