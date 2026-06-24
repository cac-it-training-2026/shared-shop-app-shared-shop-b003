package jp.co.sss.shop.repository;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import jp.co.sss.shop.entity.GachaLog;

/**
 * ガチャログリポジトリ
 *
 * @author Jules
 */
@Repository
public interface GachaLogRepository extends JpaRepository<GachaLog, Integer> {
	/**
	 * 指定期間内のユーザーのガチャ実行履歴を取得
	 * @param userId ユーザーID
	 * @param start 開始日時
	 * @return ガチャログのリスト
	 */
	List<GachaLog> findByUserIdAndCreatedAtAfter(Integer userId, Timestamp start);
}
