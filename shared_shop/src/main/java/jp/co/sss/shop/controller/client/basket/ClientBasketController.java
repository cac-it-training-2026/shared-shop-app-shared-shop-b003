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

	@Autowired
	ItemRepository itemRepository;

	/**
	 * 買い物かご一覧表示処理
	 * @return "client/basket/list" 買い物かご一覧表示
	 */
	@RequestMapping(path = "/client/basket/list", method = RequestMethod.GET)
	public String showBasketList() {
		return "client/basket/list";
	}

	/**
	 * idで主キー検索をし、リストに追加
	 * @param id
	 * @return "redirect:/client/basket/list" 買い物かご一覧表示
	 */
	@RequestMapping(path = "/client/basket/add", method = RequestMethod.POST)
	public String addBasket(Integer id, Model model) {
		// セッションのリストを取得
		List<BasketBean> basketBeans = (List<BasketBean>) session.getAttribute("basketBeans");

		// リストが空なら作成する
		if (basketBeans == null) {
			basketBeans = new ArrayList<>();
		} else {
			// 同じ商品を探す
			for (BasketBean basketBean : basketBeans) {
				// 同じ商品の場合
				if (id == basketBean.getId()) {
					if (basketBean.getOrderNum() == basketBean.getStock()) {
						model.addAttribute("itemNameListLessThan", basketBean.getName());
						return "client/basket/list";
					} else {
						// orderNumをインクリメントし、リダイレクト
						basketBean.setOrderNum(basketBean.getOrderNum() + 1);
					}
					return "redirect:/client/basket/list";
				}
			}
		}
		// 同じ商品がなかった場合

		// BasketBeanを作成
		BasketBean basketBean = new BasketBean();

		// 主キー検索をし、コピー
		BeanUtils.copyProperties(itemRepository.getReferenceById(id), basketBean);

		// Listに追加
		basketBeans.add(basketBean);

		// リストをセッションにセット
		session.setAttribute("basketBeans", basketBeans);

		return "redirect:/client/basket/list";
	}

	/**
	 * 買い物かご内の対象商品の数を減らす。
	 * @param id
	 * @return "redirect:/client/basket/list" 削除後のリストを表示
	 */
	@RequestMapping(path = "/client/basket/delete", method = RequestMethod.POST)
	public String deleteBasket(Integer id) {
		// セッションのリストを取得
		List<BasketBean> basketBeans = (List<BasketBean>) session.getAttribute("basketBeans");

		// 同じ商品を探す
		for (BasketBean basketBean : basketBeans) {
			// 同じ商品の場合
			if (id == basketBean.getId()) {
				// orderNumをデクリメントし、リダイレクト
				if (basketBean.getOrderNum() == 1) {
					// basketBeansから削除
					basketBeans.remove(basketBean);
					// 買い物かごが空なら、セッションから買い物かご情報を削除
					if (basketBeans.size() == 0) {
						session.removeAttribute("basketBeans");
					}
				} else {
					basketBean.setOrderNum(basketBean.getOrderNum() - 1);
				}

				return "redirect:/client/basket/list";
			}
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
