package jp.co.sss.shop.controller.client.item;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.SaleSchedule;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.service.BeanTools;
import jp.co.sss.shop.service.SaleService;
import jp.co.sss.shop.util.Constant;

/**
 * タイムセール商品一覧表示機能のコントローラクラス
 */
@Controller
public class ClientTimeSaleController {

    @Autowired
    private ItemRepository itemRepository;

    @Autowired
    private BeanTools beanTools;

    @Autowired
    private SaleService saleService;

    /**
     * タイムセール対象商品一覧表示
     * @param model モデル
     * @return "client/item/sale_list" タイムセール一覧画面
     */
    @RequestMapping(path = "/sale")
    public String showSaleList(Model model) {
        Map<Integer, SaleSchedule> activeSales = saleService.getActiveSales();

        // 開催中のセールカテゴリIDを取得
        List<Integer> categoryIds = activeSales.keySet().stream().collect(Collectors.toList());

        // 削除されていない全商品を取得
        List<Item> itemList = itemRepository.findByDeleteFlagOrderByInsertDateDesc(Constant.NOT_DELETED);

        // Beanに変換
        List<ItemBean> itemBeanList = beanTools.copyEntityListToItemBeanList(itemList);

        // セール対象の商品のみ抽出
        List<ItemBean> saleItemBeanList = itemBeanList.stream()
            .filter(item -> categoryIds.contains(item.getCategoryId()))
            .collect(Collectors.toList());

        // 割引を適用
        saleService.applyDiscounts(saleItemBeanList, activeSales);

        model.addAttribute("items", saleItemBeanList);
        return "client/item/sale_list";
    }
}
