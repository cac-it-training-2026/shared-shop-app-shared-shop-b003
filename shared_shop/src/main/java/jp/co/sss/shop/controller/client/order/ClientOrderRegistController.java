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
import jp.co.sss.shop.bean.CouponBean;
import jp.co.sss.shop.bean.OrderItemBean;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Coupon;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.Order;
import jp.co.sss.shop.entity.OrderItem;
import jp.co.sss.shop.entity.PointHistory;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.form.OrderForm;
import jp.co.sss.shop.repository.CouponRepository;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.repository.OrderItemRepository;
import jp.co.sss.shop.repository.OrderRepository;
import jp.co.sss.shop.repository.PointHistoryRepository;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.service.PriceCalc;

/**
 * 注文登録用コントローラ
 *
 * @author SystemShared
 */
@Controller
public class ClientOrderRegistController {

	/**
	 * 商品情報リポジトリ
	 */
	@Autowired
	ItemRepository itemRepository;

	/**
	 * 注文情報リポジトリ
	 */
	@Autowired
	OrderRepository orderRepository;

	/**
	 * 会員情報リポジトリ
	 */
	@Autowired
	UserRepository userRepository;

	/**
	 * 注文商品リポジトリ
	 */
	@Autowired
	OrderItemRepository orderItemRepository;

	/**
	 * クーポン情報リポジトリ
	 */
	@Autowired
	CouponRepository couponRepository;

	/**
	 * 料金計算サービス
	 */
	@Autowired
	PriceCalc priceCalc;

	/**
	 * ポイント履歴情報リポジトリ
	 */
	@Autowired
	PointHistoryRepository pointHistoryRepository;

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
	 * * @param payMethod 選択された支払方法
	 * @param session セッション情報
	 * @param model viewへ渡すデータを保持するModel
	 * @return 注文確認画面
	 */
	@SuppressWarnings("unchecked")
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
			// 買い物かごの価格（セール適用済み）を使用
			orderItemBean.setPrice(basketBean.getSalePrice());
			orderItemBean.setImage(item.getImage());
			orderItemBean.setOrderNum(orderNum);

			int subtotal = basketBean.getSalePrice() * orderNum;
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

		// 【マージ対応：1箇所目】ポイント機能とクーポン機能のパラメータを統合して受け渡す
		// 会員の最新情報を取得（最新ポイント取得のため）
		UserBean userBean = (UserBean) session.getAttribute("user");
		User user = userRepository.getReferenceById(userBean.getId());
		model.addAttribute("currentPoint", user.getCurrentPoint());

		// クーポン割引の計算
		CouponBean couponBean = (CouponBean) session.getAttribute("coupon");
		if (couponBean != null) {
			int discount = priceCalc.calculateDiscount(total, couponBean);
			int discountedTotal = Math.max(0, total - discount);
			model.addAttribute("discount", discount);
			model.addAttribute("discountedTotal", discountedTotal);
		}

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
	@SuppressWarnings("unchecked")
	@PostMapping("/client/order/complete")
	public String showOrderComplete(@RequestParam(name = "usePoint", required = false) Integer usePoint,
			@RequestParam(name = "isConfirmed", required = false, defaultValue = "false") boolean isConfirmed,
			HttpSession session, Model model) {

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
			// 買い物かごの価格（セール適用済み）を使用
			orderItemBean.setPrice(basketBean.getSalePrice());
			orderItemBean.setImage(item.getImage());
			orderItemBean.setOrderNum(orderNum);

			int subtotal = basketBean.getSalePrice() * orderNum;
			orderItemBean.setSubtotal(subtotal);

			total += subtotal;

			orderItemBeans.add(orderItemBean);
			orderableBasketBeans.add(basketBean);
		}

		// クーポン割引の計算（ポイント利用上限の判定用）
		int discountedTotal = total;
		CouponBean couponBean = (CouponBean) session.getAttribute("coupon");
		if (couponBean != null) {
			int discount = priceCalc.calculateDiscount(total, couponBean);
			discountedTotal = Math.max(0, total - discount);
		}

