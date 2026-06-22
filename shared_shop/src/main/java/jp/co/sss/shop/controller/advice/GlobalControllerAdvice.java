package jp.co.sss.shop.controller.advice;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import jp.co.sss.shop.entity.SaleSchedule;
import jp.co.sss.shop.service.SaleService;

/**
 * 全てのコントローラで共通のデータをModelに追加するクラス
 */
@ControllerAdvice
public class GlobalControllerAdvice {

	@Autowired
	SaleService saleService;

	/**
	 * 開催中のタイムセール情報を全てのビューで利用可能にする
	 */
	@ModelAttribute
	public void addAttributes(Model model) {
		try {
			// 現在時刻に基づいたセール情報を取得
			List<SaleSchedule> sales = saleService.getActiveSales();

			if (sales != null && !sales.isEmpty()) {
				// 各セールに対して個別に残り時間を計算・セット
				for (SaleSchedule sale : sales) {
					sale.setRemainingTime(saleService.getRemainingTime(sale.getEndTime()));
				}
				model.addAttribute("activeSales", sales);
			} else {
				model.addAttribute("activeSales", new ArrayList<SaleSchedule>());
			}
		} catch (Exception e) {
			// 例外が発生した場合は空のデータをセットし、アプリの動作を継続させる
			model.addAttribute("activeSales", new ArrayList<SaleSchedule>());
		}
	}
}
