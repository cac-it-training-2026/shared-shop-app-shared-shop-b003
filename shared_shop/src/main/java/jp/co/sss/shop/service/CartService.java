package jp.co.sss.shop.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.BasketBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.repository.ItemRepository;

/**
 * カート関連のサービスクラス
 */
@Service
public class CartService {

	@Autowired
	ItemRepository itemRepository;

	@Autowired
	ItemService itemService;

	@Autowired
	HttpSession session;

	/**
	 * カートに商品を追加する
	 * 追加時にセール価格を計算し、固定する
	 *
	 * @param id 商品ID
	 */
	public void addItem(Integer id) {
		Optional<Item> itemOptional = itemRepository.findById(id);

		if (itemOptional.isPresent()) {
			Item item = itemOptional.get();

			// カート情報の取得
			List<BasketBean> basketBeans = (List<BasketBean>) session.getAttribute("basketBeans");
			if (basketBeans == null) {
				basketBeans = new ArrayList<>();
			}

			// 既に対象商品がカートにあるか確認
			for (BasketBean bean : basketBeans) {
				if (bean.getId().equals(id)) {
					bean.setOrderNum(bean.getOrderNum() + 1);
					session.setAttribute("basketBeans", basketBeans);
					return;
				}
			}

			// 新規追加
			BasketBean newBean = new BasketBean();
			BeanUtils.copyProperties(item, newBean);

			// セール価格を計算して固定
			Integer salePrice = itemService.calculateSalePrice(item);
			newBean.setPrice(salePrice);

			newBean.setOrderNum(1);
			basketBeans.add(newBean);
			session.setAttribute("basketBeans", basketBeans);
		}
	}
}
