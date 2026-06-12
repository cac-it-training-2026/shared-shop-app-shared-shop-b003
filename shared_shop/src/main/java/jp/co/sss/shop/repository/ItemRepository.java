package jp.co.sss.shop.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import jp.co.sss.shop.entity.Item;

/**
 * itemsテーブル用リポジトリ
 *
 * @author System Shared
 */
@Repository
public interface ItemRepository extends JpaRepository<Item, Integer> {

	/**
	 * 商品一覧を新着順で取得
	 */
	/**
	 * @author Emi shioda
	 * @param deleteFlag 削除フラグ
	 */
	List<Item> findByDeleteFlagOrderByInsertDateDesc(
			Integer deleteFlag);

	/**
	* カテゴリ別新着順
	*/
	List<Item> findByCategoryIdAndDeleteFlagOrderByInsertDateDesc(
			Integer categoryId, Integer deleteFlag);

	/**
	 * 売れ筋順
	 * 注文商品テーブル（OrderItem）から
	 * ・商品ごとに集計
	 * ・quantity毎に集計
	 * ・多い順
	 * に並べる
	 */
	@Query("""
			SELECT oi.item
			FROM OrderItem oi
			WHERE oi.item.deleteFlag = 0
			GROUP BY oi.item
			ORDER BY SUM(oi.quantity) DESC
			""")
	List<Item> findPopularItems();

	/**
	 * カテゴリ別売れ筋順
	 */
	@Query("""
			SELECT oi.item
			FROM OrderItem oi
			WHERE oi.item.category.id = :categoryId
			AND oi.item.deleteFlag = 0
			GROUP BY oi.item
			ORDER BY SUM(oi.quantity) DESC
			""")
	List<Item> findPopularItemsByCategoryId(
			@Param("categoryId") Integer categoryId);

	/**
	 * 商品情報を登録日付順に取得 管理者機能で利用
	 * @param deleteFlag 削除フラグ
	 * @param pageable ページング情報
	 * @return 商品エンティティのページオブジェクト
	 */
	@Query("SELECT i FROM Item i INNER JOIN i.category c WHERE i.deleteFlag =:deleteFlag ORDER BY i.insertDate DESC,i.id DESC")
	Page<Item> findByDeleteFlagOrderByInsertDateDescPage(
			@Param(value = "deleteFlag") int deleteFlag, Pageable pageable);

	/**
	 * 商品IDと削除フラグを条件に検索（管理者,商品詳細機能で利用）
	 * @param id 商品ID
	 * @param deleteFlag 削除フラグ
	 * @return 商品エンティティ
	 */
	public Item findByIdAndDeleteFlag(Integer id, int deleteFlag);

	/**
	 * 商品名と削除フラグを条件に検索 (ItemValidatorで利用)
	 * @param name 商品名
	 * @param notDeleted 削除フラグ
	 * @return 商品エンティティ
	 */
	public Item findByNameAndDeleteFlag(String name, int notDeleted);
}
