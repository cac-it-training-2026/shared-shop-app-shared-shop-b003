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
		// すでにデータがある場合はスキップ
		if (saleRepository.count() > 0) {
			return;
		}

		// セール条件（初期値）の投入

		// 1. 食料品 (categoryId=1を想定) 12:00〜14:00 20%
		createSaleIfCategoryExists(1, "12:00:00", "14:00:00", 20);

		// 2. 書籍 (categoryId=2を想定) 20:00〜23:00 15%
		createSaleIfCategoryExists(2, "20:00:00", "23:00:00", 15);

		// 3. 雑貨 (categoryId=3を想定) 18:00〜21:00 10%
		createSaleIfCategoryExists(3, "18:00:00", "21:00:00", 10);
	}

	private void createSaleIfCategoryExists(Integer categoryId, String start, String end, Integer rate) {
		categoryRepository.findById(categoryId).ifPresent(category -> {
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
