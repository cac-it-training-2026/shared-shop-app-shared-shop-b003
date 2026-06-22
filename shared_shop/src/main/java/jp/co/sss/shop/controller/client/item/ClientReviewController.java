package jp.co.sss.shop.controller.client.item;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.Review;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.repository.ReviewRepository;
import jp.co.sss.shop.repository.UserRepository;

/**
 * 商品レビュー投稿用のコントローラークラス
 */
@Controller
public class ClientReviewController {

	/**
	 * 商品レビュー　リポジトリ
	 */
	@Autowired
	ReviewRepository reviewRepository;

	/**
	 * 商品情報　リポジトリ
	 */
	@Autowired
	ItemRepository itemRepository;

	/**
	 * 会員情報　リポジトリ
	 */
	@Autowired
	UserRepository userRepository;

	/**
	 * セッション情報
	 */
	@Autowired
	HttpSession session;

	/**
	 * レビュー投稿処理
	 */
	@RequestMapping(path = "/client/review/regist", method = RequestMethod.POST)
	public String registReview(Integer itemId, Integer rating, String comment, String stamp) {

		// セッションからログイン中の会員情報を取得
		UserBean loginUser = (UserBean) session.getAttribute("user");

		// 未ログインの場合はログイン画面へ
		if (loginUser == null) {
			return "redirect:/login";
		}

		// 商品情報を取得
		Item item = itemRepository.getReferenceById(itemId);

		// 会員情報を取得
		User user = userRepository.getReferenceById(loginUser.getId());

		// レビュー情報を生成
		Review review = new Review();
		review.setItem(item);
		review.setUser(user);
		review.setRating(rating);
		review.setComment(comment);
		review.setStamp(stamp);

		// レビューを保存
		reviewRepository.save(review);

		// 商品詳細画面へリダイレクト
		return "redirect:/client/item/detail/" + itemId;
	}
}
