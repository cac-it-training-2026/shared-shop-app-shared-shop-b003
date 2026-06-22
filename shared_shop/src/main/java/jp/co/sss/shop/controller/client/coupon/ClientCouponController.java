package jp.co.sss.shop.controller.client.coupon;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Coupon;
import jp.co.sss.shop.repository.CouponRepository;

/**
 * 一般会員用クーポン一覧コントローラ
 */
@Controller
public class ClientCouponController {

	@Autowired
	private CouponRepository couponRepository;

	@Autowired
	private HttpSession session;

	/**
	 * 所持クーポン一覧表示
	 *
	 * @param model Viewとの値受渡し
	 * @return "client/coupon/list" クーポン一覧画面
	 */
	@RequestMapping(path = "/client/coupon/list", method = { RequestMethod.GET, RequestMethod.POST })
	public String showCouponList(Model model) {
		UserBean userBean = (UserBean) session.getAttribute("user");
		if (userBean == null) {
			return "redirect:/login";
		}

		List<Coupon> coupons = couponRepository.findValidCouponsByUserId(userBean.getId());
		model.addAttribute("coupons", coupons);

		return "client/coupon/list";
	}
}
