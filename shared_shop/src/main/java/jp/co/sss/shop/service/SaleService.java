package jp.co.sss.shop.service;

import java.time.Duration;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.entity.SaleSchedule;
import jp.co.sss.shop.repository.SaleScheduleRepository;
import jp.co.sss.shop.util.Constant;

/**
 * タイムセールに関するサービスクラス
 */
@Service
public class SaleService {

	@Autowired
	private SaleScheduleRepository saleScheduleRepository;

	private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm:ss");

	/**
	 * 現在開催中のセール情報を取得（カテゴリIDをキーとしたマップ）
	 * @return 開催中のセール情報
	 */
	public Map<Integer, SaleSchedule> getActiveSales() {
		try {
			LocalTime now = LocalTime.now();
			System.out.println("DEBUG: Current Time=" + now);

			List<SaleSchedule> allSales = saleScheduleRepository.findByDeleteFlag(Constant.NOT_DELETED);

			Map<Integer, SaleSchedule> activeSales = allSales.stream()
					.filter(s -> isSaleActive(s, now))
					.collect(Collectors.toMap(s -> s.getCategory().getId(), s -> s, (s1, s2) -> s1));

			System.out.println("SALE COUNT=" + activeSales.size());

			return activeSales;
		} catch (Exception e) {
			System.err.println("ERROR: Failed to get active sales");
			e.printStackTrace();
			return new HashMap<>();
		}
	}

	private boolean isSaleActive(SaleSchedule sale, LocalTime now) {
		try {
			if (sale.getStartTime() == null || sale.getEndTime() == null)
				return false;

			LocalTime start = sale.getStartTime();
			LocalTime end = sale.getEndTime();

			boolean active;
			if (start.isBefore(end)) {
				active = !now.isBefore(start) && !now.isAfter(end);
			} else {
				// 日をまたぐセールの考慮
				active = !now.isBefore(start) || !now.isAfter(end);
			}
			return active;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 残り時間を計算する（「HH時間mm分」形式）
	 * @param sale セール情報
	 * @return 残り時間の文字列
	 */
	public String getRemainingTime(SaleSchedule sale) {
		try {
			LocalTime now = LocalTime.now();
			if (!isSaleActive(sale, now)) {
				return "終了";
			}

			LocalTime end = sale.getEndTime();

			Duration duration;
			if (now.isBefore(end)) {
				duration = Duration.between(now, end);
			} else {
				duration = Duration.between(now, LocalTime.MAX).plus(Duration.between(LocalTime.MIN, end));
			}

			long hours = duration.toHours();
			long minutes = duration.toMinutesPart();

			if (hours > 0) {
				return hours + "時間" + minutes + "分";
			} else {
				return minutes + "分";
			}
		} catch (Exception e) {
			return "-";
		}
	}

	/**
	 * 商品Beanにセール情報を適用する
	 * @param itemBean 商品Bean
	 * @param activeSales 開催中のセール情報
	 */
	public void applyDiscount(ItemBean itemBean, Map<Integer, SaleSchedule> activeSales) {
		if (activeSales == null)
			return;

		SaleSchedule sale = activeSales.get(itemBean.getCategoryId());
		if (sale != null) {
			int originalPrice = itemBean.getPrice();
			int discountRate = sale.getDiscountRate();
			int salePrice = (int) (originalPrice * (100 - discountRate) / 100.0);

			itemBean.setSalePrice(salePrice);
			itemBean.setDiscountRate(discountRate);

			System.out.println("ITEM=" + (itemBean.getName() != null ? itemBean.getName() : "Unknown"));
			System.out.println("PRICE=" + originalPrice);
			System.out.println("SALE=" + salePrice);
		} else {
			itemBean.setSalePrice(itemBean.getPrice());
			itemBean.setDiscountRate(0);
		}
	}

	/**
	 * 商品Beanのリストにセール情報を適用する
	 * @param itemBeanList 商品Beanリスト
	 * @param activeSales 開催中のセール情報
	 */
	public void applyDiscounts(List<ItemBean> itemBeanList, Map<Integer, SaleSchedule> activeSales) {
		if (itemBeanList == null)
			return;
		for (ItemBean itemBean : itemBeanList) {
			applyDiscount(itemBean, activeSales);
		}
	}
}
