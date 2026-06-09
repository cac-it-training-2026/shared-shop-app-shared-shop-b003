package jp.co.sss.shop.controller.client.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

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

	//①新規会員登録リンクをクリック
	@RequestMapping(path = "/input/init", method = RequestMethod.GET)
	public String init() {
		//空のフォームを作成
		UserForm form = new UserForm();
		//セッションに保存
		session.setAttribute("userForm", form);
		//入力画面へリダイレクト
		return "redirect:/client/user/regist/input";
	}

	//入力画面の表示
	@RequestMapping(path = "/input", method = RequestMethod.GET)
	public String registInput(Model model) {
		UserForm form = (UserForm) session.getAttribute("userForm");

		if (form == null) {
			form = new UserForm();
		}
		//正常時にセッション保存
		model.addAttribute("userForm", form);
		return "client/user/regist_input";
	}

	/**
	 * ③ 確認ボタン押下（入力チェック）
	 */

	@RequestMapping(path = "/check", method = RequestMethod.POST)
	public String registCheck(@Valid UserForm form, BindingResult result, Model model) {
		// 入力チェック
		if (result.hasErrors()) {
			model.addAttribute("userForm", form);
			return "client/user/regist_input";
		}

		// メール重複チェック
		User user = userRepository.findByEmail(form.getEmail());
		if (user != null) {
			result.rejectValue("email", "", "メールアドレスが既に登録されています");
			model.addAttribute("userForm", form);
			return "client/user/regist_input";
		}

		// 正常時、セッション保存
		session.setAttribute("userForm", form);

		return "redirect:/client/user/regist/check";

	}

	/**
	 * ④ 確認画面表示
	 */
	@RequestMapping(path = "/check", method = RequestMethod.GET)
	public String checkView(Model model) {
		UserForm form = (UserForm) session.getAttribute("userForm");
		model.addAttribute("userForm", form);
		return "client/user/regist_check";
	}
}

//
////	////入力画面（戻る対応）
////	@RequestMapping(path = "/input", method = RequestMethod.POST)
////	public String inputPost() {
////		return "redirect:/client/user/regist/input";
////	}
//
//}
//]
//		]