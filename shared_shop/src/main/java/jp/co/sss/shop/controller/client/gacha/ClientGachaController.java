package jp.co.sss.shop.controller.client.gacha;

import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Coupon;
import jp.co.sss.shop.entity.GachaLog;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.repository.CouponRepository;
import jp.co.sss.shop.repository.GachaLogRepository;

/**
 * ガチャ機能のコントローラクラス
 */
@Controller
public class ClientGachaController {

	@Autowired
	GachaLogRepository gachaLogRepository;

	@Autowired
	CouponRepository couponRepository;

	@Autowired
	HttpSession session;

	/**
	 * ガチャを引く処理
	 * @return トップ画面へのリダイレクト
	 */
	@RequestMapping(path = "/client/gacha/play", method = RequestMethod.POST)
	public String playGacha() {

		UserBean userBean = (UserBean) session.getAttribute("user");
		if (userBean == null) {
			return "redirect:/login";
		}

		// 簡単なガチャロジック: ランダムでクーポンを取得するか外れるか
		Random random = new Random();
		int chance = random.nextInt(100);

		GachaLog log = new GachaLog();
		User user = new User();
		user.setId(userBean.getId());
		log.setUser(user);
		log.setEventType("login"); // 便宜上loginイベントとする

		if (chance < 30) {
			// 30%の確率で当たる (クーポンをランダムに1つ選ぶ)
			List<Coupon> allCoupons = couponRepository.findAll();
			if (!allCoupons.isEmpty()) {
				Coupon wonCoupon = allCoupons.get(random.nextInt(allCoupons.size()));
				log.setOutcome("win");
				log.setCoupon(wonCoupon);
				session.setAttribute("gachaResult", "当たり！クーポンコード「" + wonCoupon.getCode() + "」を獲得しました！");
			} else {
				// クーポンが未登録の場合はハズレ扱い
				log.setOutcome("lose");
				session.setAttribute("gachaResult", "ハズレ...");
			}
		} else {
			// 70%の確率でハズレ
			log.setOutcome("lose");
			session.setAttribute("gachaResult", "ハズレ...");
		}

		gachaLogRepository.save(log);

		return "redirect:/";
	}
}
