package jp.co.sss.shop.service;

import java.time.Duration;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
	 * 日本時間（JST）の現在時刻を取得する
	 */
	public LocalTime getCurrentTimeJst() {
		return LocalTime.now(ZoneId.of("Asia/Tokyo"));
	}

	/**
	 * カテゴリIDをキーとした現在開催中のセール情報のマップをキャッシュする
	 */
	private Map<Integer, SaleSchedule> activeSaleMapCache;
	private LocalTime cacheTime;

	/**
	 * キャッシュを更新または取得する
	 */
	private Map<Integer, SaleSchedule> getActiveSaleMap() {
		try {
			LocalTime now = getCurrentTimeJst();
			// 1分ごとにキャッシュを更新
			if (activeSaleMapCache == null || cacheTime == null || Duration.between(cacheTime, now).toMinutes() >= 1) {
				List<SaleSchedule> sales = saleRepository.findActiveSales(now);
				if (sales == null) {
					activeSaleMapCache = Collections.emptyMap();
				} else {
					activeSaleMapCache = sales.stream()
							.filter(s -> s.getCategory() != null && s.getCategory().getId() != null)
							.collect(Collectors.toMap(
									s -> s.getCategory().getId(),
									s -> s,
									(s1, s2) -> s1
							));
				}
				cacheTime = now;
			}
			return activeSaleMapCache;
		} catch (Exception e) {
			return Collections.emptyMap();
		}
	}

	/**
	 * 現在開催中の全てのセール情報を取得
	 */
	public List<SaleSchedule> getActiveSales() {
		try {
			return saleRepository.findActiveSales(getCurrentTimeJst());
		} catch (Exception e) {
			return Collections.emptyList();
		}
	}

	/**
	 * 特定のカテゴリが現在セール中か確認
	 */
	public SaleSchedule getActiveSaleByCategory(Integer categoryId) {
		if (categoryId == null) {
			return null;
		}
		try {
			List<SaleSchedule> sales = saleRepository.findActiveSaleByCategory(categoryId, getCurrentTimeJst());
			return (sales == null || sales.isEmpty()) ? null : sales.get(0);
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * キャッシュを使用して特定のカテゴリがセール中か確認
	 */
	public SaleSchedule getActiveSaleByCategoryCached(Integer categoryId) {
		if (categoryId == null) {
			return null;
		}
		return getActiveSaleMap().get(categoryId);
	}

	/**
	 * セール価格を計算する
	 */
	public Integer calculateSalePrice(Integer originalPrice, Integer discountRate) {
		if (originalPrice == null || discountRate == null) {
			return originalPrice;
		}
		double discount = originalPrice * (discountRate / 100.0);
		return (int) Math.round(originalPrice - discount);
	}

	/**
	 * 残り時間を計算し、フォーマットされた文字列を返す (HH:mm:ss)
	 */
	public String getRemainingTime(LocalTime endTime) {
		if (endTime == null) {
			return "00:00:00";
		}
		LocalTime now = getCurrentTimeJst();
		if (now.isAfter(endTime)) {
			return "00:00:00";
		}
		Duration duration = Duration.between(now, endTime);
		long seconds = duration.getSeconds();
		long h = seconds / 3600;
		long m = (seconds % 3600) / 60;
		long s = seconds % 60;
		return String.format("%02d:%02d:%02d", h, m, s);
	}
}
