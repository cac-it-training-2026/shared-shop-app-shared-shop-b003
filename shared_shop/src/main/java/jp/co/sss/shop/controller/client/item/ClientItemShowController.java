package jp.co.sss.shop.controller.client.item;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.bean.ReviewBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.Review;
import jp.co.sss.shop.repository.CategoryRepository;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.repository.ReviewRepository;
import jp.co.sss.shop.service.BeanTools;
import jp.co.sss.shop.service.SaleService;
import jp.co.sss.shop.util.Constant;

/**
 * 商品管理 一覧表示機能(一般会員用)のコントローラクラス
 *
 * @author SystemShared
 */
/**
 * 
 */
@Controller
public class ClientItemShowController {
	/**
	 * 商品情報
	 * DBから商品を取得するクラスを使えるようにする
	 */
	@Autowired
	ItemRepository itemRepository;

	/**
	 * Entity、Form、Bean間のデータコピーサービス
	 */
	@Autowired
	BeanTools beanTools;

	/**
	 * カテゴリ一覧を取得する
	 */
	@Autowired
	CategoryRepository categoryRepository;

	/**
	 * タイムセールサービス
	 */
	@Autowired
	SaleService saleService;
  /**
	 * レビュー一覧を取得する
	 */
	@Autowired
	ReviewRepository reviewRepository;

	/**
	 * トップ画面 表示処理
	 *
	 * @author Emi Shioda
	 * @param model    Viewとの値受渡し
	 * @return "index" トップ画面
	 * 
	 * 商品一覧表示の並び順を「売れ筋順」に初期化
	 * ↓
	 * 売れ筋商品取得
	 * ↓
	 * なかったら新着順取得
	 * 
	 * つまりトップ画面での優先順位は
	 * 売れ筋順→なければ新着順と表示
	 */

	@RequestMapping(path = "/", method = { RequestMethod.GET, RequestMethod.POST })
	public String index(Model model) {

		// 初期値：売れ筋順
		Integer sortType = 2;

		// 売れ筋順取得（@Queryメソッドの呼び出し）
		List<Item> itemList = itemRepository.findPopularItems();

		// 売れ筋商品がない場合
		if (itemList == null || itemList.isEmpty()) {

			// 新着順へ変更
			sortType = 1;

			// 削除されていない商品を新着順でDBから取得
			itemList = itemRepository.findByDeleteFlagOrderByInsertDateDesc(Constant.NOT_DELETED);
		}

		// エンティティ内の検索結果をJavaBeansにコピー（画面用に変換）
		List<ItemBean> itemBeanList = beanTools.copyEntityListToItemBeanList(itemList);

		// タイムセール適用
		saleService.applyDiscounts(itemBeanList, saleService.getActiveSales());

		// 商品情報をView（画面）へ渡す（商品一覧、並び順、カテゴリ一覧）
		model.addAttribute("items", itemBeanList);
		model.addAttribute("sortType", sortType);
		model.addAttribute("categories", categoryRepository.findAll());

		return "index";
	}

	/**
	 * 商品一覧表示
	 * @param sortType 並び順
	 * @param model Viewとの値受渡し
	 * @return "client/item/list" 商品一覧画面
	
	 */

	//sortType→URLから取る（1or2）、categoryId→リクエストパラメータ（?categoryId=1）
	@RequestMapping(path = "/client/item/list/{sortType}", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String showItemSort(@PathVariable Integer sortType, Integer categoryId, Model model) {

		List<Item> itemList;

		// 外側if→どの商品を表示するか、内側if→どう並べるか
		// カテゴリ検索あり
		if (categoryId != null && categoryId != 0) {

			// カテゴリ検索あり + 新着順
			if (sortType.equals(1)) {

				// Constant.NOT_DELETED→削除されていない商品だけを取得
				itemList = itemRepository.findByCategoryIdAndDeleteFlagOrderByInsertDateDesc(categoryId,
						Constant.NOT_DELETED);

				// カテゴリ検索あり + 売れ筋順
			} else {

				itemList = itemRepository.findPopularItemsByCategoryId(categoryId);
			}

		} else {

			// カテゴリ検索なし（全件）
			if (sortType.equals(1)) {

				// 全件 + 新着順
				itemList = itemRepository.findByDeleteFlagOrderByInsertDateDesc(Constant.NOT_DELETED);
			} else {

				// 全件 + 売れ筋順
				itemList = itemRepository.findPopularItems();
			}
		}

		// Entity → Bean
		List<ItemBean> itemBeanList = beanTools.copyEntityListToItemBeanList(itemList);

		// タイムセール適用
		saleService.applyDiscounts(itemBeanList, saleService.getActiveSales());

		// Viewへ渡す
		model.addAttribute("items", itemBeanList);

		// 並び順
		model.addAttribute("sortType", sortType);

		// カテゴリー検索
		model.addAttribute("categories", categoryRepository.findAll());

		// カテゴリ検索の内容を画面遷移しても保持する
		model.addAttribute("categoryId", categoryId);

		return "client/item/list";
	}

	/**
	 * 詳細表示処理
	 *
	 * @param id      表示対象ID
	 * @param model   Viewとの値受渡し
	 * @return "client/item/detail" 詳細画面 表示
	 */

	@RequestMapping(path = "/client/item/detail/{id}")
	public String showItem(@PathVariable int id, Model model) {

		// 商品IDに該当する商品情報を取得する
		Item item = itemRepository.findByIdAndDeleteFlag(id, Constant.NOT_DELETED);
		if (item == null) {
			return "redirect:/syserror";
		}

		// Itemエンティティの各フィールドの値をItemBeanにコピー
		ItemBean itemBean = beanTools.copyEntityToItemBean(item);

		// タイムセール適用
		saleService.applyDiscount(itemBean, saleService.getActiveSales());

		// 商品情報をViewへ渡す
		model.addAttribute("item", itemBean);

		// レビュー一覧を取得
		List<Review> reviewList = reviewRepository.findByItemIdOrderByInsertDateDesc(id);
		List<ReviewBean> reviewBeanList = beanTools.copyEntityListToReviewBeanList(reviewList);
		model.addAttribute("reviews", reviewBeanList);

		return "client/item/detail";
	}

}
