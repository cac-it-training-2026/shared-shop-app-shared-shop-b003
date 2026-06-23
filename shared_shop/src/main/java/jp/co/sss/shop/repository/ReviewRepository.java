package jp.co.sss.shop.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import jp.co.sss.shop.entity.Review;

/**
 * reviewsテーブル用リポジトリ
 */
@Repository
public interface ReviewRepository extends JpaRepository<Review, Integer> {

	/**
	 * 商品IDと公開フラグを条件に検索(新着順)
	 * @param itemId 商品ID
	 * @param approved 公開フラグ
	 * @return レビューエンティティのリスト
	 */
	List<Review> findByItemIdAndApprovedOrderByInsertDateDesc(Integer itemId, Integer approved);

	/**
	 * すべてのレビューを新着順で取得 (管理者用)
	 * @param pageable ページング情報
	 * @return レビューエンティティのページオブジェクト
	 */
	Page<Review> findAllByOrderByInsertDateDesc(Pageable pageable);
}
