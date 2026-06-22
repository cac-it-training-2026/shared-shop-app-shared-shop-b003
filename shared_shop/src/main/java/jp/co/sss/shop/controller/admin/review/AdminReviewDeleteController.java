package jp.co.sss.shop.controller.admin.review;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jp.co.sss.shop.entity.Review;
import jp.co.sss.shop.repository.ReviewRepository;
import jp.co.sss.shop.util.Constant;

/**
 * レビュー管理 削除機能のコントローラクラス
 */
@Controller
public class AdminReviewDeleteController {

	/**
	 * レビュー情報
	 */
	@Autowired
	ReviewRepository reviewRepository;

	/**
	 * セッション
	 */
	@Autowired
	HttpSession session;

	/**
	 * 削除確認画面表示
	 *
	 * @param id 削除対象ID
	 * @return "admin/review/delete_check" 削除確認画面
	 */
	@RequestMapping(path = "/admin/review/delete/check/{id}", method = RequestMethod.POST)
	public String deleteCheck(@PathVariable Integer id) {

		Review review = reviewRepository.findByIdAndDeleteFlag(id, Constant.NOT_DELETED);
		if (review == null) {
			return "redirect:/syserror";
		}

		session.setAttribute("review", review);

		return "redirect:/admin/review/delete/check";
	}

	/**
	 * 削除確認画面表示(GET)
	 *
	 * @param model Viewとの値受渡し
	 * @return "admin/review/delete_check" 削除確認画面
	 */
	@RequestMapping(path = "/admin/review/delete/check", method = RequestMethod.GET)
	public String deleteCheckView(Model model) {

		Review review = (Review) session.getAttribute("review");
		if (review == null) {
			return "redirect:/syserror";
		}

		model.addAttribute("review", review);

		return "admin/review/delete_check";
	}

	/**
	 * 削除処理
	 *
	 * @return 遷移先
	 */
	@RequestMapping(path = "/admin/review/delete/complete", method = RequestMethod.POST)
	public String deleteComplete() {

		Review sessionReview = (Review) session.getAttribute("review");
		if (sessionReview == null) {
			return "redirect:/syserror";
		}

		Review review = reviewRepository.findByIdAndDeleteFlag(sessionReview.getId(), Constant.NOT_DELETED);
		if (review != null) {
			review.setDeleteFlag(Constant.DELETED);
			reviewRepository.save(review);
		}

		session.removeAttribute("review");

		return "redirect:/admin/review/delete/complete";
	}

	/**
	 * 削除完了画面表示
	 *
	 * @return "admin/review/delete_complete" 削除完了画面
	 */
	@RequestMapping(path = "/admin/review/delete/complete", method = RequestMethod.GET)
	public String deleteCompleteRedirect() {
		return "admin/review/delete_complete";
	}
}
