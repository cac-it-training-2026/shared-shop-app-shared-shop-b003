package jp.co.sss.shop.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import jp.co.sss.shop.entity.Coupon;

/**
 * couponsテーブル用リポジトリ
 */
public interface CouponRepository extends JpaRepository<Coupon, Integer> {

	/**
	 * クーポンコードからクーポン情報を検索する
	 * @param code クーポンコード
	 * @return クーポン情報 (見つからない場合はnull)
	 */
	Coupon findByCode(String code);
}
