package jp.co.sss.shop.service;

import java.sql.Timestamp;
import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jp.co.sss.shop.entity.Coupon;
import jp.co.sss.shop.entity.GachaLog;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.repository.CouponRepository;
import jp.co.sss.shop.repository.GachaLogRepository;
import jp.co.sss.shop.repository.UserRepository;

@Service
public class GachaService {

    @Autowired
    private CouponRepository couponRepository;

    @Autowired
    private GachaLogRepository gachaLogRepository;

    @Autowired
    private UserRepository userRepository;

    private final Random random = new Random();

    @Transactional
    public GachaResult playGacha(Integer userId, String ipAddress) {
        User user = userRepository.getReferenceById(userId);
        if (user.getGachaCount() == null || user.getGachaCount() <= 0) {
            throw new RuntimeException("ガチャチケットがありません。");
        }

        // レート制限の簡易チェック（同一ユーザーによる直近10秒以内の連続実行を防止）
        // ※実際はGachaLogテーブルをクエリして判定することも可能ですが、
        // ここでは不正操作防止の観点からチケットの存在チェックを優先します。

        // チケットを消費
        user.setGachaCount(user.getGachaCount() - 1);
        userRepository.save(user);

        GachaLog log = new GachaLog();
        log.setUserId(userId);
        log.setEventType("GACHA_PLAY");
        log.setIpAddress(ipAddress);

        // ガチャロジック (例: 15%の確率でクーポンが当たる)
        int chance = random.nextInt(100);
        if (chance < 15) {
            List<Coupon> availableCoupons = couponRepository.findAll();
            if (!availableCoupons.isEmpty()) {
                Coupon wonCoupon = availableCoupons.get(random.nextInt(availableCoupons.size()));
                log.setOutcome("WIN");
                log.setCouponId(wonCoupon.getId());
                gachaLogRepository.save(log);
                return new GachaResult(true, wonCoupon);
            }
        }

        log.setOutcome("LOSE");
        gachaLogRepository.save(log);
        return new GachaResult(false, null);
    }

    public static class GachaResult {
        private final boolean win;
        private final Coupon coupon;

        public GachaResult(boolean win, Coupon coupon) {
            this.win = win;
            this.coupon = coupon;
        }

        public boolean isWin() { return win; }
        public Coupon getCoupon() { return coupon; }
    }
}
