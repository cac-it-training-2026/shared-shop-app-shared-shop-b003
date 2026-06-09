package jp.co.sss.shop.controller.client.item;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.service.BeanTools;
import jp.co.sss.shop.util.Constant;

/**
 * 商品管理 一覧表示機能(一般会員用)のコントローラクラス
 *
 * @author SystemShared
 */
@Controller
public class ClientItemShowController {
	/**
	 * 商品情報
	 */
	@Autowired
	ItemRepository itemRepository;

	/**
	 * Entity、Form、Bean間のデータコピーサービス
	 */
	@Autowired
	BeanTools beanTools;

	/**
	 * トップ画面 表示処理
	 *
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

		//初期値：売れ筋順
		Integer sortType = 2;

		//売れ筋順取得
		List<Item> itemList = itemRepository.findPopularItems();

		//売れ筋商品がない場合
		if (itemList == null || itemList.isEmpty()) {

			//新着順へ変更
			sortType = 1;

			//新着順をDBから取得
			itemList = itemRepository.findByDeleteFlagOrderByInsertDateDesc(Constant.NOT_DELETED);
		}

		// エンティティ内の検索結果をJavaBeansにコピー
		List<ItemBean> itemBeanList = beanTools.copyEntityListToItemBeanList(itemList);

		// 商品情報をViewへ渡す
		model.addAttribute("items", itemBeanList);
		model.addAttribute("sortType", sortType);

		return "index";
	}

	/**
	 * 商品一覧表示
	 * @param sortType 並び順
	 * @param model Viewとの値受渡し
	 * @return "client/item/list" 商品一覧画面
	
	 */

	//required = false→カテゴリ検索しないURL（/client/item/list/1）でも動くようにするため
	@RequestMapping(path = "/client/item/list/{sortType}", method = RequestMethod.GET)
	public String showItemSort(@PathVariable Integer sortType, @RequestParam(required = false) Integer categoryId,
			Model model) {

		List<Item> itemList;

		//外側if→どの商品を表示するか、内側if→どう並べるか
		//カテゴリ検索あり
		if (categoryId != null) {

			//カテゴリ検索あり+新着順
			if (sortType.equals(1)) {

				//onstant.NOT_DELETED→削除されていない商品だけを取得
				itemList = itemRepository.findByCategoryIdAndDeleteFlagOrderByInsertDateDesc(categoryId,
						Constant.NOT_DELETED);

				//カテゴリ検索あり+売れ筋順
			} else {

				/*TODO 現在は全件表示を行っている
				 * これを売れ筋（注文回数が多い順）に改修する*/
				// 売れ筋順
				itemList = itemRepository.findPopularItemsByCategoryId(categoryId);
			}

			//カテゴリ検索なし
		} else {

			//全件+新着順
			if (sortType.equals(1)) {
				itemList = itemRepository.findByDeleteFlagOrderByInsertDateDesc(Constant.NOT_DELETED);
			} else {

				//全件+売れ筋順
				itemList = itemRepository.findPopularItems();
			}
		}

		// Entity → Bean
		List<ItemBean> itemBeanList = beanTools.copyEntityListToItemBeanList(itemList);

		// Viewへ渡す
		model.addAttribute("items", itemBeanList);

		// 並び順
		model.addAttribute("sortType", sortType);

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

		// 商品情報をViewへ渡す
		model.addAttribute("item", itemBean);

		return "client/item/detail";
	}

}
