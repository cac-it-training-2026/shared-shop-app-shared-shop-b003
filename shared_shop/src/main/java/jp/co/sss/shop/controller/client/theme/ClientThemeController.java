package jp.co.sss.shop.controller.client.theme;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.repository.UserRepository;

/**
 * 着せ替え機能のコントローラー
 */
@Controller
public class ClientThemeController {

	/**
	 * 会員情報リポジトリ
	 */
	@Autowired
	UserRepository userRepository;

	/**
	 * 着せ替え設定画面を表示する
	 *
	 * @param session セッション情報
	 * @param model モデル
	 * @return 着せ替え設定画面
	 */
	@GetMapping("/client/theme/list")
	public String showThemeList(HttpSession session, Model model) {

		UserBean userBean = (UserBean) session.getAttribute("user");

		if (userBean == null) {
			return "redirect:/login";
		}

		Integer purchaseCount = userBean.getPurchaseCount();
		Integer totalPurchaseAmount = userBean.getTotalPurchaseAmount();

		if (purchaseCount == null) {
			purchaseCount = 0;
		}

		if (totalPurchaseAmount == null) {
			totalPurchaseAmount = 0;
		}

		model.addAttribute("themeId", userBean.getThemeId());
		model.addAttribute("purchaseCount", purchaseCount);
		model.addAttribute("totalPurchaseAmount", totalPurchaseAmount);

		return "client/theme/list";
	}

	/**
	 * 選択したテーマを反映する
	 *
	 * @param themeId テーマID
	 * @param session セッション情報
	 * @return 着せ替え設定画面へリダイレクト
	 */
	@PostMapping("/client/theme/select")
	public String selectTheme(@RequestParam Integer themeId, HttpSession session) {

		UserBean userBean = (UserBean) session.getAttribute("user");

		if (userBean == null) {
			return "redirect:/login";
		}

		Integer purchaseCount = userBean.getPurchaseCount();
		Integer totalPurchaseAmount = userBean.getTotalPurchaseAmount();

		if (purchaseCount == null) {
			purchaseCount = 0;
		}

		if (totalPurchaseAmount == null) {
			totalPurchaseAmount = 0;
		}

		boolean usable = false;

		if (themeId == 1) {
			usable = true;
		} else if (themeId == 2 && purchaseCount >= 1) {
			usable = true;
		} else if (themeId == 3 && purchaseCount >= 3) {
			usable = true;
		} else if (themeId == 4 && purchaseCount >= 5) {
			usable = true;
		} else if (themeId == 5 && totalPurchaseAmount >= 10000) {
			usable = true;
		} else if (themeId == 6 && purchaseCount >= 10) {
			usable = true;
		} else if (themeId == 7 && purchaseCount >= 20) {
			usable = true;
		}

		if (usable) {
			User user = userRepository.getReferenceById(userBean.getId());
			user.setThemeId(themeId);
			userRepository.save(user);

			userBean.setThemeId(themeId);
			session.setAttribute("user", userBean);
			session.setAttribute("themeClass", getThemeClass(themeId));
		}

		return "redirect:/client/theme/list";
	}

	/**
	 * テーマIDに対応するCSSクラス名を取得する
	 *
	 * @param themeId テーマID
	 * @return CSSクラス名
	 */
	private String getThemeClass(Integer themeId) {

		if (themeId == null) {
			return "theme-normal";
		}

		switch (themeId) {
		case 2:
			return "theme-sakura";
		case 3:
			return "theme-ocean";
		case 4:
			return "theme-game";
		case 5:
			return "theme-space";
		case 6:
			return "theme-gold";
		case 7:
			return "theme-p3tech";
		default:
			return "theme-normal";
		}
	}
}
