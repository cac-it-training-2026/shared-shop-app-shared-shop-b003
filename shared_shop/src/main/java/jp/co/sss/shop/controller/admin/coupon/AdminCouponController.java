package jp.co.sss.shop.controller.admin.coupon;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import jp.co.sss.shop.entity.Coupon;
import jp.co.sss.shop.repository.CouponRepository;

/**
 * クーポン管理コントローラ
 */
@Controller
public class AdminCouponController {
    @Autowired
    CouponRepository couponRepository;

    /**
     * クーポン一覧表示
     */
    @RequestMapping(path = "/admin/coupon/list", method = { RequestMethod.GET, RequestMethod.POST })
    public String showCouponList(Model model) {
        List<Coupon> couponList = couponRepository.findAll();
        model.addAttribute("coupons", couponList);
        return "admin/coupon/list";
    }

    /**
     * クーポン登録画面表示
     */
    @RequestMapping(path = "/admin/coupon/regist/input", method = RequestMethod.GET)
    public String registInput(Model model) {
        model.addAttribute("coupon", new Coupon());
        return "admin/coupon/regist_input";
    }

    /**
     * クーポン登録処理
     */
    @RequestMapping(path = "/admin/coupon/regist/complete", method = RequestMethod.POST)
    public String registComplete(Coupon coupon, String validFromStr, String validUntilStr, Model model) {
        // バリデーション
        if (coupon.getCode() == null || coupon.getCode().isEmpty()) {
            model.addAttribute("error", "クーポンコードは必須です。");
            model.addAttribute("coupon", coupon);
            return "admin/coupon/regist_input";
        }
        if (couponRepository.findByCode(coupon.getCode()) != null) {
            model.addAttribute("error", "このクーポンコードは既に使用されています。");
            model.addAttribute("coupon", coupon);
            return "admin/coupon/regist_input";
        }
        if (coupon.getDiscountValue() == null || coupon.getDiscountValue() <= 0) {
            model.addAttribute("error", "割引値は正の数で入力してください。");
            model.addAttribute("coupon", coupon);
            return "admin/coupon/regist_input";
        }
        if ("percent".equals(coupon.getDiscountType()) && coupon.getDiscountValue() > 100) {
            model.addAttribute("error", "割合割引の場合、100%を超える値は指定できません。");
            model.addAttribute("coupon", coupon);
            return "admin/coupon/regist_input";
        }

        DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
        Timestamp validFrom = null;
        Timestamp validUntil = null;

        if (validFromStr != null && !validFromStr.isEmpty()) {
            validFrom = Timestamp.valueOf(LocalDateTime.parse(validFromStr, formatter));
        }
        if (validUntilStr != null && !validUntilStr.isEmpty()) {
            validUntil = Timestamp.valueOf(LocalDateTime.parse(validUntilStr, formatter));
        }

        if (validFrom != null && validUntil != null && validUntil.before(validFrom)) {
            model.addAttribute("error", "有効期限(終了)は有効期限(開始)より後の日時を指定してください。");
            model.addAttribute("coupon", coupon);
            return "admin/coupon/regist_input";
        }

        coupon.setValidFrom(validFrom);
        coupon.setValidUntil(validUntil);

        couponRepository.save(coupon);
        return "redirect:/admin/coupon/list";
    }
}
