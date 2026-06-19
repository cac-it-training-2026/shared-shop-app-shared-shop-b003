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
     * 商品IDに紐づく承認済みレビューを新着順で取得
     */
    List<Review> findByProductIdAndApprovedOrderByCreatedAtDesc(Integer productId, Integer approved);
}
