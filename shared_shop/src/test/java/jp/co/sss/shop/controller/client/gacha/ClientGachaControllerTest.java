package jp.co.sss.shop.controller.client.gacha;

import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Coupon;
import jp.co.sss.shop.repository.CouponRepository;

public class ClientGachaControllerTest {

	private MockMvc mockMvc;

	@Mock
	private CouponRepository couponRepository;

	@Mock
	private HttpSession session;

	@InjectMocks
	private ClientGachaController clientGachaController;

	@BeforeEach
	public void setup() {
		MockitoAnnotations.openMocks(this);
		mockMvc = MockMvcBuilders.standaloneSetup(clientGachaController).build();
	}

	@Test
	public void testIndex_LoggedIn() throws Exception {
		UserBean userBean = new UserBean();
		userBean.setId(1);

		mockMvc.perform(get("/client/gacha").sessionAttr("user", userBean))
				.andExpect(status().isOk())
				.andExpect(view().name("client/gacha/index"));
	}

	@Test
	public void testIndex_NotLoggedIn() throws Exception {
		mockMvc.perform(get("/client/gacha"))
				.andExpect(status().is3xxRedirection())
				.andExpect(redirectedUrl("/login"));
	}

	@Test
	public void testSpin_Win() throws Exception {
		UserBean userBean = new UserBean();
		userBean.setId(1);

		List<Coupon> coupons = new ArrayList<>();
		Coupon coupon = new Coupon();
		coupon.setCode("WINNER");
		coupons.add(coupon);

		when(couponRepository.findValidCoupons()).thenReturn(coupons);

		mockMvc.perform(post("/client/gacha/spin").sessionAttr("user", userBean))
				.andExpect(status().isOk())
				.andExpect(view().name("client/gacha/result"))
				.andExpect(model().attributeExists("coupon"))
				.andExpect(model().attribute("coupon", coupon));
	}

	@Test
	public void testSpin_NoCoupons() throws Exception {
		UserBean userBean = new UserBean();
		userBean.setId(1);

		when(couponRepository.findValidCoupons()).thenReturn(new ArrayList<>());

		mockMvc.perform(post("/client/gacha/spin").sessionAttr("user", userBean))
				.andExpect(status().isOk())
				.andExpect(view().name("client/gacha/result"))
				.andExpect(model().attributeExists("message"));
	}
}
