package jp.co.sss.shop.controller.client.basket;

import java.sql.Timestamp;
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
import jp.co.sss.shop.bean.CouponBean;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Coupon;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.repository.CouponRepository;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.service.PriceCalc;

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
	 * クーポン情報 リポジトリ
	 */
	@Autowired
	CouponRepository couponRepository;

	/**
	 * 料金計算サービス
	 */
	@Autowired
	PriceCalc priceCalc;

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
				session.removeAttribute("coupon");
			} else {
				// セッション情報を最新に更新
				session.setAttribute("basketBeans", basketBeans);
			}
		});

		// 合計金額の計算
		List<BasketBean> basketBeans = (List<BasketBean>) session.getAttribute("basketBeans");
		if (basketBeans != null) {
			int total = 0;
			for (BasketBean bean : basketBeans) {
				total += bean.getPrice() * bean.getOrderNum();
			}
			model.addAttribute("total", total);

			// クーポン適用後の合計
			CouponBean couponBean = (CouponBean) session.getAttribute("coupon");
			if (couponBean != null) {
				int discount = priceCalc.calculateDiscount(total, couponBean);
				int discountedTotal = Math.max(0, total - discount);
				model.addAttribute("discount", discount);
				model.addAttribute("discountedTotal", discountedTotal);
			}
		}

		// エラーメッセージの表示
		String couponError = (String) session.getAttribute("couponError");
		if (couponError != null) {
			model.addAttribute("couponError", couponError);
			session.removeAttribute("couponError");
		}

		return "client/basket/list";
	}

	/**
	 * クーポンの適用
	 * @param code クーポンコード
	 * @return "redirect:/client/basket/list" 買い物かご一覧表示
	 */
	@RequestMapping(path = "/client/basket/applyCoupon", method = RequestMethod.POST)
	public String applyCoupon(String code, Model model) {
		UserBean userBean = (UserBean) session.getAttribute("user");
		if (userBean == null) {
			return "redirect:/login";
		}

		Coupon coupon = couponRepository.findByCode(code);
		Timestamp now = new Timestamp(System.currentTimeMillis());

		// バリデーション: クーポンの存在、有効期限、使用回数、およびユーザー所有権の確認
		if (coupon != null
				&& (coupon.getValidFrom() == null || coupon.getValidFrom().before(now))
				&& (coupon.getValidUntil() == null || coupon.getValidUntil().after(now))
				&& (coupon.getUsageLimit() == null || coupon.getUsageLimit() > 0)
				&& (coupon.getUserId() == null || coupon.getUserId().equals(userBean.getId()))) {

			CouponBean couponBean = new CouponBean();
			BeanUtils.copyProperties(coupon, couponBean);
			session.setAttribute("coupon", couponBean);
		} else {
			session.setAttribute("couponError", "無効なクーポンコード、期限切れ、所有権がない、または使用上限に達しています。");
		}

		return "redirect:/client/basket/list";
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

		// BasketBeanを作成
		BasketBean inputbasketBean = new BasketBean();
		// 主キー検索
		Optional<Item> itemOptional = itemRepository.findById(id);

		// nullチェック
		if (!itemOptional.isEmpty()) {
			// Itemの情報を取り出し
			Item item = itemOptional.get();
			// beanにコピー
			BeanUtils.copyProperties(item, inputbasketBean);
			inputbasketBean.setPrice(item.getPrice());

			// 在庫数の確認
			if (inputbasketBean.getStock() <= 0) {
				// 在庫がないなら追加せずに、リダイレクト
				return "redirect:/client/basket/list";
			}

			// 買い物かごのリストを取得
			List<BasketBean> basketBeans = (List<BasketBean>) session.getAttribute("basketBeans");

			// リストが空なら作成する
			if (basketBeans == null) {
				basketBeans = new ArrayList<>();
			} else {
				// 同じ商品を探す
				for (BasketBean bean : basketBeans) {
					// 同じ商品があった場合
					if (bean.getId().equals(id)) {
						// orderNumをインクリメントし、リダイレクト
						bean.setOrderNum(bean.getOrderNum() + 1);
						return "redirect:/client/basket/list";
					}
				}
			}
			// 同じ商品がなかった場合
			// Listに追加
			basketBeans.add(inputbasketBean);

			// リストをセッションにセット
			session.setAttribute("basketBeans", basketBeans);
		}
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
