package jp.co.sss.shop.controller.client.user;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.form.UserForm;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.util.Constant;

@Controller
public class ClientUserUpdateController {

	/**
	 * 会員情報　リポジトリ
	 */
	@Autowired
	UserRepository userRepository;

	/**
	 * セッション
	 */
	@Autowired
	HttpSession session;

	/**
	 * 入力画面　初期表示処理(POST)
	 * 
	 * @return "redirect:/client/user/update/input" 入力録画面　表示処理
	 */

	@RequestMapping(path = "/client/user/update/input", method = RequestMethod.POST)
	public String userUpdateInputInit() {

		// セッションからログイン中の会員情報を取得(まだ未確定)
		UserBean loginUser = (UserBean) session.getAttribute("user");

		// DBから会員情報を取得
		User user = userRepository.findByIdAndDeleteFlag(
				loginUser.getId(),
				Constant.NOT_DELETED);

		// 会員情報が存在しない場合
		if (user == null) {
			return "redirect:/syserror";
		}

		// 変更画面で使用する入力フォームオブジェクトを生成
		UserForm userForm = new UserForm();

		// ログイン会員情報を入力フォームへコピー
		// （変更画面の初期表示値として利用するため）
		BeanUtils.copyProperties(user, userForm);

		// 入力フォーム情報をセッションへ保存
		// （リダイレクト後の画面でも利用できるようにするため）
		session.setAttribute("userForm", userForm);

		// GETの入力画面表示処理へリダイレクト
		return "redirect:/client/user/update/input";
	}

	/**
	 * 入力画面　表示処理
	 *
	 * @param model Viewとの値受渡し
	 * @return "admin/user/update_input" 変更入力画面 表示
	 */

	@RequestMapping(path = "/client/user/update/input", method = RequestMethod.GET)
	public String userUpdateInput(Model model) {

		// セッションから入力フォーム取得
		UserForm userForm = (UserForm) session.getAttribute("userForm");

		if (userForm == null) {
			return "redirect:/syserror";
		}

		// 画面表示用に設定
		model.addAttribute("userForm", userForm);

		BindingResult result = (BindingResult) session.getAttribute("result");
		if (result != null) {
			//セッションにエラー情報がある場合、エラー情報を画面表示設定
			model.addAttribute("org.springframework.validation.BindingResult.userForm", result);
			session.removeAttribute("result");
		}

		return "client/user/update_input";

	}
}
