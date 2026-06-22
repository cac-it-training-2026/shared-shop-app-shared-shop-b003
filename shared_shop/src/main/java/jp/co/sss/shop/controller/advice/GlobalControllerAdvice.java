package jp.co.sss.shop.controller.advice;

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
			List<SaleSchedule> sales = saleService.getActiveSales();
			model.addAttribute("activeSales", sales != null ? sales : Collections.emptyList());

			if (sales != null && !sales.isEmpty()) {
				model.addAttribute("saleRemainingTime", saleService.getRemainingTime(sales.get(0).getEndTime()));
			}
		} catch (Exception e) {
			// 例外が発生した場合は空のデータをセットし、アプリの動作を継続させる
			model.addAttribute("activeSales", Collections.emptyList());
		}
	}
}
