package jp.co.sss.shop.controller.client.point;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.PointHistory;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.repository.PointHistoryRepository;
import jp.co.sss.shop.repository.UserRepository;

/**
 * ポイント履歴表示用のコントローラークラス
 *
 */
@Controller
public class ClientPointShowController {

	/**
	 * ポイント履歴情報リポジトリ
	 */
	@Autowired
	PointHistoryRepository pointHistoryRepository;

	/**
	 * ユーザー情報リポジトリ
	 */
	@Autowired
	UserRepository userRepository;

	/**
	 * セッション情報
	 */
	@Autowired
	HttpSession session;

	/**
	 * ポイント履歴表示処理
	 *
	 * @param model Viewとの値受渡し
	 * @return "client/point/history" ポイント履歴表示画面へ
	 */
	@RequestMapping(path = "/client/point/history", method = { RequestMethod.GET })
	public String showPointHistory(Model model) {

		// セッションからログイン中の会員情報を取得
		UserBean loginUser = (UserBean) session.getAttribute("user");

		if (loginUser == null) {
			return "redirect:/login";
		}

		// ユーザー情報を取得
		User user = userRepository.getReferenceById(loginUser.getId());

		// ポイント履歴を降順で取得
		List<PointHistory> pointHistories = pointHistoryRepository.findByUserOrderByCreatedTimeDescIdDesc(user);

		// 会員情報と履歴情報を画面へ渡す
		model.addAttribute("pointHistories", pointHistories);

		return "client/point/history";
	}
}
