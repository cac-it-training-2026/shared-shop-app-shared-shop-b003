package jp.co.sss.shop.controller.advice;

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
			model.addAttribute("activeSales", sales);
		} catch (Exception e) {
			// エラー時は何もしない
		}
	}
}
