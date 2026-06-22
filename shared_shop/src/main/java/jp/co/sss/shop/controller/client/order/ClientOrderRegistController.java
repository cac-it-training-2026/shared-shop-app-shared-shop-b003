package jp.co.sss.shop.controller.client.order;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.BasketBean;
import jp.co.sss.shop.bean.OrderItemBean;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.Order;
import jp.co.sss.shop.entity.OrderItem;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.form.OrderForm;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.repository.OrderItemRepository;
import jp.co.sss.shop.repository.OrderRepository;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.service.PriceCalc;

/**
 * お届け先入力から注文完了までのコントローラー
 * @author hayato takahashi
 */
@Controller
public class ClientOrderRegistController {

	/**
	 * 商品表示リポジトリ
	 */
	@Autowired
	ItemRepository itemRepository;

	/**
	 * 注文情報リポジトリ
	 */
	@Autowired
	OrderRepository orderRepository;
	/**
	 * 注文商品情報リポジトリ
	 */
	@Autowired
	OrderItemRepository orderItemRepository;

	/**
	 * ユーザー情報リポジトリ
	 */
	@Autowired
	UserRepository userRepository;

	/**
	 * 料金計算
	 */
	@Autowired
	PriceCalc priceCalc;

	/**
	 * お届け先入力画面表示
	 * @param model viewへ渡すデータを保持するModel
	 * @return お届け先入力画面
	 */
	@PostMapping("/client/order/address/input")
	public String addressInput(Model model, HttpSession session) {

		OrderForm orderForm = new OrderForm();

		UserBean userBean = (UserBean) session.getAttribute("user");

		if (userBean != null) {
			User user = userRepository.getReferenceById(userBean.getId());

			orderForm.setPostalCode(user.getPostalCode());
			orderForm.setAddress(user.getAddress());
			orderForm.setName(user.getName());
			orderForm.setPhoneNumber(user.getPhoneNumber());
		}

		model.addAttribute("orderForm", orderForm);

		return "client/order/address_input";
	}

	/**
	 *支払い方法選択画面表示
	 * @param orderForm お届け先入力フォーム
	 * @param result 入力チェック結果
	 * @param session セッション情報
	 * @param model viewへ渡すデータを保持するModel
	 * @return 入力エラー時はお届け先入力画面、正常時に支払い方法選択画面
	 */
	@PostMapping("/client/order/payment/input")
	public String paymentSelect(
			@Validated OrderForm orderForm,
			BindingResult result,
			HttpSession session,
			Model model) {

		if (result.hasErrors()) {
			return "client/order/address_input";
		}

		session.setAttribute("orderForm", orderForm);

		// 初期の支払い方法を１で確定させる
		if (orderForm.getPayMethod() == null) {
			orderForm.setPayMethod(1);
		}

		model.addAttribute("payMethod", orderForm.getPayMethod());

		return "client/order/payment_input";
	}

