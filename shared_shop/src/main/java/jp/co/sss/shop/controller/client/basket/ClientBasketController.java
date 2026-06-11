package jp.co.sss.shop.controller.client.basket;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.BasketBean;
import jp.co.sss.shop.repository.ItemRepository;

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
	 * 買い物かご一覧表示処理
	 * @return "client/basket/list" 買い物かご一覧表示
	 * @return "redirect:/login" 未ログイン時にログイン画面へ
	 */
	@RequestMapping(path = "/client/basket/list", method = RequestMethod.GET)
	public String showBasketList() {
		// 会員情報の確認
		if (session.getAttribute("user") == null) {
			// 未ログインの場合、ログイン画面へ
			return "redirect:/login";
		}
		return "client/basket/list";
	}

	/**
	 * idで主キー検索をし、リストに追加
	 * @param id 追加したい商品のID
	 * @param model Viewとの値受渡し
	 * @return "redirect:/client/basket/list" 買い物かご一覧表示
	 * @return "client/basket/list" エラーメッセージをスコープに追加し、買い物かご一覧を表示
	 * @return "redirect:/login" 未ログイン時にログイン画面へ
	 */
	@RequestMapping(path = "/client/basket/add", method = RequestMethod.POST)
	public String addBasket(Integer id, Model model) {
		// 会員情報の確認
		if (session.getAttribute("user") == null) {
			// 未ログインの場合、ログイン画面へ
			return "redirect:/login";
		}

		// BasketBeanを作成
		BasketBean inputbasketBean = new BasketBean();
		// 主キー検索をし、コピー
		BeanUtils.copyProperties(itemRepository.getReferenceById(id), inputbasketBean);

		// 在庫数の確認
		if (inputbasketBean.getStock() == 0) {
			// エラーメッセージの追加
			model.addAttribute("itemNameListZero", inputbasketBean.getName());
			return "client/basket/list";
		}

		// セッションのリストを取得
		List<BasketBean> basketBeans = (List<BasketBean>) session.getAttribute("basketBeans");

		// リストが空なら作成する
		if (basketBeans == null) {
			basketBeans = new ArrayList<>();
		} else {
			// 同じ商品を探す
			for (BasketBean bean : basketBeans) {
				// 同じ商品があった場合
				if (bean.getId().equals(id)) {
					// 在庫数を確認
					if (bean.getOrderNum().equals(bean.getStock())) {
						// 在庫を上回った場合、エラーメッセージを追加
						model.addAttribute("itemNameListLessThan", bean.getName());
						return "client/basket/list";
					} else {
						// 在庫がある場合
						// orderNumをインクリメントし、リダイレクト
						bean.setOrderNum(bean.getOrderNum() + 1);
					}
					return "redirect:/client/basket/list";
				}
			}
		}
		// 同じ商品がなかった場合
		// Listに追加
		basketBeans.add(inputbasketBean);

		// リストをセッションにセット
		session.setAttribute("basketBeans", basketBeans);

		return "redirect:/client/basket/list";
	}

	/**
	 * 買い物かご内の対象商品の数を減らす。
	 * @param id 減らしたい商品のID
	 * @return "redirect:/client/basket/list" 削除後のリストを表示
	 */
	@RequestMapping(path = "/client/basket/delete", method = RequestMethod.POST)
	public String deleteBasket(Integer id) {
		// セッションのリストを取得
		List<BasketBean> basketBeans = (List<BasketBean>) session.getAttribute("basketBeans");

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

		return "redirect:/client/basket/list";
	}

	/**
	 * 買い物かごを空にする
	 * @return "redirect:/client/basket/list" 削除後のページを表示
	 */
	@RequestMapping(path = "/client/basket/allDelete", method = RequestMethod.POST)
	public String allDeleteBasket() {
		// セッションから買い物かご情報を削除
		session.removeAttribute("basketBeans");
		return "redirect:/client/basket/list";
	}

}
