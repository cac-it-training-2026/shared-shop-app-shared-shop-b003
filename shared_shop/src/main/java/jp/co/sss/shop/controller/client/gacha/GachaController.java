package jp.co.sss.shop.controller.client.gacha;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Coupon;
import jp.co.sss.shop.service.GachaService;

/**
 * ガチャ処理用コントローラ
 *
 * @author Jules
 */
@Controller
public class GachaController {

	@Autowired
	private GachaService gachaService;

	@Autowired
	private HttpSession session;

	/**
	 * ガチャを実行する (非同期通信用)
	 *
	 * @param request HTTPリクエスト
	 * @return ガチャの結果 (JSON)
	 */
	@RequestMapping(path = "/client/gacha/play", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> playGacha(HttpServletRequest request) {
		Map<String, Object> result = new HashMap<>();

		// 権限チェック
		Boolean canPlay = (Boolean) session.getAttribute("canPlayGacha");
		UserBean userBean = (UserBean) session.getAttribute("user");

		if (canPlay == null || !canPlay || userBean == null) {
			result.put("status", "error");
			result.put("message", "ガチャを回す権限がありません。");
			return result;
		}

		String eventType = (String) session.getAttribute("gachaEventType");
		Integer sourceOrderId = (Integer) session.getAttribute("gachaSourceOrderId");
		String ipAddress = request.getRemoteAddr();

		// ガチャ実行
		Coupon wonCoupon = gachaService.playGacha(userBean.getId(), eventType, sourceOrderId, ipAddress);

		// 権限消費
		session.removeAttribute("canPlayGacha");
		session.removeAttribute("gachaEventType");
		session.removeAttribute("gachaSourceOrderId");

		if (wonCoupon != null) {
			result.put("status", "win");
			result.put("couponCode", wonCoupon.getCode());
			result.put("discountType", wonCoupon.getDiscountType());
			result.put("discountValue", wonCoupon.getDiscountValue());
		} else {
			result.put("status", "lose");
		}

		return result;
	}

	/**
	 * ガチャをキャンセルする (セッション情報を削除)
	 *
	 * @return ステータス (JSON)
	 */
	@RequestMapping(path = "/client/gacha/cancel", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancelGacha() {
		Map<String, Object> result = new HashMap<>();

		session.removeAttribute("canPlayGacha");
		session.removeAttribute("gachaEventType");
		session.removeAttribute("gachaSourceOrderId");

		result.put("status", "success");
		return result;
	}
}
