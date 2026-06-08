package jp.co.sss.shop.controller.client.order;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import jp.co.sss.shop.entity.Order;
import jp.co.sss.shop.entity.OrderItem;
import jp.co.sss.shop.repository.OrderItemRepository;
import jp.co.sss.shop.repository.OrderRepository;

@Controller
public class ClientOrderShowController {

	@Autowired
	OrderRepository orderRepository;

	@Autowired
	OrderItemRepository orderItemRepository;

	/*
	 * 注文詳細画面のビューを表示
	 */
	@PostMapping("/client/order/list")
	public String showOrderList(Model model) {

		List<Order> orders = orderRepository.findAll();

		model.addAttribute("orders", orders);

		return "client/order/list";
	}

	/*
	 * 注文詳細を表示
	 * @param id
	 */
	@GetMapping("/client/order/detail/{id}")
	public String showUserDetail(Model model, @PathVariable int id) {

		Order order = orderRepository.getReferenceById(id);

		List<OrderItem> orderItemList = orderItemRepository.findByOrderId(id);

		model.addAttribute("order", order);
		model.addAttribute("orderItemList", orderItemList);

		return "client/order/detail";
	}
}
