package jp.co.sss.shop.controller.client.basket;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.BasketBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.service.CartService;

/**
 * 買い物かごのコントローラークラス
 * @author nanba kosei
 */

@Controller
public class ClientBasketController {
	/**
	 * セッション
	 */
	@Autowired
	HttpSession session;

	/**
	 * アイテム情報 リポジトリ
	 */
	@Autowired
	ItemRepository itemRepository;

	/**
	 * カートサービス
	 */
	@Autowired
	CartService cartService;

	/**
	 * 買い物かご一覧表示処理
	 * @param model Viewとの値受渡し
	 * @return "client/basket/list" 買い物かご一覧表示
	 * @return "redirect:/login" 未ログイン時にログイン画面へ
	 */
	@RequestMapping(path = "/client/basket/list", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBasketList(Model model) {
		// 会員情報の確認
		if (session.getAttribute("user") == null) {
			// 未ログインの場合、ログイン画面へ
			return "redirect:/login";
		}

		// 買い物かごのリストを取得
		Optional<List<BasketBean>> basketBeansOptional = Optional
				.ofNullable((List<BasketBean>) session.getAttribute("basketBeans"));

		// エラーメッセージのリストを作成
		List<String> itemNameListZero = new ArrayList<>();
		List<String> itemNameListLessThan = new ArrayList<>();

		// 買い物かごを確認
		basketBeansOptional.ifPresent(basketBeans -> {
			for (BasketBean basketBean : basketBeans) {
				// 商品の情報を取得
				Optional<Item> itemOptional = itemRepository.findById(basketBean.getId());

				// itemOptionalのnullチェック
				itemOptional.ifPresent(item -> {
					// 商品情報を最新に更新
					BeanUtils.copyProperties(item, basketBean, "orderNum");

					// 在庫数を確認
					if (item.getStock() <= 0 || item.getDeleteFlag() == 1) {
						// 在庫数が0の場合のエラーメッセージの追加
						itemNameListZero.add(basketBean.getName());
						// 注文数を0に
						basketBean.setOrderNum(0);
					} else if (basketBean.getStock() < basketBean.getOrderNum()) {
						// 在庫数 < 注文数 の場合のエラーメッセージの追加
						itemNameListLessThan.add(basketBean.getName());
						// 注文数を在庫数に合わせる
						basketBean.setOrderNum(item.getStock());
					}
				});
			}

			// エラーメッセージをリクエストスコープ追加
			model.addAttribute("itemNameListZero", itemNameListZero);
			model.addAttribute("itemNameListLessThan", itemNameListLessThan);

			// 注文数が0の商品を買い物かごから削除
			basketBeans.removeIf(basketBean -> basketBean.getOrderNum() <= 0);

			// セッションの買い物かごの情報を更新
			if (basketBeans.size() == 0) {
				// 買い物かごが空なら、セッションから買い物かご情報を削除
				session.removeAttribute("basketBeans");
			} else {
				// セッション情報を最新に更新
				session.setAttribute("basketBeans", basketBeans);
			}
		});

		return "client/basket/list";
	}

	/**
	 * idで主キー検索をし、リストに追加
	 * @param id 追加したい商品のID
	 * @return "redirect:/client/basket/list" 買い物かご一覧表示
	 * @return "redirect:/login" 未ログイン時にログイン画面へ
	 */
	@RequestMapping(path = "/client/basket/add", method = RequestMethod.POST)
	public String addBasket(Integer id) {
		// 会員情報の確認
		if (session.getAttribute("user") == null) {
			// 未ログインの場合、ログイン画面へ
			return "redirect:/login";
		}

		cartService.addItem(id);

		return "redirect:/client/basket/list";
	}

	/**
	 * 買い物かご内の対象商品の数を減らす。
	 * @param id 減らしたい商品のID
	 * @return "redirect:/client/basket/list" 削除後のリストを表示
	 * @return "redirect:/login" 未ログイン時にログイン画面へ	
	 */
	@RequestMapping(path = "/client/basket/delete", method = RequestMethod.POST)
	public String deleteBasket(Integer id) {
		// 会員情報の確認
		if (session.getAttribute("user") == null) {
			return "redirect:/login";
		}

		// 買い物かごのリストを取得
		Optional<List<BasketBean>> basketBeansOptional = Optional
				.ofNullable((List<BasketBean>) session.getAttribute("basketBeans"));

		// nullチェック
		basketBeansOptional.ifPresent(basketBeans -> {
			// 対象の商品を探す
			for (BasketBean basketBean : basketBeans) {
				// 対象の商品の情報を取得
				if (basketBean.getId().equals(id)) {
					// 対象の買い物かごの商品数をデクリメント
					basketBean.setOrderNum(basketBean.getOrderNum() - 1);
					break;
				}
			}

			// 買い物かごの中でorderNumが0になった商品を削除
			basketBeans.removeIf(basketBean -> basketBean.getOrderNum() <= 0);

			// 買い物かごが空なら、セッションから買い物かご情報を削除
			if (basketBeans.size() == 0) {
				session.removeAttribute("basketBeans");
			}

		});
		return "redirect:/client/basket/list";
	}

	/**
	 * 買い物かごを空にする
	 * @return "redirect:/client/basket/list" 削除後のページを表示
	 * @return "redirect:/login" 未ログイン時にログイン画面へ
	 */
	@RequestMapping(path = "/client/basket/allDelete", method = RequestMethod.POST)
	public String allDeleteBasket() {
		// 会員情報の確認
		if (session.getAttribute("user") == null) {
			return "redirect:/login";
		}

		// セッションから買い物かご情報を削除
		session.removeAttribute("basketBeans");
		return "redirect:/client/basket/list";
	}

}
