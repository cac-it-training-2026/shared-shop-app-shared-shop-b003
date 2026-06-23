package jp.co.sss.shop.service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.PlannerKeywordCategory;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.repository.PlannerKeywordCategoryRepository;

/**
 * スマート購入プランナー用サービス
 */
@Service
public class PlannerService {

	@Autowired
	PlannerKeywordCategoryRepository plannerRepository;

	@Autowired
	ItemRepository itemRepository;

	@Autowired
	BeanTools beanTools;

	/**
	 * 指定されたキーワードと予算に基づいて3つのプランを生成する
	 * @param keyword キーワード
	 * @param budget 予算
	 * @return プランのリスト（0:コスパ, 1:バランス, 2:ハイエンド）
	 */
	public List<List<ItemBean>> generatePlans(String keyword, int budget) {
		// キーワードに紐づくカテゴリ名を取得
		List<String> categoryNames = plannerRepository.findByKeyword(keyword).stream()
				.map(PlannerKeywordCategory::getCategoryName)
				.collect(Collectors.toList());

		if (categoryNames.isEmpty()) {
			return new ArrayList<>();
		}

		// 各カテゴリの有効な商品を取得
		List<List<Item>> categoriesItems = new ArrayList<>();
		for (String categoryName : categoryNames) {
			List<Item> items = itemRepository.findByDeleteFlagOrderByInsertDateDesc(0).stream()
					.filter(i -> i.getCategory().getName().equals(categoryName))
					.filter(i -> i.getStock() > 0)
					.sorted(Comparator.comparing(Item::getPrice))
					.collect(Collectors.toList());
			if (items.isEmpty()) {
				// 1つでも商品がないカテゴリがあればプラン生成不可
				return new ArrayList<>();
			}
			categoriesItems.add(items);
		}

		List<List<ItemBean>> plans = new ArrayList<>();

		// 1. コスパ重視（各カテゴリの最安値）
		List<Item> lowPlan = new ArrayList<>();
		for (List<Item> items : categoriesItems) {
			lowPlan.add(items.get(0));
		}
		if (calculateTotal(lowPlan) <= budget) {
			plans.add(beanTools.copyEntityListToItemBeanList(lowPlan));
		} else {
			plans.add(null); // 予算オーバー
		}

		// 2. バランス（各カテゴリの中間値）
		List<Item> midPlan = new ArrayList<>();
		for (List<Item> items : categoriesItems) {
			midPlan.add(items.get(items.size() / 2));
		}
		if (calculateTotal(midPlan) <= budget) {
			plans.add(beanTools.copyEntityListToItemBeanList(midPlan));
		} else {
			plans.add(null);
		}

		// 3. ハイエンド（予算内での最高値）
		// 各カテゴリから1つずつ選んで合計が予算内になる組み合わせを見つける（簡易版：各カテゴリから高い順に試行）
		List<Item> highPlan = findHighEndPlan(categoriesItems, budget);
		if (highPlan != null) {
			plans.add(beanTools.copyEntityListToItemBeanList(highPlan));
		} else {
			plans.add(null);
		}

		return plans;
	}

	private int calculateTotal(List<Item> items) {
		return items.stream().mapToInt(Item::getPrice).sum();
	}

	private List<Item> findHighEndPlan(List<List<Item>> categoriesItems, int budget) {
		List<Item> currentBest = new ArrayList<>();
		// 初期値としてコスパプランを入れる（これが予算オーバーならハイエンドもありえない）
		for (List<Item> items : categoriesItems) {
			currentBest.add(items.get(0));
		}
		if (calculateTotal(currentBest) > budget) {
			return null;
		}

		// 各カテゴリでより高いものに変えていく
		for (int i = 0; i < categoriesItems.size(); i++) {
			List<Item> itemsInCat = categoriesItems.get(i);
			for (int j = itemsInCat.size() - 1; j >= 0; j--) {
				Item candidate = itemsInCat.get(j);
				List<Item> tempPlan = new ArrayList<>(currentBest);
				tempPlan.set(i, candidate);
				if (calculateTotal(tempPlan) <= budget) {
					currentBest = tempPlan;
					break; // このカテゴリでの最高値決定
				}
			}
		}
		return currentBest;
	}
}
