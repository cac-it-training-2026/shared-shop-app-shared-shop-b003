package jp.co.sss.shop.controller.client.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.repository.UserRepository;

/**
 * 会員詳細表示用のコントローラークラス
 * 
 */
public class ClientUserShowController {

	/**
	 * 会員情報　リポジトリ
	 */
	@Autowired
	UserRepository userRepository;

	/**
	 * セッション情報
	 */
	@Autowired
	HttpSession session;

	/**
	 * 詳細表示処理
	 *
	 * 
	 * @param model Viewとの値受渡し
	 * @return "client/user/detail" 会員詳細表示画面へ
	 * 
	 */
	@RequestMapping(path = "/client/user/detail", method = RequestMethod.POST)
	public String showUserDetail(Model model) {

		// TODO ログイン中の会員情報を取得
		// User user = ○○;

		UserBean userBean = new UserBean();

		// TODO UserからUserBeanへコピー
		// BeanUtils.copyProperties(user, userBean);

		model.addAttribute("userBean", userBean);

		session.removeAttribute("userForm");

		return "client/user/detail";

	}
}
