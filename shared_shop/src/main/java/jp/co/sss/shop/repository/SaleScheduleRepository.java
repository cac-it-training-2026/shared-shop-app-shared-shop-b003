package jp.co.sss.shop.repository;

import jp.co.sss.shop.entity.SaleSchedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * sale_scheduleテーブル用リポジトリ
 */
@Repository
public interface SaleScheduleRepository extends JpaRepository<SaleSchedule, Integer> {
    /**
     * 有効なセールスケジュールをすべて取得
     * @param deleteFlag 削除フラグ
     * @return セールスケジュールのリスト
     */
    List<SaleSchedule> findByDeleteFlag(Integer deleteFlag);
}
