package jp.co.sss.shop.controller.client.order;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.repository.PointHistoryRepository;
import jp.co.sss.shop.entity.User;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.ui.Model;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.BasketBean;
import jp.co.sss.shop.bean.CouponBean;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Coupon;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.Order;
import jp.co.sss.shop.form.OrderForm;
import jp.co.sss.shop.repository.CouponRepository;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.repository.OrderItemRepository;
import jp.co.sss.shop.repository.OrderRepository;
import jp.co.sss.shop.service.PriceCalc;

public class ClientOrderRegistControllerCouponTest {

	@InjectMocks
	private ClientOrderRegistController controller;

	@Mock
	private OrderRepository orderRepository;

	@Mock
	private ItemRepository itemRepository;

	@Mock
	private OrderItemRepository orderItemRepository;

	@Mock
	private CouponRepository couponRepository;

	@Mock
	private UserRepository userRepository;

	@Mock
	private PointHistoryRepository pointHistoryRepository;

	@Mock
	private PriceCalc priceCalc;

	@Mock
	private HttpSession session;

	@Mock
	private Model model;

	@BeforeEach
	public void setup() {
		MockitoAnnotations.openMocks(this);
	}

	@Test
	public void testOrderRegistrationWithCouponDecrementsLimit() {
		// Arrange
		OrderForm orderForm = new OrderForm();
		orderForm.setPayMethod(1);

		List<BasketBean> basket = new ArrayList<>();
		BasketBean itemBean = new BasketBean();
		itemBean.setId(1);
		itemBean.setOrderNum(1);
		itemBean.setPrice(1000);
		itemBean.setSalePrice(1000); // タイムセール適用後の価格をセット
		basket.add(itemBean);

		UserBean userBean = new UserBean();
		userBean.setId(1);

		CouponBean couponBean = new CouponBean();
		couponBean.setId(1);
		couponBean.setDiscountType("amount");
		couponBean.setDiscountValue(100);

		Coupon coupon = new Coupon();
		coupon.setId(1);
		coupon.setUsageLimit(5);

		when(session.getAttribute("orderForm")).thenReturn(orderForm);
		when(session.getAttribute("basketBeans")).thenReturn(basket);
		when(session.getAttribute("user")).thenReturn(userBean);
		when(session.getAttribute("coupon")).thenReturn(couponBean);
		when(couponRepository.getReferenceById(1)).thenReturn(coupon);
		when(priceCalc.calculateDiscount(1000, couponBean)).thenReturn(100);

		User user = new User();
		user.setId(1);
		user.setCurrentPoint(100);
		when(userRepository.getReferenceById(1)).thenReturn(user);

		Item item = new Item();
		item.setId(1);
		item.setStock(10);
		item.setPrice(1000);
		item.setDeleteFlag(0);
		item.setName("Test Item");
		when(itemRepository.getReferenceById(1)).thenReturn(item);

		// Act
		controller.showOrderComplete(0, false, session, model);

		// Assert
		ArgumentCaptor<Coupon> couponCaptor = ArgumentCaptor.forClass(Coupon.class);
		verify(couponRepository).save(couponCaptor.capture());
		assertEquals(4, couponCaptor.getValue().getUsageLimit());

		ArgumentCaptor<Order> orderCaptor = ArgumentCaptor.forClass(Order.class);
		verify(orderRepository).save(orderCaptor.capture());
		Order savedOrder = orderCaptor.getValue();
		assertEquals(100, savedOrder.getDiscount());
	}
}
