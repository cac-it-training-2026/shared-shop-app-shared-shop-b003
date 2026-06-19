package jp.co.sss.shop.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import jp.co.sss.shop.entity.GachaLog;

/**
 * gacha_logsテーブル用リポジトリ
 */
public interface GachaLogRepository extends JpaRepository<GachaLog, Integer> {
}
