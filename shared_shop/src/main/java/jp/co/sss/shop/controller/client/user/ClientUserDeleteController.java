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
import jp.co.sss.shop.form.UserForm;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.util.Constant;

@Controller
public class ClientUserDeleteController {

	/**
	 * 会員情報　リポジトリ
	 */
	@Autowired
	UserRepository repository;

	/**
	 * セッション
	 */
	@Autowired
	HttpSession session;

	/**
	 * 会員情報削除確認処理
	 * 
	 * @param id 削除対象ID
	 * @return "delete_check" 削除確認画面 表示
	 *
	 */
	@RequestMapping(path = "/client/user/delete/check")
	public String userDeleteCheck() {

		//		削除対象の会員情報をセッションスコープから取得
		UserBean loginUser = (UserBean) session.getAttribute("user");
		User user = repository.findByIdAndDeleteFlag(loginUser.getId(), Constant.NOT_DELETED);

		if (user == null) {//対象がない場合
			return "redirect:/syserror";
		}

		//		取得情報から表示フォーム情報を生成
		UserForm userForm = new UserForm();
		BeanUtils.copyProperties(user, userForm);

		//		情報フォームをセッションに保持
		session.setAttribute("userForm", userForm);

		//		削除確認画面　表示
		return "redirect:/client/user/delete/check";
	}

	@RequestMapping(path = "/client/user/delete/check", method = RequestMethod.GET)
	public String updateInput(Model model) {

		//セッションから入力フォーム取得
		UserForm userForm = (UserForm) session.getAttribute("userForm");
		if (userForm == null) {
			// セッション情報がない場合、エラー
			return "redirect:/syserror";
		}
		// 入力フォーム情報を画面表示設定
		model.addAttribute("userForm", userForm);

		// 削除確認画面　表示
		return "client/user/delete_check";
	}

	/**
	 * 会員情報削除完了処理
	 *
	 * @return "redirect:/client/user/delete/complete" 会員情報 削除完了画面へ
	 */
	@RequestMapping(path = "/client/user/delete/complete", method = RequestMethod.POST)
	public String userDeleteComplete() {

		// セッションから削除対象フォーム情報を取得
		UserForm userForm = (UserForm) session.getAttribute("userForm");
		if (userForm == null) {
			// セッション情報がない場合、エラー
			return "redirect:/syserror";
		}
		// 削除対象の会員情報を取得
		User user = repository.findByIdAndDeleteFlag(userForm.getId(), Constant.NOT_DELETED);

		if (user == null) {
			// 対象が無い場合、エラー
			return "redirect:/syserror";
		}

		// 削除フラグを立てる
		user.setDeleteFlag(Constant.DELETED);

		// 会員情報を保存
		repository.save(user);

		System.out.println(session.getAttribute("user.name"));

		// セッションに保存されている情報全部削除
		session.removeAttribute("userForm");
		session.removeAttribute("basketBeans");
		session.removeAttribute("user");

		//		session.invalidate();

		// 削除完了画面　表示処理
		return "redirect:/client/user/delete/complete";
	}

	/**
	 * 会員情報削除完了処理
	 *
	 * @return "client/user/delete_complete" 会員情報 削除完了画面へ
	 */
	@RequestMapping(path = "/client/user/delete/complete", method = RequestMethod.GET)
	public String deleteCompleteFinish() {

		return "client/user/delete_complete";
	}

}