	/**
	 * 支払方法選択後、注文確認画面を表示する。
	 * お届け先情報および支払方法を取得し、
	 * 買い物かご内商品の最新在庫数を確認する。
	 * 在庫不足・在庫切れ商品を判定し、
	 * 注文確認画面に表示する情報を作成する。
	 * 
	 * @param payMethod 選択された支払方法
	 * @param session セッション情報
	 * @param model viewへ渡すデータを保持するModel
	 * @return 注文確認画面
	 */
	@PostMapping("/client/order/check")
	public String check(
			@RequestParam Integer payMethod,
			HttpSession session,
			Model model) {

		// お届け先入力画面で保存したorderForm取り出し
		OrderForm orderForm = (OrderForm) session.getAttribute("orderForm");

		// 住所情報だけのorderFormに支払い方法(payMethod)追加
		orderForm.setPayMethod(payMethod);

		// 買い物かごの商品リスト取り出し
		List<BasketBean> basketBeans = (List<BasketBean>) session.getAttribute("basketBeans");

		// 注文確認画面に表示する商品リスト
		List<OrderItemBean> orderItemBeans = new ArrayList<>();

		// 在庫不足・在庫切れの商品名リスト
		List<String> itemNameListLessThan = new ArrayList<>();
		List<String> itemNameListZero = new ArrayList<>();

		int total = 0;

		for (BasketBean basketBean : basketBeans) {

			Item item = itemRepository.getReferenceById(basketBean.getId());

			// 在庫0の場合は注文対象から外す
			if (item.getStock() == 0 || item.getDeleteFlag() == 1) {
				itemNameListZero.add(item.getName());
				continue;
			}

			int orderNum = basketBean.getOrderNum();

			// 注文数が在庫数を超えている場合
			if (orderNum > item.getStock()) {
				itemNameListLessThan.add(item.getName());
				orderNum = item.getStock();
				basketBean.setOrderNum(orderNum);
			}

			OrderItemBean orderItemBean = new OrderItemBean();

			orderItemBean.setId(item.getId());
			orderItemBean.setName(item.getName());

			// カートの価格（固定）を使用、なければ現在のセール価格を計算
			int price;
			if (basketBean.getPrice() != null) {
				price = basketBean.getPrice();
			} else {
				price = priceCalc.getItemPrice(item);
			}

			orderItemBean.setPrice(price);
			orderItemBean.setImage(item.getImage());
			orderItemBean.setOrderNum(orderNum);

			int subtotal = price * orderNum;
			orderItemBean.setSubtotal(subtotal);

			total += subtotal;

			orderItemBeans.add(orderItemBean);
		}

		// 在庫不足・在庫切れメッセージ用
		if (!itemNameListLessThan.isEmpty()) {
			model.addAttribute("itemNameListLessThan", itemNameListLessThan);
		}

		if (!itemNameListZero.isEmpty()) {
			model.addAttribute("itemNameListZero", itemNameListZero);
		}

		model.addAttribute("orderForm", orderForm);
		model.addAttribute("total", total);

		// 全商品が在庫切れの場合のメッセージ渡し
		if (orderItemBeans.isEmpty()) {
			model.addAttribute("orderItemBeans", null);
		} else {
			model.addAttribute("orderItemBeans", orderItemBeans);
		}

		// 在庫不足で注文数を変更した場合に備えてセッションも更新
		session.setAttribute("basketBeans", basketBeans);
		session.setAttribute("orderForm", orderForm);

		return "client/order/check";
	}

