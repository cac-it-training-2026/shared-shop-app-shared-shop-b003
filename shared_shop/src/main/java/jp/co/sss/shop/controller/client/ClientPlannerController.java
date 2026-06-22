package jp.co.sss.shop.controller.client;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.service.PlannerService;

@Controller
public class ClientPlannerController {

	@Autowired
	PlannerService plannerService;

	/**
	 * プランナー入力画面表示
	 */
	@RequestMapping(path = "/client/planner/input", method = { RequestMethod.GET, RequestMethod.POST })
	public String showInput() {
		return "client/planner_input";
	}

	/**
	 * プランナー提案結果表示
	 */
	@RequestMapping(path = "/client/planner/results", method = RequestMethod.POST)
	public String showResults(String purpose, Integer budget, Model model) {

		if (budget == null) budget = 0;

		List<List<Item>> itemSets = plannerService.suggestItemSets(purpose, budget);

		model.addAttribute("purpose", purpose);
		model.addAttribute("budget", budget);
		model.addAttribute("itemSets", itemSets);

		return "client/planner_results";
	}
}
