package jp.co.sss.shop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import jp.co.sss.shop.entity.PlannerKeywordCategory;

/**
 * planner_keyword_categoriesテーブル用リポジトリ
 */
@Repository
public interface PlannerKeywordCategoryRepository extends JpaRepository<PlannerKeywordCategory, Integer> {

	/**
	 * 登録されているユニークなキーワードの一覧を取得する
	 * @return キーワードのリスト
	 */
	@Query("SELECT DISTINCT p.keyword FROM PlannerKeywordCategory p ORDER BY p.keyword")
	List<String> findAllCustomKeywords();

	/**
	 * 指定されたキーワードに紐づくカテゴリ名のリストを取得する
	 * @param keyword キーワード
	 * @return カテゴリ名のリスト
	 */
	List<PlannerKeywordCategory> findByKeyword(String keyword);
}
