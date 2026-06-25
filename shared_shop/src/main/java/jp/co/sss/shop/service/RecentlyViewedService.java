package jp.co.sss.shop.service;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.util.Constant;

/**
 * 最近閲覧した商品を管理するサービス
 */
@Service
public class RecentlyViewedService {

	@Autowired
	HttpSession session;

	@Autowired
	ItemRepository itemRepository;

	@Autowired
	BeanTools beanTools;

	private static final String SESSION_KEY = "recentlyViewedItemIds";
	private static final int MAX_SIZE = 5;

	/**
	 * 閲覧履歴に商品IDを追加する
	 * @param itemId 商品ID
	 */
	public void addToHistory(Integer itemId) {
		LinkedList<Integer> ids = (LinkedList<Integer>) session.getAttribute(SESSION_KEY);
		if (ids == null) {
			ids = new LinkedList<>();
		}

		// 既にある場合は一旦削除（最新として追加し直すため）
		ids.remove(itemId);

		// 先頭に追加
		ids.addFirst(itemId);

		// 最大件数を超えたら古いものを削除
		if (ids.size() > MAX_SIZE) {
			ids.removeLast();
		}

		session.setAttribute(SESSION_KEY, ids);
	}

	/**
	 * 閲覧履歴の商品情報を取得する
	 * @return 商品情報のリスト
	 */
	public List<ItemBean> getRecentlyViewedItems() {
		LinkedList<Integer> ids = (LinkedList<Integer>) session.getAttribute(SESSION_KEY);
		if (ids == null || ids.isEmpty()) {
			return new ArrayList<>();
		}

		List<ItemBean> items = new ArrayList<>();
		for (Integer id : ids) {
			Item item = itemRepository.findByIdAndDeleteFlag(id, Constant.NOT_DELETED);
			if (item != null) {
				items.add(beanTools.copyEntityToItemBean(item));
			}
		}
		return items;
	}
}