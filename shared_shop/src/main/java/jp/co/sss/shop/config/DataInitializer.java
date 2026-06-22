package jp.co.sss.shop.config;

import java.time.LocalTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import jp.co.sss.shop.entity.Category;
import jp.co.sss.shop.entity.SaleSchedule;
import jp.co.sss.shop.repository.CategoryRepository;
import jp.co.sss.shop.repository.SaleRepository;

/**
 * アプリケーション起動時に初期データを投入するクラス
 */
@Component
public class DataInitializer implements CommandLineRunner {

	@Autowired
	SaleRepository saleRepository;

	@Autowired
	CategoryRepository categoryRepository;

	@Override
	public void run(String... args) throws Exception {
		// すでにデータがある場合は削除して再投入（デバッグ・確実性のため）
		saleRepository.deleteAll();

		// セール条件（初期値）の投入

		// 1. 食料品 12:00〜14:00 20%
		createSaleByCategoryName("食料品", "12:00:00", "14:00:00", 20);

		// 2. 書籍 20:00〜23:00 15%
		createSaleByCategoryName("書籍", "20:00:00", "23:00:00", 15);

		// 3. 雑貨 18:00〜21:00 10%
		createSaleByCategoryName("雑貨", "18:00:00", "21:00:00", 10);

		// 検証用：24時間セール（全カテゴリを対象としたデバッグ用）
		// 必要に応じてコメントアウト
		// createSaleByCategoryName("食料品", "00:00:00", "23:59:59", 50);
	}

	private void createSaleByCategoryName(String categoryName, String start, String end, Integer rate) {
		// カテゴリ名で検索（JPASpecificationや独自メソッドがない場合はfindAllから探す）
		categoryRepository.findAll().stream()
			.filter(c -> categoryName.equals(c.getName()))
			.findFirst()
			.ifPresent(category -> {
				SaleSchedule sale = new SaleSchedule();
				sale.setCategory(category);
				sale.setStartTime(LocalTime.parse(start));
				sale.setEndTime(LocalTime.parse(end));
				sale.setDiscountRate(rate);
				sale.setEnabled(1);
				saleRepository.save(sale);
			});
	}
}
