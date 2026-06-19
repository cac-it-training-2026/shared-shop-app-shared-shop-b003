package jp.co.sss.shop.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import jp.co.sss.shop.entity.Coupon;

/**
 * couponsテーブル用リポジトリ
 */
@Repository
public interface CouponRepository extends JpaRepository<Coupon, Integer> {
    /**
     * コードでクーポンを検索
     * @param code クーポンコード
     * @return クーポンエンティティ
     */
    Coupon findByCode(String code);
}
