package jp.co.sss.shop.controller.client;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jp.co.sss.shop.service.PlannerService;

@Controller
public class ClientPlannerController {

	@Autowired
	PlannerService plannerService;

	/**
	 * プランナー入力画面表示
	 */
	@RequestMapping(path = "/client/planner/input", method = RequestMethod.GET)
	public String input() {
		return "client/planner_input";
	}

	/**
	 * プラン生成・結果表示
	 */
	@RequestMapping(path = "/client/planner/results", method = RequestMethod.POST)
	public String results(String purpose, Integer budget, Model model) {
		if (budget == null) budget = 0;

		Map<String, PlannerService.PlanResult> plans = plannerService.suggestPlannedSets(purpose, budget);

		model.addAttribute("plans", plans);
		model.addAttribute("purpose", purpose);
		model.addAttribute("budget", budget);

		return "client/planner_results";
	}
}
