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
	 * @return
			一般会員の場合 "redirect:/" トップ画面表示処理
			運用管理者、システム管理者の場合 "redirect:/adminmenu"管理者メニュー表示処理
	 */
	@RequestMapping(path = "/login", method = RequestMethod.POST)
	public String doLogin(@Valid @ModelAttribute LoginForm form, BindingResult result) {

		String returnStr = "login";

		// 失敗カウント等の処理
		User user = userRepository.findByEmailAndDeleteFlag(form.getEmail(), Constant.NOT_DELETED);

		if (result.hasErrors()) {
			// 入力値に誤りがあった場合 (バリデータで失敗)
			if (user != null) {
				// ロックされていない場合のみ失敗カウントをアップ
				java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
				if (user.getLockedUntil() == null || user.getLockedUntil().before(now)) {
					int currentFailed = user.getFailedLoginCount() == null ? 0 : user.getFailedLoginCount();
					currentFailed++;
					if (currentFailed >= 5) {
						java.sql.Timestamp lockUntil = new java.sql.Timestamp(System.currentTimeMillis() + (15 * 60 * 1000));
						user.setLockedUntil(lockUntil);
					}
					user.setFailedLoginCount(currentFailed);
					userRepository.save(user);
				}
			}
			// セッション情報を無効にして、ログイン画面再表示
			session.invalidate();
			returnStr = "login";

		} else {
			// ログイン成功時：失敗カウントとロック日時をリセット
			if (user != null) {
				user.setFailedLoginCount(0);
				user.setLockedUntil(null);
				userRepository.save(user);
			}

			//セッションスコープから権限を取り出す
			Integer authority = ((UserBean) session.getAttribute("user")).getAuthority();
			if (authority.intValue() == Constant.AUTH_CLIENT) {
				// 一般会員ログインした場合、トップ画面表示処理にリダイレクト
				returnStr = "redirect:/";
			} else {

				// 運用管理者、もしくはシステム管理者としてログインした場合、管理者用メニュー画面表示処理にリダイレクト
				returnStr = "redirect:/admin/menu";
			}
		}
		return returnStr;

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