		// ポイント関連のバリデーション
		User user = userRepository.getReferenceById(userBean.getId());
		int currentPoint = user.getCurrentPoint();

		if (usePoint == null) {
			usePoint = 0;
		}

		boolean pointError = false;
		if (usePoint < 0) {
			pointError = true;
		} else if (usePoint > currentPoint) {
			pointError = true;
		} else if (usePoint > discountedTotal) {
			pointError = true;
		}

		// 在庫切れ・在庫不足の商品があった場合、またはポイントにエラーがあった場合は、注文登録せず確認画面へ戻す
		if (!itemNameListZero.isEmpty() || !itemNameListLessThan.isEmpty() || pointError) {

			if (!itemNameListZero.isEmpty()) {
				model.addAttribute("itemNameListZero", itemNameListZero);
			}

			if (!itemNameListLessThan.isEmpty()) {
				model.addAttribute("itemNameListLessThan", itemNameListLessThan);
			}

			if (pointError) {
				model.addAttribute("pointError", true);
			}

			model.addAttribute("orderForm", orderForm);
			model.addAttribute("total", total);
			model.addAttribute("currentPoint", currentPoint);

			// クーポン割引の再計算
			if (couponBean != null) {
				int discount = priceCalc.calculateDiscount(total, couponBean);
				model.addAttribute("discount", discount);
				model.addAttribute("discountedTotal", discountedTotal);
			}

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

		// ポイント利用がある場合、未確認なら確認画面へ
		if (usePoint > 0 && !isConfirmed) {
			model.addAttribute("total", total);
			model.addAttribute("discountedTotal", discountedTotal);
			model.addAttribute("usePoint", usePoint);
			return "client/order/point_confirm";
		}

		// ここから下は、在庫に問題がない場合だけ注文登録

		Order order = new Order();

		order.setPostalCode(orderForm.getPostalCode());
		order.setAddress(orderForm.getAddress());
		order.setName(orderForm.getName());
		order.setPhoneNumber(orderForm.getPhoneNumber());
		order.setPayMethod(orderForm.getPayMethod());
		order.setUsedPoint(usePoint);
		order.setPaymentAmount(discountedTotal - usePoint);

		User orderUser = new User();
		orderUser.setId(userBean.getId());
		order.setUser(orderUser);

		// クーポン情報の適用
		if (couponBean != null) {
			Coupon coupon = couponRepository.getReferenceById(couponBean.getId());
			order.setCoupon(coupon);

			int discount = priceCalc.calculateDiscount(total, couponBean);
			order.setDiscount(discount);

			// 使用回数のデクリメント
			if (coupon.getUsageLimit() != null) {
				coupon.setUsageLimit(coupon.getUsageLimit() - 1);
				couponRepository.save(coupon);
			}
		}

		orderRepository.save(order);

		// ポイント利用減算処理
		if (usePoint > 0) {
			user.setCurrentPoint(user.getCurrentPoint() - usePoint);
			userRepository.save(user);

			// ポイント履歴登録（利用）
			PointHistory useHistory = new PointHistory();
			useHistory.setUser(user);
			useHistory.setPoint(-usePoint);
			useHistory.setBalance(user.getCurrentPoint());
			useHistory.setType("USE");
			useHistory.setDescription("ポイント利用");
			pointHistoryRepository.save(useHistory);
		}

		for (BasketBean basketBean : orderableBasketBeans) {

			Item item = itemRepository.getReferenceById(basketBean.getId());

			OrderItem orderItem = new OrderItem();

			orderItem.setOrder(order);
			orderItem.setItem(item);
			orderItem.setQuantity(basketBean.getOrderNum());
			// 買い物かごの価格（セール適用済み）を保存
			orderItem.setPrice(basketBean.getSalePrice());

			orderItemRepository.save(orderItem);

			// 在庫数を減らす
			item.setStock(item.getStock() - basketBean.getOrderNum());
			itemRepository.save(item);
		}

		// 【マージ対応：2箇所目】ポイント付与処理とガチャ機能用セッション設定の競合を解決
		// ポイント付与加算処理（ポイント機能ブランチの処理）
		int paymentAmount = discountedTotal - usePoint;
		int earnPoint = paymentAmount / 10;
		if (earnPoint > 0) {
			user.setCurrentPoint(user.getCurrentPoint() + earnPoint);
			userRepository.save(user);

			// ポイント履歴登録（獲得）
			PointHistory earnHistory = new PointHistory();
			earnHistory.setUser(user);
			earnHistory.setPoint(earnPoint);
			earnHistory.setBalance(user.getCurrentPoint());
			earnHistory.setType("EARN");
			earnHistory.setDescription("商品購入");
			pointHistoryRepository.save(earnHistory);
		}

		// セッションのユーザー情報を更新
		org.springframework.beans.BeanUtils.copyProperties(user, userBean);
		session.setAttribute("user", userBean);

		// ガチャ実行権限をセッションに設定 (devブランチの処理)
		session.setAttribute("canPlayGacha", true);
		session.setAttribute("gachaEventType", "order");
		session.setAttribute("gachaSourceOrderId", order.getId());

		// 不要なセッションのクリーンアップ
		session.removeAttribute("basketBeans");
		session.removeAttribute("orderForm");
		session.removeAttribute("coupon");

		return "client/order/complete";
	}

