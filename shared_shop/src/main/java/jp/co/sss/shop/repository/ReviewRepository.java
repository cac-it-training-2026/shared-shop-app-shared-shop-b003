package jp.co.sss.shop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import jp.co.sss.shop.entity.Review;

/**
 * reviewsテーブル用リポジトリ
 */
public interface ReviewRepository extends JpaRepository<Review, Integer> {

	/**
	 * 商品IDから該当商品のレビューを投稿日時の降順で取得する
	 * @param productId 商品ID
	 * @return レビュー一覧
	 */
	@Query("SELECT r FROM Review r WHERE r.item.id = :productId ORDER BY r.createdTime DESC")
	List<Review> findByProductIdOrderByCreatedTimeDesc(@Param("productId") Integer productId);

}
