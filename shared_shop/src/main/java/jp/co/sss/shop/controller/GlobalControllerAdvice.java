package jp.co.sss.shop.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.service.RecentlyViewedService;

/**
 * 全てのコントローラで共通の処理を行うアドバイスクラス
 */
@ControllerAdvice
public class GlobalControllerAdvice {

	@Autowired
	RecentlyViewedService recentlyViewedService;

	@Autowired
	HttpSession session;

	/**
	 * 全ての画面で「最近チェックした商品」を利用できるようにする
	 * 一般会員または非会員の場合のみ取得する
	 * @return 最近チェックした商品のリスト
	 */
	@ModelAttribute("recentlyViewedItems")
	public List<ItemBean> getRecentlyViewedItems() {
		UserBean user = (UserBean) session.getAttribute("user");
		if (user == null || "USER".equals(user.getRole())) {
			return recentlyViewedService.getRecentlyViewedItems();
		}
		return null;
	}
}
