package jp.co.sss.shop.controller.client;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.SaleSchedule;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.service.BeanTools;
import jp.co.sss.shop.service.SaleService;
import jp.co.sss.shop.util.Constant;

/**
 * タイムセール用コントローラ
 */
@Controller
public class SaleController {

	@Autowired
	SaleService saleService;

	@Autowired
	ItemRepository itemRepository;

	@Autowired
	BeanTools beanTools;

	/**
	 * タイムセール一覧表示
	 * @param model viewへ渡すデータを保持するModel
	 * @return タイムセール一覧画面
	 */
	@GetMapping("/sale")
	public String showSaleList(Model model) {
		List<SaleSchedule> sales = saleService.getActiveSales();
		model.addAttribute("sales", sales);
		return "sale/index";
	}

	/**
	 * タイムセール対象商品表示
	 * @param model viewへ渡すデータを保持するModel
	 * @return 商品一覧画面
	 */
	@GetMapping("/sale/items")
	public String showSaleItems(Model model) {
		List<SaleSchedule> activeSales = saleService.getActiveSales();

		// 現在の仕様では、全ての非削除商品を読み込み、BeanToolsでセール中かを判定する
		// (より効率的な方法は、カテゴリIDでフィルタリングすること)
		List<Item> itemList = itemRepository.findByDeleteFlagOrderByInsertDateDesc(Constant.NOT_DELETED);
		List<ItemBean> itemBeanList = beanTools.copyEntityListToItemBeanList(itemList);

		// セール中の商品のみに絞り込む
		itemBeanList.removeIf(bean -> !bean.isOnSale());

		model.addAttribute("items", itemBeanList);
		model.addAttribute("sales", activeSales);
		return "client/item/list";
	}
}
