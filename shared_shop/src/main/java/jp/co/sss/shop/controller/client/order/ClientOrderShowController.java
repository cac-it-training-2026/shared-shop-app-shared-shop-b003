package jp.co.sss.shop.controller.client.order;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.OrderItemBean;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Order;
import jp.co.sss.shop.entity.OrderItem;
import jp.co.sss.shop.repository.OrderItemRepository;
import jp.co.sss.shop.repository.OrderRepository;

/**
 * 注文一覧表示のコントローラー
 * @author hayato takahashi
 */
@Controller

public class ClientOrderShowController {

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
	 * 注文一覧画面を表示
	 *
	 * @param model Viewへ渡すデータを保持するModel
	 * @return 注文一覧画面
	 */

	//普通に開くとき→GET、詳細画面から戻るとき→POST
	@RequestMapping(path = "/client/order/list", method = { RequestMethod.GET, RequestMethod.POST })
	public String showOrderList(Model model, HttpSession session) {

		UserBean userBean = (UserBean) session.getAttribute("user");
		if (userBean == null) {
			return "redirect:/login";
		}

		List<Order> orders = orderRepository.findByUserId(userBean.getId());
		model.addAttribute("orders", orders);

		return "client/order/list";
	}

	/**
	 * 指定された注文IDの注文詳細画面を表示
	 *
	 * @param id 注文ID
	 * @param model viewへ渡すデータを保持するModel
	 * @return 注文詳細画面
	 */
	@GetMapping("/client/order/detail/{id}")
	public String showOrderDetail(Model model, @PathVariable int id, HttpSession session) {

		// ログインチェック
		UserBean userBean = (UserBean) session.getAttribute("user");
		if (userBean == null) {
			return "redirect:/login";
		}

		// IDから注文情報を取得
		Order order = orderRepository.getReferenceById(id);

		// 注文IDに紐づく注文商品を取得
		List<OrderItem> orderItemList = orderItemRepository.findByOrderId(id);

		// HTML表示用の空の商品リスト作成
		List<OrderItemBean> orderItemBeans = new ArrayList<>();

		int total = 0;

		// 注文商品情報を１件ずつBeanに移し替える
		for (OrderItem orderItem : orderItemList) {

			OrderItemBean orderItemBean = new OrderItemBean();

			orderItemBean.setId(orderItem.getId());
			orderItemBean.setName(orderItem.getItem().getName());
			orderItemBean.setPrice(orderItem.getPrice());
			orderItemBean.setOrderNum(orderItem.getQuantity());

			int subtotal = orderItem.getPrice() * orderItem.getQuantity();
			orderItemBean.setSubtotal(subtotal);

			total += subtotal;

			orderItemBeans.add(orderItemBean);
		}

		// order→ 注文日、支払方法、届け先情報
		// orderItemBeans→ 商品名、単価、数量、小計
		// total→ 合計金額
		model.addAttribute("order", order);
		model.addAttribute("orderItemBeans", orderItemBeans);
		model.addAttribute("total", total);

		return "client/order/detail";
	}
}
