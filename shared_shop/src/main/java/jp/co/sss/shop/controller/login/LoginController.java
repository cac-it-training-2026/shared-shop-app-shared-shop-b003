package jp.co.sss.shop.controller.login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.form.LoginForm;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.util.Constant;

/**
 * ログイン機能のコントローラクラス
 *
 * @author SystemShared
 */
@Controller
public class LoginController {

	/**
	 * 会員情報
	 */
	@Autowired
	UserRepository userRepository;

	/**
	 * セッション情報
	 */
	@Autowired
	HttpSession session;

	/**
	 * ログイン処理
	 *
	 * @param form ログインフォーム
	 * @return "login" ログイン画面表示
	 */
	@RequestMapping(path = "/login", method = RequestMethod.GET)
	public String login(@ModelAttribute LoginForm form) {

		// セッション情報を無効にする
		session.invalidate();

		return "login";
	}

	/**
	 * ログイン処理
	 *
	 * @param form ログインフォーム
	 * @param result 入力チェック結果
	 * @return 一般会員の場合 "redirect:/" トップ画面表示処理
	 * 運用管理者、システム管理者の場合 "redirect:/admin/menu" 管理者メニュー表示処理
	 */
	@RequestMapping(path = "/login", method = RequestMethod.POST)
	public String doLogin(@Valid @ModelAttribute LoginForm form, BindingResult result) {

		if (result.hasErrors()) {
			// 入力値に誤りがあった場合（認証失敗）
			User user = userRepository.findByEmailAndDeleteFlag(form.getEmail(), Constant.NOT_DELETED);
			if (user != null) {
				// すでにロックされているか確認
				if (user.getLockedUntil() != null
						&& user.getLockedUntil().after(new java.sql.Timestamp(System.currentTimeMillis()))) {
					result.reject("error.login.locked", "アカウントがロックされています。15分後にお試しください。");
				} else {
					// 失敗回数をインクリメント
					int count = (user.getFailedLoginCount() == null ? 0 : user.getFailedLoginCount()) + 1;
					user.setFailedLoginCount(count);
					if (count >= 5) {
						// 15分ロック
						user.setLockedUntil(new java.sql.Timestamp(System.currentTimeMillis() + 15 * 60 * 1000));
						result.reject("error.login.locked", "ログイン失敗が5回に達したため、アカウントを15分間ロックしました。");
					}
					userRepository.save(user);
				}
			}

			// セッション情報を無効にして、ログイン画面再表示
			session.invalidate();
			return "login";

		} else {
			// 成功時、フォームのメールアドレスからユーザー情報を確実に取得
			User user = userRepository.findByEmailAndDeleteFlag(form.getEmail(), Constant.NOT_DELETED);

			if (user != null) {
				// 1. 失敗回数とロック状態をリセットして保存
				user.setFailedLoginCount(0);
				user.setLockedUntil(null);
				userRepository.save(user);

				// 2. セッションにセットするためのBeanを生成して格納（ログイン状態の確立）
				UserBean userBean = new UserBean();
				userBean.setId(user.getId());
				userBean.setName(user.getName());
				userBean.setAuthority(user.getAuthority());
				session.setAttribute("user", userBean);

				// 3. 権限の判定
				if (userBean.getAuthority() == Constant.AUTH_CLIENT) {
					// ガチャの実行権限をセッションに設定 (ログインイベント)
					session.setAttribute("canPlayGacha", true);
					session.setAttribute("gachaEventType", "login");

					// 一般会員ログインした場合、トップ画面表示処理にリダイレクト
					return "redirect:/";
				} else {
					// 運用管理者、もしくはシステム管理者としてログインした場合、管理者用メニュー画面表示処理にリダイレクト
					return "redirect:/admin/menu";
				}
			} else {
				// 万が一ユーザーが取得できなかった場合の安全リダイレクト
				session.invalidate();
				return "login";
			}
		}
	}

	/**
	 * 管理者メニュー表示処理
	 *
	 * @return "admin/menu" 管理者メニュー画面表示
	 */
	@RequestMapping(path = "/admin/menu", method = RequestMethod.GET)
	public String showAdminMenu() {

		// 管理者用メニュー画面表示
		return "admin/admin_menu";
	}

}