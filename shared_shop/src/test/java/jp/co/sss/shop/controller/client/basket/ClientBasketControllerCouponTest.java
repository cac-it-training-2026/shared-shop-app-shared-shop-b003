package jp.co.sss.shop.controller.client.basket;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.sql.Timestamp;
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
import jp.co.sss.shop.entity.Coupon;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.repository.CouponRepository;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.service.PriceCalc;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.bean.UserBean;

public class ClientBasketControllerCouponTest {

    @InjectMocks
    private ClientBasketController controller;

    @Mock
    private CouponRepository couponRepository;

    @Mock
    private ItemRepository itemRepository;

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
    public void testApplyValidAmountCoupon() {
        // Arrange
        String code = "SAVE100";
        Coupon coupon = new Coupon();
        coupon.setId(1);
        coupon.setCode(code);
        coupon.setDiscountType("amount");
        coupon.setDiscountValue(100);

        when(session.getAttribute("user")).thenReturn(new UserBean());
        when(couponRepository.findByCode(code)).thenReturn(coupon);

        // Act
        String viewName = controller.applyCoupon(code, model);

        // Assert
        assertEquals("redirect:/client/basket/list", viewName);
        ArgumentCaptor<CouponBean> captor = ArgumentCaptor.forClass(CouponBean.class);
        verify(session).setAttribute(eq("coupon"), captor.capture());
        assertEquals(code, captor.getValue().getCode());
        assertEquals("amount", captor.getValue().getDiscountType());
        assertEquals(100, captor.getValue().getDiscountValue());
    }

    @Test
    public void testApplyInvalidCoupon() {
        // Arrange
        String code = "INVALID";
        when(session.getAttribute("user")).thenReturn(new UserBean());
        when(couponRepository.findByCode(code)).thenReturn(null);

        // Act
        controller.applyCoupon(code, model);

        // Assert
        verify(session).setAttribute(eq("couponError"), anyString());
        verify(session, never()).setAttribute(eq("coupon"), any());
    }

    @Test
    public void testDiscountCalculationInList() {
        // Arrange
        List<BasketBean> basket = new ArrayList<>();
        BasketBean basketBean = new BasketBean();
        basketBean.setId(1);
        basketBean.setPrice(1000);
        basketBean.setOrderNum(2);
        basket.add(basketBean);

        Item item = new Item();
        item.setId(1);
        item.setPrice(1000);
        item.setStock(10);
        item.setDeleteFlag(0);
        when(itemRepository.findById(1)).thenReturn(java.util.Optional.of(item));

        CouponBean coupon = new CouponBean();
        coupon.setDiscountType("percent");
        coupon.setDiscountValue(10); // 10% off

        UserBean user = new UserBean();
        user.setId(1);
        when(session.getAttribute("user")).thenReturn(user);
        when(session.getAttribute("basketBeans")).thenReturn(basket);
        when(session.getAttribute("coupon")).thenReturn(coupon);
        when(priceCalc.calculateDiscount(2000, coupon)).thenReturn(200);

        // Act
        controller.showBasketList(model);

        // Assert
        verify(model).addAttribute("total", 2000);
        verify(model).addAttribute("discount", 200);
        verify(model).addAttribute("discountedTotal", 1800);
    }
}
