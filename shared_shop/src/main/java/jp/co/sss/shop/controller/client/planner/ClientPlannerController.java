package jp.co.sss.shop.controller.client.planner;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.repository.PlannerKeywordCategoryRepository;
import jp.co.sss.shop.service.PlannerService;

/**
 * スマート購入プランナー用コントローラ
 */
@Controller
public class ClientPlannerController {

	@Autowired
	PlannerKeywordCategoryRepository plannerRepository;

	@Autowired
	PlannerService plannerService;

	/**
	 * プランナー入力画面表示
	 */
	@RequestMapping(path = "/client/planner/input", method = RequestMethod.GET)
	public String plannerInput(Model model) {
		model.addAttribute("keywords", plannerRepository.findAllCustomKeywords());
		return "client/planner/input";
	}

	/**
	 * プラン生成・結果画面表示
	 */
	@RequestMapping(path = "/client/planner/result", method = RequestMethod.POST)
	public String plannerResult(String keyword, Integer budget, Model model) {
		if (keyword == null || budget == null) {
			return "redirect:/client/planner/input";
		}

		List<List<ItemBean>> plans = plannerService.generatePlans(keyword, budget);

		model.addAttribute("keyword", keyword);
		model.addAttribute("budget", budget);
		model.addAttribute("plans", plans);

		return "client/planner/result";
	}
}
