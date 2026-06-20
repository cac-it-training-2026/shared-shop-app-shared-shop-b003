package jp.co.sss.shop.controller.admin.item;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jp.co.sss.shop.repository.ReviewRepository;

/**
 * 商品レビュー管理用のコントローラークラス（管理者用）
 */
@Controller
public class AdminReviewController {

	/**
	 * 商品レビュー　リポジトリ
	 */
	@Autowired
	ReviewRepository reviewRepository;

	/**
	 * 全レビュー一覧表示
	 */
	@RequestMapping(path = "/admin/review/list", method = { RequestMethod.GET, RequestMethod.POST })
	public String showReviewList(Model model) {
		model.addAttribute("reviews", reviewRepository.findAll());
		return "admin/item/review_list";
	}

	/**
	 * レビュー削除処理
	 */
	@RequestMapping(path = "/admin/review/delete/{id}", method = RequestMethod.POST)
	public String deleteReview(@PathVariable Integer id) {
		reviewRepository.deleteById(id);
		return "redirect:/admin/review/list";
	}
}
