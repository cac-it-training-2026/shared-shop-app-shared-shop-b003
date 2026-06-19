package jp.co.sss.shop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import jp.co.sss.shop.entity.OrderItem;

/**
 * order_itemsテーブル用リポジトリ
 *
 * @author System Shared
 */
public interface OrderItemRepository extends JpaRepository<OrderItem, Integer> {

	List<OrderItem> findByOrderId(Integer orderId);

	/**
	 * 指定したユーザーが特定の商品を購入したことがあるか確認
	 */
	@Query("SELECT COUNT(oi) > 0 FROM OrderItem oi WHERE oi.order.user.id = :userId AND oi.item.id = :itemId")
	boolean existsByUserIdAndItemId(@Param("userId") Integer userId, @Param("itemId") Integer itemId);

}
