package jp.co.sss.shop.controller.client.planner;

import java.util.List;
import java.util.Map;

import jakarta.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jp.co.sss.shop.form.PlannerForm;
import jp.co.sss.shop.service.PurchasePlannerService;

/**
 * スマート購入プランナーのコントローラクラス
 */
@Controller
public class ClientPlannerController {

	@Autowired
	PurchasePlannerService plannerService;

	/**
	 * 入力画面表示
	 * @param form フォーム
	 * @return 入力画面
	 */
	@RequestMapping(path = "/client/planner/input", method = RequestMethod.GET)
	public String input(@ModelAttribute("plannerForm") PlannerForm form) {
		return "client/planner/input";
	}

	/**
	 * プラン生成処理
	 * @param form    フォーム
	 * @param result  バリデーション結果
	 * @param model   Viewとの値受渡し
	 * @return 結果画面
	 */
	@RequestMapping(path = "/client/planner/plan", method = RequestMethod.POST)
	public String plan(@Valid @ModelAttribute("plannerForm") PlannerForm form, BindingResult result, Model model) {

		if (result.hasErrors()) {
			return "client/planner/input";
		}

		List<Map<String, Object>> plans = plannerService.plan(form.getUsage(), form.getBudget());

		model.addAttribute("plans", plans);
		model.addAttribute("usage", form.getUsage());
		model.addAttribute("budget", form.getBudget());

		return "client/planner/result";
	}
}
