package jp.co.sss.shop.controller.client.review;

import java.util.List;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.OrderItem;
import jp.co.sss.shop.entity.Review;
import jp.co.sss.shop.entity.ReviewStamp;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.form.ReviewForm;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.repository.OrderRepository;
import jp.co.sss.shop.repository.ReviewRepository;
import jp.co.sss.shop.repository.ReviewStampRepository;
import jp.co.sss.shop.service.BeanTools;
import jp.co.sss.shop.util.Constant;

/**
 * レビュー登録機能(一般会員用)のコントローラクラス
 */
@Controller
public class ClientReviewRegistController {

	/**
	 * 商品情報
	 */
	@Autowired
	ItemRepository itemRepository;

	/**
	 * レビュー情報
	 */
	@Autowired
	ReviewRepository reviewRepository;

	/**
	 * スタンプ情報
	 */
	@Autowired
	ReviewStampRepository reviewStampRepository;

	/**
	 * 注文情報
	 */
	@Autowired
	OrderRepository orderRepository;

	/**
	 * Entity、Form、Bean間のデータコピーサービス
	 */
	@Autowired
	BeanTools beanTools;

	/**
	 * レビュー登録処理
	 *
	 * @param form    入力フォーム
	 * @param result  バリデーション結果
	 * @param model   Viewとの値受渡し
	 * @param session セッション
	 * @return 遷移先画面
	 */
	@RequestMapping(path = "/client/review/regist", method = RequestMethod.POST)
	public String regist(@Valid @ModelAttribute("reviewForm") ReviewForm form, BindingResult result, Model model,
			HttpSession session) {

		UserBean userBean = (UserBean) session.getAttribute("user");
		if (userBean == null || userBean.getAuthority() != Constant.AUTH_CLIENT) {
			return "redirect:/login";
		}

		// 商品情報の取得
		Item item = itemRepository.findByIdAndDeleteFlag(form.getItemId(), Constant.NOT_DELETED);
		if (item == null) {
			return "redirect:/syserror";
		}

		// 本文またはスタンプのどちらかは必須
		if ((form.getBody() == null || form.getBody().isBlank()) && (form.getStampId() == null || form.getStampId() == 0)) {
			result.rejectValue("body", "review.bodyOrStamp.required");
		}

		if (result.hasErrors()) {
			// バリデーションエラーがある場合、詳細画面に戻る
			model.addAttribute("item", beanTools.copyEntityToItemBean(item));
			model.addAttribute("reviews",
					reviewRepository.findByItemIdAndApprovedOrderByInsertDateDesc(form.getItemId(), 1));
			model.addAttribute("canReview", true);
			model.addAttribute("stamps", reviewStampRepository.findByActive(1));
			return "client/item/detail";
		}

		// 購入済みかチェック
		boolean hasPurchased = false;
		List<jp.co.sss.shop.entity.Order> orders = orderRepository.findByUserId(userBean.getId());
		for (jp.co.sss.shop.entity.Order order : orders) {
			for (OrderItem orderItem : order.getOrderItemsList()) {
				if (orderItem.getItem().getId().equals(form.getItemId())) {
					hasPurchased = true;
					break;
				}
			}
			if (hasPurchased) {
				break;
			}
		}

		if (!hasPurchased) {
			return "redirect:/syserror";
		}

		// レビュー情報の生成
		Review review = new Review();
		review.setItem(item);
		User user = new User();
		user.setId(userBean.getId());
		review.setUser(user);
		review.setRating(form.getRating());
		review.setBody(form.getBody());
		review.setApproved(1); // 初期状態は公開

		// スタンプ設定
		if (form.getStampId() != null && form.getStampId() != 0) {
			ReviewStamp stamp = reviewStampRepository.findById(form.getStampId()).orElse(null);
			review.setStamp(stamp);
		}

		// レビュー情報の保存
		reviewRepository.save(review);

		return "redirect:/client/item/detail/" + form.getItemId();
	}
}
