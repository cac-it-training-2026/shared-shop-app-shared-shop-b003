package jp.co.sss.shop.controller.client.item;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.Review;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.repository.ReviewRepository;

/**
 * レビュー投稿機能のコントローラクラス
 */
@Controller
public class ClientReviewController {

	@Autowired
	ReviewRepository reviewRepository;

	@Autowired
	ItemRepository itemRepository;

	@Autowired
	HttpSession session;

	/**
	 * レビューを投稿する処理
	 * @param productId 商品ID
	 * @param rating 評価
	 * @param commentText レビュー本文
	 * @return 商品詳細画面へのリダイレクト
	 */
	@RequestMapping(path = "/client/item/review", method = RequestMethod.POST)
	public String postReview(@RequestParam("productId") Integer productId,
							 @RequestParam("rating") Integer rating,
							 @RequestParam("commentText") String commentText) {

		// セッションからログインユーザー情報を取得
		UserBean userBean = (UserBean) session.getAttribute("user");
		if (userBean == null) {
			return "redirect:/login";
		}

		Item item = itemRepository.findById(productId).orElse(null);
		if (item != null) {
			Review review = new Review();
			review.setItem(item);

			User user = new User();
			user.setId(userBean.getId());
			review.setUser(user);

			review.setRating(rating);
			review.setCommentText(commentText);

			reviewRepository.save(review);
		}

		return "redirect:/client/item/detail/" + productId;
	}
}
