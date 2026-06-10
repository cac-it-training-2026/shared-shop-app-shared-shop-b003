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
	 * お届け先入力画面表示
	 * @param model viewへ渡すデータを保持するModel
	 * @return お届け先入力画面
	 */
	@PostMapping("/client/order/address/input")
	public String addressInput(Model model) {

		// address_inputのth:object="${orderForm}"で使うために空のOrderFormを送る
		model.addAttribute("orderForm", new OrderForm());

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
	 * 支払い方法受取後、注文確認画面表示
	 * 
	 * @param payMethod 選択された支払方法
	 * @param sessionセッション情報
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

		// 注文確認画面に表示する商品リストを作る準備
		List<OrderItemBean> orderItemBeans = new ArrayList<>();

		int total = 0;

		// 買い物かごの商品を１件ずつDBから商品情報を取得
		for (BasketBean basketBean : basketBeans) {

			Item item = itemRepository.getReferenceById(basketBean.getId());

			OrderItemBean orderItemBean = new OrderItemBean();

			orderItemBean.setId(item.getId());
			orderItemBean.setName(item.getName());
			orderItemBean.setPrice(item.getPrice());
			orderItemBean.setImage(item.getImage());
			orderItemBean.setOrderNum(basketBean.getOrderNum());

			int subtotal = item.getPrice() * basketBean.getOrderNum();
			orderItemBean.setSubtotal(subtotal);

			total += subtotal;

			orderItemBeans.add(orderItemBean);
		}

		// orderForm→お届け先・支払い方法
		// orderItemBeans→商品名・画像・単価・数量・小計
		// total→合計金額
		model.addAttribute("orderForm", orderForm);
		model.addAttribute("orderItemBeans", orderItemBeans);
		model.addAttribute("total", total);

		return "client/order/check";
	}

	/**
	 * 注文完了画面表示
	 * セッションから、注文情報、買い物かご情報、ログイン会員情報を取得
	 * データベースへ登録
	 * @param session セッション情報
	 * @return 注文完了画面
	 */
	@PostMapping("/client/order/complete")
	public String showOrderComplete(HttpSession session) {

		// セッションから取得（届け先、支払い方法）
		OrderForm orderForm = (OrderForm) session.getAttribute("orderForm");

		// 商品ID,注文数取得
		List<BasketBean> basketBeans = (List<BasketBean>) session.getAttribute("basketBeans");

		// ログイン会員情報取得
		UserBean userBean = (UserBean) session.getAttribute("user");

		// 空の注文情報作成
		Order order = new Order();

		// フォームの内容セット
		order.setPostalCode(orderForm.getPostalCode());
		order.setAddress(orderForm.getAddress());
		order.setName(orderForm.getName());
		order.setPhoneNumber(orderForm.getPhoneNumber());
		order.setPayMethod(orderForm.getPayMethod());

		// 会員設定
		User user = new User();
		user.setId(userBean.getId());

		order.setUser(user);

		// ordersテーブル保存
		orderRepository.save(order);

		// 注文商品を一つずつ保存
		for (BasketBean basketBean : basketBeans) {

			Item item = itemRepository.getReferenceById(
					basketBean.getId());

			OrderItem orderItem = new OrderItem();

			orderItem.setOrder(order);
			orderItem.setItem(item);
			orderItem.setQuantity(
					basketBean.getOrderNum());

			// 注文時の価格を保存
			orderItem.setPrice(
					item.getPrice());

			orderItemRepository.save(orderItem);
		}

		// 買い物かご削除
		session.removeAttribute("basketBeans");

		// 注文フォーム削除
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
	public String paymantBack(Model model, HttpSession session) {

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
