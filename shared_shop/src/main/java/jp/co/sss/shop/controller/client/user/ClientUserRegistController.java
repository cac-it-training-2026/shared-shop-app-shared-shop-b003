package jp.co.sss.shop.controller.client.user;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.form.UserForm;
import jp.co.sss.shop.repository.UserRepository;

@Controller
@RequestMapping("/client/user/regist")
public class ClientUserRegistController {

	/**
	 * ユーザー情報リポジトリ
	 */
	@Autowired
	UserRepository userRepository;

	/**
	 * セッション
	 */
	@Autowired
	HttpSession session;

	/**
	 * ① 新規会員登録リンククリック時
	 * 
	 * @return
	 */

	@RequestMapping(path = "/input/init", method = RequestMethod.GET)
	public String init() {
		// 入力画面へリダイレクト
		return "redirect:/client/user/regist/input";
	}

	/**
	 * ③入力画面の表示
	 * @param model
	 * @return
	 */
	@RequestMapping(path = "/input", method = RequestMethod.GET)
	public String registInput(Model model) {

		// 上書きの防止
		if (!model.containsAttribute("userForm")) {

			// セッションからフォームの取得
			UserForm form = (UserForm) session.getAttribute("userForm");

			// なかった場合新規作成
			if (form == null) {
				form = new UserForm();
			}
			// 画面に渡す
			model.addAttribute("userForm", form);
		}
		// 入力画面表示
		return "client/user/regist_input";
	}

	/**
	 *  ②新規登録ボタン押す
	 */
	@RequestMapping(path = "/input", method = RequestMethod.POST)
	public String registSubmit(UserForm form) {
		// 入力値をセッションに保持
		session.setAttribute("userForm", form);
		// 入力画面へリダイレクト
		return "redirect:/client/user/regist/input";
	}

	/**
	 * ④ 確認ボタン押す（入力チェック）
	 */

	@RequestMapping(path = "/check", method = RequestMethod.POST)
	public String registCheck(@Valid UserForm form, BindingResult result, RedirectAttributes redirectAttributes) {
		// 入力チェック
		if (result.hasErrors()) {
			// エラー情報をリダイレクト語も使えるように
			redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.userForm", result);
			// 入力値の保持
			redirectAttributes.addFlashAttribute("userForm", form);
			// 入力画面へ戻る
			return "redirect:/client/user/regist/input";

		}

		// メール重複チェック
		User user = userRepository.findByEmail(form.getEmail());
		if (user != null) {

			// メールが重複した際のエラーメッセージを追加
			result.rejectValue("email", "error.email.duplicate", "メールアドレスが既に登録されています");//error.email.duplicateの追加
			// エラー内容の保持
			redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.userForm", result);
			// 入力値の保持
			redirectAttributes.addFlashAttribute("userForm", form);
			// 入力画面へ戻る
			return "redirect:/client/user/regist/input";
		}

		// 正常時、確認画面にセッション保存
		session.setAttribute("userForm", form);
		// 確認画面へ
		return "redirect:/client/user/regist/check";

	}

	/**
	 * ⑤ 確認画面表示
	 */
	@RequestMapping(path = "/check", method = RequestMethod.GET)
	public String checkView(Model model) {
		// セッションから入力フォーム情報を取得
		UserForm form = (UserForm) session.getAttribute("userForm");
		// 取得した情報を画面へ渡す
		model.addAttribute("userForm", form);
		// 確認画面の表示
		return "client/user/regist_check";
	}

	/**
	 * ⑥ 登録処理（登録ボタン押した）
	 */
	// 画面で入力されたデータをDBに保存し完了画面へ
	@RequestMapping(path = "/complete", method = RequestMethod.POST)
	public String showUserRegistComplete() {
		// セッションから入力されたフォーム情報を取得
		UserForm form = (UserForm) session.getAttribute("userForm");
		// Entity生成
		User user = new User();
		// FormからEntityを一括コピー （※後で手動setに変更
		BeanUtils.copyProperties(form, user);
		// DB登録
		userRepository.save(user);
		// セッション削除
		session.removeAttribute("userForm");
		// 完了画面へリダイレクト
		return "redirect:/client/user/regist/complete";

	}

	/**
	 * ⑦ 完了画面表示
	 */
	@RequestMapping(path = "/complete", method = RequestMethod.GET)
	public String completeView() {

		// 完了画面（regist_complete.html）を表示
		return "client/user/regist_complete";
	}

}
