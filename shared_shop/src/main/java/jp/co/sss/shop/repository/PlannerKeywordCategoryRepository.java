package jp.co.sss.shop.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import jp.co.sss.shop.entity.PlannerKeywordCategory;

@Repository
public interface PlannerKeywordCategoryRepository extends JpaRepository<PlannerKeywordCategory, Integer> {
	List<PlannerKeywordCategory> findByKeyword(String keyword);
}