	/**
	 * ポイント確認画面から注文確認画面へ戻る
	 * @param usePoint 利用ポイント
	 * @param session セッション情報
	 * @param model viewへ渡すデータを保持するModel
	 * @return 注文確認画面
	 */
	@SuppressWarnings("unchecked")
	@PostMapping("/client/order/complete/back")
	public String backToCheck(@RequestParam(name = "usePoint", required = false) Integer usePoint,
			HttpSession session, Model model) {

		// セッションから情報を再取得してcheckメソッドと同じ状態を作る
		// (checkメソッドを直接呼ぶのは引数が違うため難しいので、必要な情報をモデルに積む)

		// お届け先入力画面で保存したorderForm取り出し
		OrderForm orderForm = (OrderForm) session.getAttribute("orderForm");
		// 買い物かごの商品リスト取り出し
		List<BasketBean> basketBeans = (List<BasketBean>) session.getAttribute("basketBeans");

		List<OrderItemBean> orderItemBeans = new ArrayList<>();
		int total = 0;

		for (BasketBean basketBean : basketBeans) {
			Item item = itemRepository.getReferenceById(basketBean.getId());
			OrderItemBean orderItemBean = new OrderItemBean();
			orderItemBean.setId(item.getId());
			orderItemBean.setName(item.getName());
			orderItemBean.setPrice(basketBean.getSalePrice());
			orderItemBean.setImage(item.getImage());
			orderItemBean.setOrderNum(basketBean.getOrderNum());
			int subtotal = basketBean.getSalePrice() * basketBean.getOrderNum();
			orderItemBean.setSubtotal(subtotal);
			total += subtotal;
			orderItemBeans.add(orderItemBean);
		}

		model.addAttribute("orderForm", orderForm);
		model.addAttribute("total", total);
		model.addAttribute("orderItemBeans", orderItemBeans);

		// クーポン割引の再計算とモデルへの追加
		CouponBean couponBean = (CouponBean) session.getAttribute("coupon");
		if (couponBean != null) {
			int discount = priceCalc.calculateDiscount(total, couponBean);
			int discountedTotal = Math.max(0, total - discount);
			model.addAttribute("discount", discount);
			model.addAttribute("discountedTotal", discountedTotal);
		}

		UserBean userBean = (UserBean) session.getAttribute("user");
		User user = userRepository.getReferenceById(userBean.getId());
		model.addAttribute("currentPoint", user.getCurrentPoint());

		// 戻った際、以前入力していたポイントを反映させるためにフォームにセットする等の対応が必要だが、
		// 現在のHTML側はvalue="0"固定なので、モデル等で渡してJavaScriptでセットする必要があるかもしれない。
		// ここでは要件に基づき、戻るボタンの動作を優先する。
		model.addAttribute("prevUsePoint", usePoint);

		return "client/order/check";
	}

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