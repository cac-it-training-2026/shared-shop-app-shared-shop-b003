package jp.co.sss.shop.controller.client.gacha;

import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Coupon;
import jp.co.sss.shop.repository.CouponRepository;

/**
 * ガチャ機能のコントローラクラス
 */
@Controller
public class ClientGachaController {

	/**
	 * クーポン情報リポジトリ
	 */
	@Autowired
	CouponRepository couponRepository;

	/**
	 * ガチャ画面表示
	 *
	 * @return "client/gacha/index" ガチャ画面
	 */
	@GetMapping("/client/gacha")
	public String index(HttpSession session) {
		// ログインチェック
		UserBean userBean = (UserBean) session.getAttribute("user");
		if (userBean == null) {
			return "redirect:/login";
		}

		return "client/gacha/index";
	}

	/**
	 * ガチャ実行
	 *
	 * @param model Viewへ渡すデータを保持するModel
	 * @return "client/gacha/result" ガチャ結果画面
	 */
	@PostMapping("/client/gacha/spin")
	public String spin(Model model, HttpSession session) {
		// ログインチェック
		UserBean userBean = (UserBean) session.getAttribute("user");
		if (userBean == null) {
			return "redirect:/login";
		}

		// 有効なクーポンを取得
		List<Coupon> validCoupons = couponRepository.findValidCoupons();

		if (validCoupons.isEmpty()) {
			model.addAttribute("message", "現在、引けるクーポンがありません。");
			return "client/gacha/result";
		}

		// ランダムに1つ選択
		Random random = new Random();
		Coupon wonCoupon = validCoupons.get(random.nextInt(validCoupons.size()));

		model.addAttribute("coupon", wonCoupon);

		return "client/gacha/result";
	}
}
