package jp.co.sss.shop.controller.client.planner;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.validation.Valid;
import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.bean.PlannerResultBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.form.PlannerForm;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.service.BeanTools;
import jp.co.sss.shop.util.Constant;

/**
 * スマート購入プランナーのコントローラ
 */
@Controller
public class ClientPlannerController {

	@Autowired
	ItemRepository itemRepository;

	@Autowired
	BeanTools beanTools;

	/**
	 * 入力画面表示
	 */
	@RequestMapping(path = "/client/planner/input", method = { RequestMethod.GET, RequestMethod.POST })
	public String plannerInput(@ModelAttribute PlannerForm form) {
		return "client/planner/input";
	}

	/**
	 * 提案結果表示
	 */
	@RequestMapping(path = "/client/planner/result", method = RequestMethod.POST)
	public String plannerResult(@Valid @ModelAttribute PlannerForm form, BindingResult result, Model model) {
		if (result.hasErrors()) {
			return "client/planner/input";
		}

		List<Item> allItems = itemRepository.findByDeleteFlagOrderByInsertDateDesc(Constant.NOT_DELETED);
		List<Item> candidates = new ArrayList<>();

		String purposeName = "";
		switch (form.getPurpose()) {
		case 1:
			purposeName = "パーティー";
			// パーティー用: 菓子、飲料などのキーワード（ここではデモ用にフィルタリング）
			for (Item item : allItems) {
				if (item.getName().contains("菓子") || item.getName().contains("飲料") || item.getPrice() < 1000) {
					candidates.add(item);
				}
			}
			break;
		case 2:
			purposeName = "自分へのご褒美";
			// 自分へのご褒美: 高単価な商品を優先
			for (Item item : allItems) {
				if (item.getPrice() >= 1000) {
					candidates.add(item);
				}
			}
			break;
		case 3:
			purposeName = "日常";
			// 日常: 全ての商品が候補
			candidates.addAll(allItems);
			break;
		default:
			purposeName = "おまかせ";
			candidates.addAll(allItems);
			break;
		}

		if (candidates.isEmpty()) {
			candidates.addAll(allItems);
		}

		// ランダムに選ぶためにシャッフル
		Collections.shuffle(candidates);

		List<Item> selectedItems = new ArrayList<>();
		int currentTotal = 0;
		int budget = form.getBudget();

		for (Item item : candidates) {
			if (currentTotal + item.getPrice() <= budget) {
				selectedItems.add(item);
				currentTotal += item.getPrice();
			}
			if (currentTotal >= budget * 0.9) { // 予算の90%以上埋まったら終了
				break;
			}
		}

		PlannerResultBean resultBean = new PlannerResultBean();
		List<ItemBean> itemBeanList = beanTools.copyEntityListToItemBeanList(selectedItems);
		resultBean.setItemList(itemBeanList);
		resultBean.setTotalAmount(currentTotal);
		resultBean.setPurposeName(purposeName);
		resultBean.setBudget(budget);

		model.addAttribute("result", resultBean);

		return "client/planner/result";
	}
}
