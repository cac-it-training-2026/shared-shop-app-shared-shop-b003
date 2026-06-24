package jp.co.sss.shop.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import jp.co.sss.shop.entity.Coupon;

/**
 * クーポンリポジトリ
 *
 * @author Jules
 */
@Repository
public interface CouponRepository extends JpaRepository<Coupon, Integer> {
	/**
	 * クーポンコードで検索
	 * @param code クーポンコード
	 * @return クーポン情報
	 */
	Coupon findByCode(String code);
}
