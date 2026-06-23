package jp.co.sss.shop.repository;

import java.time.LocalTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import jp.co.sss.shop.entity.SaleSchedule;

/**
 * sale_scheduleテーブル用リポジトリ
 */
@Repository
public interface SaleRepository extends JpaRepository<SaleSchedule, Integer> {

	/**
	 * 現在時刻に該当する有効なセール情報を取得
	 */
	@Query("SELECT s FROM SaleSchedule s WHERE s.enabled = 1 AND s.startTime <= :currentTime AND s.endTime > :currentTime")
	List<SaleSchedule> findActiveSales(@Param("currentTime") LocalTime currentTime);

	/**
	 * 現在時刻に該当する有効なカテゴリ別セール情報を取得
	 */
	@Query("SELECT s FROM SaleSchedule s WHERE s.category.id = :categoryId AND s.enabled = 1 AND s.startTime <= :currentTime AND s.endTime > :currentTime")
	List<SaleSchedule> findActiveSaleByCategory(@Param("categoryId") Integer categoryId, @Param("currentTime") LocalTime currentTime);
}
