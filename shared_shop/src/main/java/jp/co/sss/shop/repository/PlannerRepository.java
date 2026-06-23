package jp.co.sss.shop.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import jp.co.sss.shop.entity.Planner;

/**
 * plannersテーブル用リポジトリ
 */
@Repository
public interface PlannerRepository extends JpaRepository<Planner, Integer> {
}
