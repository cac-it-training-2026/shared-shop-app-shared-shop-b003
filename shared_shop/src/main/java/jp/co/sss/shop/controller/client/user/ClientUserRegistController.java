package jp.co.sss.shop.controller.client.user;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.form.UserForm;
import jp.co.sss.shop.repository.UserRepository;

/**
 * 会員登録画面の処理を行うコントローラクラス
 * 入力・確認・登録完了までの一連の処理を担当する
 * 
 * @author kamagata
 */
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
	    * ① 初期表示処理
	    * 入力フォームを新規生成し、セッションへ格納する。
	    * その後、入力画面へリダイレクトする。
	    * @return 入力画面へのリダイレクトURL
	    */

	@RequestMapping(path = "/input/init", method = RequestMethod.GET)
	public String init() {

		// フォーム新規生成
		UserForm form = new UserForm();// 追加

		// セッションに保存
		session.setAttribute("userForm", form);// 追加

		// 入力画面へリダイレクト
		return "redirect:/client/user/regist/input";
	}

	/**
	 * ②一覧画面からの新規登録ボタン入力処理
	 * 戻るボタンなどで空のフォームが送信された場合は、セッション情報を上書きしないよう制御する。
	 *  
	 *  @param form 入力された会員情報
	 *  @return 入力画面へのURL（リダイレクト）
	 */
	@RequestMapping(path = "/input", method = RequestMethod.POST)
	public String registSubmit(UserForm form) {

		// セッションから取得
		UserForm sessionForm = (UserForm) session.getAttribute("userForm");// 追加

		// セッションに存在しない場合は新規生成
		if (sessionForm == null) {
			sessionForm = new UserForm();
		}

		// 入力がある場合のみ上書き（空データ対策）
		if (form.getEmail() != null && !form.getEmail().isEmpty()) {
			BeanUtils.copyProperties(form, sessionForm);
		}

		// 入力値をセッションに保持
		session.setAttribute("userForm", sessionForm);
		// 入力画面へリダイレクト
		return "redirect:/client/user/regist/input";
	}

	/**
	 * ③入力画面の表示
	 * セッションからフォーム情報とエラー情報を取得し、リクエストスコープへ設定する。
	 * @param model 画面に値を渡すためのModel
	 * @return 入力画面View名
	 */
	@RequestMapping(path = "/input", method = RequestMethod.GET)
	public String registInput(Model model) {

		// セッションからフォームの取得
		UserForm form = (UserForm) session.getAttribute("userForm");

		// セッションにデータがない場合は新規作成
		if (form == null) {
			form = new UserForm();
		}
		// フォームを画面に渡す
		model.addAttribute("userForm", form);

		// エラー情報をセッションから取得
		BindingResult result = (BindingResult) session.getAttribute("result");
		// エラーが存在する場合のみ画面に渡す
		if (result != null) {
			// BindingResultをリダイレクト後の画面に引き継ぐ（エラーメッセージ表示用）
			model.addAttribute("org.springframework.validation.BindingResult.userForm", result);
			// 一度表示したエラー情報は削除
			session.removeAttribute("result");
		}

		// 入力画面表示
		return "client/user/regist_input";
	}

	/**
	 * ④ 登録入力画面の確認ボタン入力処理
	 *  入力チェックおよびメール重複チェックを行う
	 *  
	 *  @param form 入力された会員情報
	 *  @param result 入力チェック結果
	 *  @return 遷移先URL（エラー時は入力画面へリダイレクト、正常時は確認画面へリダイレクト）
	 */

	@RequestMapping(path = "/check", method = RequestMethod.POST)
	public String registCheck(@Valid UserForm form, BindingResult result) {

		// セッションから取得
		UserForm sessionForm = (UserForm) session.getAttribute("userForm");
		// セッションにフォームがなかったら作成
		if (sessionForm == null) {
			sessionForm = new UserForm();
		}

		// 入力内容をセッションに反映
		if (form.getEmail() != null) {
			BeanUtils.copyProperties(form, sessionForm);
		}

		// セッション保存
		session.setAttribute("userForm", sessionForm);

		// 入力エラー
		if (result.hasErrors()) {
			session.setAttribute("result", result);

			// 入力画面へ戻る
			return "redirect:/client/user/regist/input";

		}

		// メールアドレス重複チェック
		User user = userRepository.findByEmail(sessionForm.getEmail());
		if (user != null) {

			// メールが重複した際のエラーメッセージを追加
			result.rejectValue("email", "error.email.duplicate", "メールアドレスが既に登録されています");//error.email.duplicateの追加
			// エラー情報と入力値をセッションに保持
			session.setAttribute("result", result);

			return "redirect:/client/user/regist/input";
		}

		// 入力画面へ戻る
		return "redirect:/client/user/regist/check";
	}

	/**
	 * ⑤ 確認画面表示
	 * 
	 * @param model 画面に値を渡すためのModel
	 * @return 確認画面View名
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
	 * セッションのフォーム情報を元にDB登録を行う。
	 * 登録後はログイン状態にし、セッションを更新する。
	 * 
	 * @return 完了画面URL（リダイレクト）
	 * @return 異常時/syserror
	 */
	// 画面で入力されたデータをDBに保存し完了画面へ
	@RequestMapping(path = "/complete", method = RequestMethod.POST)
	public String showUserRegistComplete() {
		// セッションから入力されたフォーム情報を取得
		UserForm form = (UserForm) session.getAttribute("userForm");

		// セッション切れ対策
		if (form == null) {
			return "redirect:/syserror";
		}

		try {
			// Entityに値をセット
			User user = new User();
			user.setName(form.getName());
			user.setEmail(form.getEmail());
			user.setPassword(form.getPassword());
			user.setPostalCode(form.getPostalCode());
			user.setAddress(form.getAddress());
			user.setPhoneNumber(form.getPhoneNumber());
			user.setAuthority(form.getAuthority());

			// DB登録
			userRepository.save(user);

			// EntityをBeanに変換
			UserBean userBean = new UserBean();
			BeanUtils.copyProperties(user, userBean);

			// セッションはUserBeanで統一
			session.setAttribute("user", userBean);

			// セッション削除（二重送信防止）
			session.removeAttribute("userForm");

			// 完了画面へリダイレクト
			return "redirect:/client/user/regist/complete";

		} catch (Exception e) {
			// 異常
			return "redirect:/syserror";
			// TODO: handle exception
		}

	}

	/**
	 * ⑦ 完了画面表示
	 * 
	 * @return 完了画面View名
	 */

	@RequestMapping(path = "/complete", method = RequestMethod.GET)
	public String completeView() {

		// 完了画面（regist_complete.html）を表示
		return "client/user/regist_complete";
	}

}
