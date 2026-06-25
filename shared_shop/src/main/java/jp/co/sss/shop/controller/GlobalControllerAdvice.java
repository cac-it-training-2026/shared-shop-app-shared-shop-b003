package jp.co.sss.shop.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.SaleSchedule;
import jp.co.sss.shop.service.RecentlyViewedService;
import jp.co.sss.shop.service.SaleService;

/**
 * 全コントローラ共通の処理を行うクラス
 */
@ControllerAdvice(basePackages = "jp.co.sss.shop.controller.client")
public class GlobalControllerAdvice {

	@Autowired
	private SaleService saleService;

	@Autowired
	RecentlyViewedService recentlyViewedService;

	@Autowired
	HttpSession session;

	/**
	 * すべてのテンプレートで利用可能なアクティブセール情報をモデルに追加
	 * @param model モデル
	 */
	@ModelAttribute
	public void addAttributes(Model model) {
		try {
			Map<Integer, SaleSchedule> activeSales = saleService.getActiveSales();
			if (activeSales == null) {
				activeSales = new HashMap<>();
			}
			model.addAttribute("activeSales", activeSales);
		} catch (Exception e) {
			// 万が一サービス側でハンドリングしきれなかった場合も、画面表示を妨げない
			model.addAttribute("activeSales", new HashMap<>());
		}
	}

	/**
	 * 全ての画面で「最近チェックした商品」を利用できるようにする
	 * 一般会員または非会員の場合のみ取得する
	 * @return 最近チェックした商品のリスト
	 */
	@ModelAttribute("recentlyViewedItems")
	public List<ItemBean> getRecentlyViewedItems() {
		UserBean user = (UserBean) session.getAttribute("user");
		if (user == null || 2 == user.getAuthority()) {
			return recentlyViewedService.getRecentlyViewedItems();
		}
		return null;
	}
}
