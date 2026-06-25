package jp.co.sss.shop.controller.client.review;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.Review;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.form.ReviewForm;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.repository.ReviewRepository;
import jp.co.sss.shop.util.Constant;

/**
 * 商品レビュー登録コントローラ
 */
@Controller
public class ClientReviewRegistController {
	@Autowired
	ReviewRepository reviewRepository;

	@Autowired
	ItemRepository itemRepository;

	@Autowired
	HttpSession session;

	/**
	 * レビュー入力画面表示
	 */
	@RequestMapping(path = "/client/review/regist/input/{itemId}", method = RequestMethod.GET)
	public String registInput(@PathVariable Integer itemId, @ModelAttribute ReviewForm form, Model model) {
		Item item = itemRepository.findByIdAndDeleteFlag(itemId, Constant.NOT_DELETED);
		if (item == null) {
			return "redirect:/syserror";
		}
		model.addAttribute("item", item);
		form.setItemId(itemId);
		return "client/review/regist_input";
	}

	/**
	 * レビュー登録確認画面
	 */
	@RequestMapping(path = "/client/review/regist/check", method = RequestMethod.POST)
	public String registCheck(@Valid @ModelAttribute ReviewForm form, BindingResult result, Model model) {
		if (result.hasErrors()) {
			Item item = itemRepository.findByIdAndDeleteFlag(form.getItemId(), Constant.NOT_DELETED);
			model.addAttribute("item", item);
			return "client/review/regist_input";
		}
		Item item = itemRepository.findByIdAndDeleteFlag(form.getItemId(), Constant.NOT_DELETED);
		model.addAttribute("item", item);
		return "client/review/regist_check";
	}

	/**
	 * レビュー登録処理
	 */
	@RequestMapping(path = "/client/review/regist/complete", method = RequestMethod.POST)
	public String registComplete(@ModelAttribute ReviewForm form) {
		Review review = new Review();
		Item item = itemRepository.findByIdAndDeleteFlag(form.getItemId(), Constant.NOT_DELETED);

		UserBean userBean = (UserBean) session.getAttribute("user");
		User user = new User();
		user.setId(userBean.getId());

		review.setItem(item);
		review.setUser(user);
		review.setEvaluation(form.getEvaluation());
		review.setContent(form.getContent());
		review.setStamp(form.getStamp());
		//追加
		review.setApproved(1);

		reviewRepository.save(review);

		return "client/review/regist_complete";
	}
}
