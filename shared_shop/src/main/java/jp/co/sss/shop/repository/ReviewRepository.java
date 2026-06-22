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
	 * 商品IDと削除フラグを条件に検索(新着順)
	 * @param itemId 商品ID
	 * @param deleteFlag 削除フラグ
	 * @return レビューエンティティのリスト
	 */
	List<Review> findByItemIdAndDeleteFlagOrderByInsertDateDesc(Integer itemId, Integer deleteFlag);

	/**
	 * 削除フラグを条件に検索(新着順)
	 * @param deleteFlag 削除フラグ
	 * @param pageable ページング情報
	 * @return レビューエンティティのページオブジェクト
	 */
	Page<Review> findByDeleteFlagOrderByInsertDateDesc(Integer deleteFlag, Pageable pageable);

	/**
	 * レビューIDと削除フラグを条件に検索
	 * @param id レビューID
	 * @param deleteFlag 削除フラグ
	 * @return レビューエンティティ
	 */
	Review findByIdAndDeleteFlag(Integer id, Integer deleteFlag);
}
