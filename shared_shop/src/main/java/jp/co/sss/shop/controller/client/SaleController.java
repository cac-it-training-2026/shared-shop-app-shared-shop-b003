package jp.co.sss.shop.controller.client;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.service.BeanTools;
import jp.co.sss.shop.util.Constant;

/**
 * タイムセール用コントローラ
 */
@Controller
public class SaleController {

	@Autowired
	ItemRepository itemRepository;

	@Autowired
	BeanTools beanTools;

	/**
	 * タイムセール対象商品一覧表示
	 */
	@GetMapping("/sale")
	public String showSaleItems(Model model) {
		// 全ての商品を取得し、BeanToolsでセール中かを判定する
		List<Item> itemList = itemRepository.findByDeleteFlagOrderByInsertDateDesc(Constant.NOT_DELETED);
		List<ItemBean> itemBeanList = beanTools.copyEntityListToItemBeanList(itemList);

		// セール中の商品のみに絞り込む
		itemBeanList.removeIf(bean -> !bean.isOnSale());

		model.addAttribute("items", itemBeanList);
		return "sale/index";
	}
}
