package jp.co.sss.shop.controller.admin.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.util.Constant;

/**
 * 会員管理 ロック解除機能(運用管理者、システム管理者)のコントローラクラス
 *
 * @author SystemShared
 */
@Controller
public class AdminUserUnlockController {
	/**
	 * 会員情報　リポジトリ
	 */
	@Autowired
	UserRepository userRepository;

	/**
	 * ロック解除処理
	 *
	 * @param id ロック解除対象会員ID
	 * @return "redirect:/admin/user/detail/{id}" 詳細画面へ
	 */
	@RequestMapping(path = "/admin/user/unlock/{id}", method = RequestMethod.POST)
	public String unlockUser(@PathVariable int id) {
		// 対象の情報を取得
		User user = userRepository.findByIdAndDeleteFlag(id, Constant.NOT_DELETED);
		if (user != null) {
			// ロック解除
			user.setFailedLoginCount(0);
			user.setLockedUntil(null);
			userRepository.save(user);
		}

		// 詳細画面へリダイレクト
		return "redirect:/admin/user/detail/" + id;
	}
}
