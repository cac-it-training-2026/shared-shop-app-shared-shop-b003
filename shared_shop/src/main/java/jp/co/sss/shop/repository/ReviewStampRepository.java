package jp.co.sss.shop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import jp.co.sss.shop.entity.ReviewStamp;

/**
 * review_stampsテーブル用リポジトリ
 */
@Repository
public interface ReviewStampRepository extends JpaRepository<ReviewStamp, Integer> {

	/**
	 * 有効なスタンプをすべて取得
	 * @param active 有効フラグ
	 * @return スタンプエンティティのリスト
	 */
	List<ReviewStamp> findByActive(Integer active);
}
