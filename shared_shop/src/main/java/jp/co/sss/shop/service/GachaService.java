package jp.co.sss.shop.service;

import java.sql.Timestamp;
import java.util.List;
import java.util.Random;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jp.co.sss.shop.entity.Coupon;
import jp.co.sss.shop.entity.GachaLog;
import jp.co.sss.shop.repository.CouponRepository;
import jp.co.sss.shop.repository.GachaLogRepository;

/**
 * ガチャサービス
 *
 * @author Jules
 */
@Service
public class GachaService {

	@Autowired
	private CouponRepository couponRepository;

	@Autowired
	private GachaLogRepository gachaLogRepository;

	private final Random random = new Random();

	/**
	 * ガチャを実行する
	 *
	 * @param userId ユーザーID
	 * @param eventType イベントタイプ ("login", "order")
	 * @param sourceOrderId 注文ID (orderイベントの場合のみ)
	 * @param ipAddress IPアドレス
	 * @return 当選したクーポン (外れの場合はnull)
	 */
	@Transactional
	public Coupon playGacha(Integer userId, String eventType, Integer sourceOrderId, String ipAddress) {
		// レート制限チェック (例: 過去1分間に5回以上実行している場合は制限)
		Timestamp oneMinuteAgo = new Timestamp(System.currentTimeMillis() - 60000);
		List<GachaLog> recentLogs = gachaLogRepository.findByUserIdAndCreatedAtAfter(userId, oneMinuteAgo);
		if (recentLogs.size() >= 5) {
			return null;
		}

		// 抽選ロジック (50%の確率で当選)
		int roll = random.nextInt(100);
		Coupon wonCoupon = null;
		String outcome = "lose";

		if (roll < 50) { // 50% 当選
			outcome = "win";
			wonCoupon = createCouponForUser(userId);
		}

		// ログ記録
		GachaLog log = new GachaLog();
		log.setUserId(userId);
		log.setEventType(eventType);
		log.setOutcome(outcome);
		if (wonCoupon != null) {
			log.setCouponId(wonCoupon.getId());
		}
		log.setSourceOrderId(sourceOrderId);
		log.setIpAddress(ipAddress);
		gachaLogRepository.save(log);

		return wonCoupon;
	}

	/**
	 * ユーザー用のクーポンを作成する
	 *
	 * @param userId ユーザーID
	 * @return 作成されたクーポン
	 */
	private Coupon createCouponForUser(Integer userId) {
		Coupon coupon = new Coupon();
		// ランダムなクーポンコードを生成
		coupon.setCode("GACHA-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());

		// 景品プールのランダム選択 (500円引き or 10%OFF)
		if (random.nextBoolean()) {
			coupon.setDiscountType("amount");
			coupon.setDiscountValue(500);
		} else {
			coupon.setDiscountType("percent");
			coupon.setDiscountValue(10);
		}

		// 有効期限を30日後に設定
		coupon.setValidFrom(new Timestamp(System.currentTimeMillis()));
		coupon.setValidUntil(new Timestamp(System.currentTimeMillis() + 30L * 24 * 60 * 60 * 1000));
		coupon.setUsageLimit(1);
		coupon.setUserId(userId);

		return couponRepository.save(coupon);
	}
}
