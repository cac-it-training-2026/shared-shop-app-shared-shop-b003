package jp.co.sss.shop.controller.client.order;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.ui.Model;

import jp.co.sss.shop.bean.BasketBean;
import jp.co.sss.shop.bean.CouponBean;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Order;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.repository.OrderRepository;
import jp.co.sss.shop.repository.OrderItemRepository;
import jp.co.sss.shop.repository.CouponRepository;
import jp.co.sss.shop.entity.Coupon;
import jp.co.sss.shop.service.PriceCalc;
import jp.co.sss.shop.form.OrderForm;

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
    public void testOrderRegistrationWithCoupon() {
        // Arrange
        OrderForm orderForm = new OrderForm();
        orderForm.setPostalCode("123-4567");
        orderForm.setAddress("Test Address");
        orderForm.setName("Test Name");
        orderForm.setPhoneNumber("090-1234-5678");
        orderForm.setPayMethod(1);

        List<BasketBean> basket = new ArrayList<>();
        BasketBean itemBean = new BasketBean();
        itemBean.setId(1);
        itemBean.setOrderNum(1);
        itemBean.setPrice(1000);
        basket.add(itemBean);

        UserBean userBean = new UserBean();
        userBean.setId(1);

        CouponBean couponBean = new CouponBean();
        couponBean.setId(1);
        couponBean.setCode("SAVE100");
        couponBean.setDiscountType("amount");
        couponBean.setDiscountValue(100);

        when(session.getAttribute("orderForm")).thenReturn(orderForm);
        when(session.getAttribute("basketBeans")).thenReturn(basket);
        when(session.getAttribute("user")).thenReturn(userBean);
        when(session.getAttribute("coupon")).thenReturn(couponBean);
        Coupon coupon = new Coupon();
        coupon.setId(1);
        coupon.setUsageLimit(5);
        when(couponRepository.getReferenceById(1)).thenReturn(coupon);
        when(priceCalc.calculateDiscount(1000, couponBean)).thenReturn(100);

        Item item = new Item();
        item.setId(1);
        item.setStock(10);
        item.setPrice(1000);
        item.setDeleteFlag(0);
        item.setName("Test Item");
        when(itemRepository.getReferenceById(1)).thenReturn(item);

        // Act
        String viewName = controller.showOrderComplete(session, model);

        // Assert
        assertEquals("client/order/complete", viewName);
        ArgumentCaptor<Order> orderCaptor = ArgumentCaptor.forClass(Order.class);
        verify(orderRepository).save(orderCaptor.capture());

        Order savedOrder = orderCaptor.getValue();
        assertNotNull(savedOrder.getCoupon());
        assertEquals(1, savedOrder.getCoupon().getId());
        assertEquals(100, savedOrder.getDiscount());
        verify(session).removeAttribute("coupon");
    }
}
