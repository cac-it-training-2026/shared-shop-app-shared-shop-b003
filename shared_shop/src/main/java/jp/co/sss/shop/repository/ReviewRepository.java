package jp.co.sss.shop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import jp.co.sss.shop.entity.Review;

/**
 * reviewsテーブル用リポジトリ
 */
@Repository
public interface ReviewRepository extends JpaRepository<Review, Integer> {
	/**
	 * 商品IDに紐づくレビューを登録日の降順で取得
	 * @param itemId 商品ID
	 * @return レビューのリスト
	 */
	List<Review> findByItemIdOrderByInsertDateDesc(Integer itemId);
}
