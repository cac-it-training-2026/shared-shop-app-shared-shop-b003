package jp.co.sss.shop.controller.client.review;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.Review;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.form.ReviewForm;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.repository.ReviewRepository;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.util.Constant;

/**
 * 商品レビュー投稿用コントローラ
 */
@Controller
public class ClientReviewController {

	@Autowired
	ReviewRepository reviewRepository;

	@Autowired
	ItemRepository itemRepository;

	@Autowired
	UserRepository userRepository;

	@Autowired
	HttpSession session;

	/**
	 * レビュー投稿処理
	 */
	@RequestMapping(path = "/client/review/regist", method = RequestMethod.POST)
	public String registReview(@Valid @ModelAttribute ReviewForm form, BindingResult result) {

		UserBean userBean = (UserBean) session.getAttribute("user");
		if (userBean == null) {
			return "redirect:/login";
		}

		if (result.hasErrors()) {
			return "redirect:/client/item/detail/" + form.getProductId();
		}

		Item item = itemRepository.findByIdAndDeleteFlag(form.getProductId(), Constant.NOT_DELETED);
		User user = userRepository.findByIdAndDeleteFlag(userBean.getId(), Constant.NOT_DELETED);

		if (item != null && user != null) {
			Review review = new Review();
			review.setProduct(item);
			review.setUser(user);
			review.setRating(form.getRating());
			review.setBody(form.getBody());
			review.setApproved(1); // 初期状態で公開（要件により変更可）

			reviewRepository.save(review);
		}

		return "redirect:/client/item/detail/" + form.getProductId();
	}
}