	/**
	 * 注文確定処理を行う。
	 * セッションからお届け先情報、支払方法、
	 * 買い物かご情報およびログイン会員情報を取得し、
	 * 再度、在庫の確認を行う。
	 * 在庫が不足、または０の場合はredirectで/client/order/checkに遷移し
	 * エラー文表示を行う。
	 * 問題ない場合注文情報と注文商品情報をデータベースへ登録する。
	 * また、商品の在庫数を更新し、
	 * 注文完了後にセッション情報を削除する。
	 * ページ更新時はトップページへ遷移する。
	 * @param session セッション情報
	 * @return 注文完了画面
	 */
	@PostMapping("/client/order/complete")
	public String showOrderComplete(HttpSession session, Model model) {

		// セッションから取得（届け先、支払い方法）
		OrderForm orderForm = (OrderForm) session.getAttribute("orderForm");

		// 商品ID,注文数取得
		List<BasketBean> basketBeans = (List<BasketBean>) session.getAttribute("basketBeans");

		//ページ更新時にトップ画面へ
		if (orderForm == null || basketBeans == null) {
			return "redirect:/";
		}

		// ログイン会員情報取得
		UserBean userBean = (UserBean) session.getAttribute("user");

		// 注文可能な買い物かご情報
		List<BasketBean> orderableBasketBeans = new ArrayList<>();

		// 注文確認画面に表示する商品リスト
		List<OrderItemBean> orderItemBeans = new ArrayList<>();

		// 在庫切れ商品名リスト
		List<String> itemNameListZero = new ArrayList<>();

		// 在庫不足商品名リスト
		List<String> itemNameListLessThan = new ArrayList<>();

		int total = 0;

		// 注文確定前に最新の在庫を再確認
		for (BasketBean basketBean : basketBeans) {

			Item item = itemRepository.getReferenceById(basketBean.getId());

			// 在庫0の商品は注文対象から外す
			if (item.getStock() == 0 || item.getDeleteFlag() == 1) {
				itemNameListZero.add(item.getName());
				continue;
			}

			int orderNum = basketBean.getOrderNum();

			// 注文数が在庫数を超えている場合は在庫数に補正
			if (orderNum > item.getStock()) {
				itemNameListLessThan.add(item.getName());
				orderNum = item.getStock();
				basketBean.setOrderNum(orderNum);
			}

			// 注文確認画面に再表示するBeanを作成
			OrderItemBean orderItemBean = new OrderItemBean();

			orderItemBean.setId(item.getId());
			orderItemBean.setName(item.getName());

			// カートの価格（固定）を使用
			int price;
			if (basketBean.getPrice() != null) {
				price = basketBean.getPrice();
			} else {
				price = priceCalc.getItemPrice(item);
			}

			orderItemBean.setPrice(price);
			orderItemBean.setImage(item.getImage());
			orderItemBean.setOrderNum(orderNum);

			int subtotal = price * orderNum;
			orderItemBean.setSubtotal(subtotal);

			total += subtotal;

			orderItemBeans.add(orderItemBean);
			orderableBasketBeans.add(basketBean);
		}

		// 在庫切れ・在庫不足の商品があった場合は、注文登録せず確認画面へ戻す
		if (!itemNameListZero.isEmpty() || !itemNameListLessThan.isEmpty()) {

			if (!itemNameListZero.isEmpty()) {
				model.addAttribute("itemNameListZero", itemNameListZero);
			}

			if (!itemNameListLessThan.isEmpty()) {
				model.addAttribute("itemNameListLessThan", itemNameListLessThan);
			}

			model.addAttribute("orderForm", orderForm);
			model.addAttribute("total", total);

			// 注文可能商品が1件もない場合
			if (orderItemBeans.isEmpty()) {
				model.addAttribute("orderItemBeans", null);
			} else {
				model.addAttribute("orderItemBeans", orderItemBeans);
			}

			// 在庫切れ商品を除いた状態でセッションを更新
			session.setAttribute("basketBeans", orderableBasketBeans);
			session.setAttribute("orderForm", orderForm);

			return "client/order/check";
		}

		// ここから下は、在庫に問題がない場合だけ注文登録

		Order order = new Order();

		order.setPostalCode(orderForm.getPostalCode());
		order.setAddress(orderForm.getAddress());
		order.setName(orderForm.getName());
		order.setPhoneNumber(orderForm.getPhoneNumber());
		order.setPayMethod(orderForm.getPayMethod());

		User user = new User();
		user.setId(userBean.getId());
		order.setUser(user);

		orderRepository.save(order);

		for (BasketBean basketBean : orderableBasketBeans) {

			Item item = itemRepository.getReferenceById(basketBean.getId());

			OrderItem orderItem = new OrderItem();

			orderItem.setOrder(order);
			orderItem.setItem(item);
			orderItem.setQuantity(basketBean.getOrderNum());

			// カート投入時の固定価格を使用
			if (basketBean.getPrice() != null) {
				orderItem.setPrice(basketBean.getPrice());
			} else {
				orderItem.setPrice(priceCalc.getItemPrice(item));
			}

			orderItemRepository.save(orderItem);

			// 在庫数を減らす
			item.setStock(item.getStock() - basketBean.getOrderNum());
			itemRepository.save(item);
		}

		session.removeAttribute("basketBeans");
		session.removeAttribute("orderForm");

		return "client/order/complete";
	}

	/**
	 * 届け先入力画面へ戻る
	 * 入力情報は保持
	 * @param model viewへ渡すデータを保持するModel
	 * @param session セッション情報
	 * @return 届け先入力画面
	 */
	@PostMapping("/client/order/payment/back")
	public String paymentBack(Model model, HttpSession session) {

		// セッションに保存してある届け先情報を取得
		OrderForm orderForm = (OrderForm) session.getAttribute("orderForm");

		// 念のため、なければ空フォーム
		if (orderForm == null) {
			orderForm = new OrderForm();
		}

		model.addAttribute("orderForm", orderForm);

		return "client/order/address_input";

	}
}
