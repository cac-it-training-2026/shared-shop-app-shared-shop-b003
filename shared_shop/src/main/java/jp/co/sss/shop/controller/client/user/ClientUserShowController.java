package jp.co.sss.shop.controller.client.user;

import org.springframework.beans.BeanUtils;
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
 * 会員詳細表示用のコントローラークラス
 * 
 * @author fujino
 * 
 */
@Controller
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
	@RequestMapping(path = "/client/user/detail", method = { RequestMethod.POST, RequestMethod.GET })
	public String showUserDetail(Model model) {

		// セッションからログイン中の会員情報を取得
		UserBean loginUser = (UserBean) session.getAttribute("user");

		// 表示対象の情報を取得
		User user = userRepository.findByIdAndDeleteFlag(loginUser.getId(),
				Constant.NOT_DELETED);

		// 対象会員が存在しない場合
		if (user == null) {
			return "redirect:/syserror";
		}

		// EntityからBeanへコピー
		UserBean userBean = new UserBean();
		BeanUtils.copyProperties(user, userBean);

		// 会員情報を画面へ渡す
		model.addAttribute("userBean", userBean);

		// 会員登録・変更・削除用のセッションスコープを初期化
		session.removeAttribute("userForm");

		//詳細表示
		return "client/user/detail";
	}
}
