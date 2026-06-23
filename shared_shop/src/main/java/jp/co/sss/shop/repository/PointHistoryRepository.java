package jp.co.sss.shop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import jp.co.sss.shop.entity.PointHistory;
import jp.co.sss.shop.entity.User;

/**
 * ポイント履歴情報リポジトリ
 *
 */
@Repository
public interface PointHistoryRepository extends JpaRepository<PointHistory, Integer> {

	/**
	 * ユーザーIDで降順にポイント履歴を取得
	 * @param user 会員情報
	 * @return ポイント履歴リスト
	 */
	List<PointHistory> findByUserOrderByCreatedTimeDescIdDesc(User user);
}
