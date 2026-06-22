package jp.co.sss.shop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import jp.co.sss.shop.entity.Coupon;

/**
 * クーポンリポジトリ
 */
@Repository
public interface CouponRepository extends JpaRepository<Coupon, Integer> {
	/**
	 * クーポンコードで検索
	 * @param code クーポンコード
	 * @return クーポンエンティティ
	 */
	Coupon findByCode(String code);

	/**
	 * 有効なクーポンをすべて取得（有効期間内かつ使用上限に達していないもの）
	 * @return クーポンのリスト
	 */
	@Query("SELECT c FROM Coupon c WHERE (c.validFrom IS NULL OR c.validFrom <= CURRENT_TIMESTAMP) AND (c.validUntil IS NULL OR c.validUntil >= CURRENT_TIMESTAMP) AND (c.usageLimit IS NULL OR c.usageLimit > 0)")
	List<Coupon> findValidCoupons();

	/**
	 * 特定のユーザーの有効なクーポンを取得
	 * @param userId ユーザーID
	 * @return クーポンのリスト
	 */
	@Query("SELECT c FROM Coupon c WHERE c.userId = :userId AND (c.validFrom IS NULL OR c.validFrom <= CURRENT_TIMESTAMP) AND (c.validUntil IS NULL OR c.validUntil >= CURRENT_TIMESTAMP) AND (c.usageLimit IS NULL OR c.usageLimit > 0) ORDER BY c.insertDate DESC")
	List<Coupon> findValidCouponsByUserId(@Param("userId") Integer userId);
}
