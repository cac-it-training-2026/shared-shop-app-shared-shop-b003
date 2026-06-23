package jp.co.sss.shop.config;

import java.time.LocalTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import jp.co.sss.shop.entity.SaleSchedule;
import jp.co.sss.shop.repository.CategoryRepository;
import jp.co.sss.shop.repository.SaleRepository;

/**
 * 初期データ投入用クラス
 */
@Component
public class DataInitializer implements CommandLineRunner {

	@Autowired
	SaleRepository saleRepository;

	@Autowired
	CategoryRepository categoryRepository;

	@Override
	public void run(String... args) throws Exception {
		if (saleRepository.count() > 0) {
			return;
		}

		// 食料品 (12:00〜14:00, 20%)
		createSale("食料品", "12:00:00", "14:00:00", 20);

		// 書籍 (20:00〜23:00, 15%)
		createSale("書籍", "20:00:00", "23:00:00", 15);

		// 雑貨 (18:00〜21:00, 10%)
		createSale("雑貨", "18:00:00", "21:00:00", 10);
	}

	private void createSale(String categoryName, String start, String end, Integer rate) {
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
