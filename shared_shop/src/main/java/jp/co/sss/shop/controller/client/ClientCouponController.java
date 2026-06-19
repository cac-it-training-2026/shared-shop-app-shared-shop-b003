package jp.co.sss.shop.controller.client;

import java.util.List;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.UserCoupon;
import jp.co.sss.shop.repository.UserCouponRepository;

@Controller
public class ClientCouponController {

    @Autowired
    private UserCouponRepository userCouponRepository;

    @GetMapping("/client/coupon/list")
    public String showCouponList(HttpSession session, Model model) {
        UserBean userBean = (UserBean) session.getAttribute("user");
        if (userBean == null) {
            return "redirect:/login";
        }

        List<UserCoupon> userCoupons = userCouponRepository.findByUserIdAndUsedFlag(userBean.getId(), 0);
        model.addAttribute("userCoupons", userCoupons);
        return "client/coupon/list";
    }
}
