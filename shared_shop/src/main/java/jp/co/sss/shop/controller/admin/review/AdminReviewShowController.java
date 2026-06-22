package jp.co.sss.shop.controller.admin.review;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jp.co.sss.shop.entity.Review;
import jp.co.sss.shop.repository.ReviewRepository;
import jp.co.sss.shop.util.Constant;

/**
 * レビュー管理 一覧表示機能(管理者用)のコントローラクラス
 */
@Controller
public class AdminReviewShowController {

	/**
	 * レビュー情報
	 */
	@Autowired
	ReviewRepository reviewRepository;

	/**
	 * レビュー一覧表示
	 *
	 * @param model    Viewとの値受渡し
	 * @param pageable ページ制御用
	 * @return "admin/review/list" 一覧画面 表示
	 */
	@RequestMapping(path = "/admin/review/list", method = { RequestMethod.GET, RequestMethod.POST })
	public String showReviewList(Model model, Pageable pageable) {

		// 削除されていないレビューを新着順で取得
		Page<Review> reviewsPage = reviewRepository.findByDeleteFlagOrderByInsertDateDesc(Constant.NOT_DELETED, pageable);

		model.addAttribute("pages", reviewsPage);
		model.addAttribute("reviews", reviewsPage.getContent());

		return "admin/review/list";
	}

	/**
	 * レビュー詳細表示
	 *
	 * @param id    レビューID
	 * @param model Viewとの値受渡し
	 * @return "admin/review/detail" 詳細画面 表示
	 */
	@RequestMapping(path = "/admin/review/detail/{id}", method = { RequestMethod.GET, RequestMethod.POST })
	public String showReview(@PathVariable Integer id, Model model) {

		Review review = reviewRepository.findByIdAndDeleteFlag(id, Constant.NOT_DELETED);
		if (review == null) {
			return "redirect:/syserror";
		}

		model.addAttribute("review", review);

		return "admin/review/detail";
	}
}
