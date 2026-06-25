package jp.co.sss.shop.controller.admin.review;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jp.co.sss.shop.repository.ReviewRepository;

/**
 * レビュー管理用コントローラ（管理者用）
 */
@Controller
public class AdminReviewController {

	@Autowired
	ReviewRepository reviewRepository;

	/**
	 * レビュー一覧表示
	 */
	@RequestMapping(path = "/admin/review/list", method = RequestMethod.GET)
	public String showReviewList(Model model, Pageable pageable) {
		model.addAttribute("pages", reviewRepository.findAll(pageable));
		return "admin/review/list";
	}

	/**
	 * レビュー削除処理
	 */
	@RequestMapping(path = "/admin/review/delete/{id}", method = RequestMethod.POST)
	public String deleteReview(@PathVariable Integer id) {
		reviewRepository.deleteById(id);
		return "redirect:/admin/review/list";
	}

	/**
	 * レビュー公開・非公開切り替え
	 */
	@RequestMapping(path = "/admin/review/status/{id}", method = RequestMethod.POST)
	public String switchStatus(@PathVariable Integer id) {
		reviewRepository.findById(id).ifPresent(review -> {
			review.setApproved(review.getApproved() == 1 ? 0 : 1);
			reviewRepository.save(review);
		});
		return "redirect:/admin/review/list";
	}
}
