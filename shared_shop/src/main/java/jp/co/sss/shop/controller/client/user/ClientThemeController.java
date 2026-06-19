package jp.co.sss.shop.controller.client.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.util.Constant;

/**
 * 着せ替え機能（テーマ変更）のコントローラークラス
 */
@Controller
public class ClientThemeController {

	/**
	 * 会員情報 リポジトリ
	 */
	@Autowired
	UserRepository userRepository;

	/**
	 * セッション情報
	 */
	@Autowired
	HttpSession session;

	/**
	 * テーマ一覧表示処理
	 */
	@RequestMapping(path = "/client/theme/list", method = { RequestMethod.GET, RequestMethod.POST })
	public String showThemeList(Model model) {
		UserBean userBean = (UserBean) session.getAttribute("user");
		if (userBean == null) {
			return "redirect:/login";
		}

		User user = userRepository.findByIdAndDeleteFlag(userBean.getId(), Constant.NOT_DELETED);
		if (user == null) {
			return "redirect:/login";
		}

		model.addAttribute("purchaseCount", user.getPurchaseCount() != null ? user.getPurchaseCount() : 0);
		model.addAttribute("totalPurchaseAmount", user.getTotalPurchaseAmount() != null ? user.getTotalPurchaseAmount() : 0);
		model.addAttribute("currentThemeId", user.getThemeId() != null ? user.getThemeId() : 0);

		return "client/user/theme_list";
	}

	/**
	 * テーマ変更処理
	 */
	@RequestMapping(path = "/client/theme/change", method = RequestMethod.POST)
	public String changeTheme(Integer themeId) {
		UserBean userBean = (UserBean) session.getAttribute("user");
		if (userBean == null) {
			return "redirect:/login";
		}

		User user = userRepository.findByIdAndDeleteFlag(userBean.getId(), Constant.NOT_DELETED);
		if (user == null) {
			return "redirect:/login";
		}

		// 解放条件チェック
		int purchaseCount = user.getPurchaseCount() != null ? user.getPurchaseCount() : 0;
		int totalAmount = user.getTotalPurchaseAmount() != null ? user.getTotalPurchaseAmount() : 0;
		boolean isAvailable = false;

		switch (themeId) {
		case 0: // 通常
			isAvailable = true;
			break;
		case 1: // さくら (1回以上)
			if (purchaseCount >= 1) isAvailable = true;
			break;
		case 2: // 海 (3回以上)
			if (purchaseCount >= 3) isAvailable = true;
			break;
		case 3: // ゲーム (5回以上)
			if (purchaseCount >= 5) isAvailable = true;
			break;
		case 4: // 宇宙 (10,000円以上)
			if (totalAmount >= 10000) isAvailable = true;
			break;
		case 5: // ゴールド (10回以上)
			if (purchaseCount >= 10) isAvailable = true;
			break;
		case 6: // P3tech (20回以上)
			if (purchaseCount >= 20) isAvailable = true;
			break;
		}

		if (isAvailable) {
			user.setThemeId(themeId);
			userRepository.save(user);

			// セッション更新
			userBean.setThemeId(themeId);
			String themeClass = "theme-normal";
			switch (themeId) {
			case 1: themeClass = "theme-sakura"; break;
			case 2: themeClass = "theme-ocean"; break;
			case 3: themeClass = "theme-game"; break;
			case 4: themeClass = "theme-space"; break;
			case 5: themeClass = "theme-gold"; break;
			case 6: themeClass = "theme-p3tech"; break;
			}
			userBean.setThemeClass(themeClass);
			session.setAttribute("user", userBean);
		}

		return "redirect:/client/theme/list";
	}
}
