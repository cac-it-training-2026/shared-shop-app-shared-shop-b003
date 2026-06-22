package jp.co.sss.shop.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jp.co.sss.shop.entity.Category;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.repository.CategoryRepository;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.util.Constant;

@Service
public class PlannerService {

	@Autowired
	CategoryRepository categoryRepository;

	@Autowired
	ItemRepository itemRepository;

	private static final Map<String, List<String>> KEYWORD_TO_CATEGORIES = new HashMap<>();

	static {
		KEYWORD_TO_CATEGORIES.put("ゲーム", Arrays.asList("PC", "マウス", "キーボード", "モニター"));
		KEYWORD_TO_CATEGORIES.put("プログラミング", Arrays.asList("PC", "キーボード", "書籍"));
		KEYWORD_TO_CATEGORIES.put("動画編集", Arrays.asList("PC", "モニター", "ストレージ"));
		KEYWORD_TO_CATEGORIES.put("在宅ワーク", Arrays.asList("PC", "オフィスチェア", "デスクライト"));
		KEYWORD_TO_CATEGORIES.put("自炊", Arrays.asList("調理器具", "調味料", "食料品"));
		KEYWORD_TO_CATEGORIES.put("パーティー", Arrays.asList("菓子", "飲料", "惣菜"));
		KEYWORD_TO_CATEGORIES.put("ダイエット", Arrays.asList("健康食品", "飲料"));
		KEYWORD_TO_CATEGORIES.put("読書", Arrays.asList("書籍", "雑貨"));
		KEYWORD_TO_CATEGORIES.put("勉強", Arrays.asList("書籍", "文房具"));
	}

	public Map<String, List<Item>> suggestPlannedSets(String purpose, int budget) {
		List<String> targetCategoryNames = new ArrayList<>();
		for (String keyword : KEYWORD_TO_CATEGORIES.keySet()) {
			if (purpose != null && purpose.contains(keyword)) {
				targetCategoryNames.addAll(KEYWORD_TO_CATEGORIES.get(keyword));
			}
		}

		if (targetCategoryNames.isEmpty()) {
			targetCategoryNames.addAll(Arrays.asList("食料品", "雑貨"));
		}

		targetCategoryNames = targetCategoryNames.stream().distinct().collect(Collectors.toList());

		List<Category> allCategories = categoryRepository.findAll();
		final List<String> finalNames = targetCategoryNames;
		List<Category> targetCategories = allCategories.stream()
				.filter(c -> finalNames.contains(c.getName()))
				.collect(Collectors.toList());

		if (targetCategories.isEmpty()) return new HashMap<>();

		Map<Integer, List<Item>> categoryItems = new HashMap<>();
		for (Category cat : targetCategories) {
			List<Item> items = itemRepository.findByCategoryIdAndDeleteFlagOrderByInsertDateDesc(cat.getId(), Constant.NOT_DELETED)
					.stream()
					.filter(i -> i.getStock() > 0)
					.sorted(Comparator.comparing(Item::getPrice))
					.collect(Collectors.toList());
			if (!items.isEmpty()) {
				categoryItems.put(cat.getId(), items);
			}
		}

		Map<String, List<Item>> plans = new HashMap<>();

		// 1. コスパ重視プラン (各カテゴリ最安)
		List<Item> costSet = new ArrayList<>();
		int costTotal = 0;
		for (Integer catId : categoryItems.keySet()) {
			Item item = categoryItems.get(catId).get(0);
			costSet.add(item);
			costTotal += item.getPrice();
		}
		if (costTotal <= budget && !costSet.isEmpty()) plans.put("コスパ重視プラン", costSet);

		// 2. バランスプラン (各カテゴリ中間層)
		List<Item> balanceSet = new ArrayList<>();
		int balanceTotal = 0;
		for (Integer catId : categoryItems.keySet()) {
			List<Item> items = categoryItems.get(catId);
			Item item = items.get(items.size() / 2);
			balanceSet.add(item);
			balanceTotal += item.getPrice();
		}
		if (balanceTotal <= budget && !balanceSet.isEmpty()) plans.put("バランスプラン", balanceSet);

		// 3. ハイエンドプラン (予算内最高値)
		List<Item> highSet = new ArrayList<>();
		int highTotal = 0;
		for (Integer catId : categoryItems.keySet()) {
			List<Item> items = categoryItems.get(catId);
			Item expensive = items.get(items.size() - 1);
			highSet.add(expensive);
			highTotal += expensive.getPrice();
		}

		if (highTotal > budget && !highSet.isEmpty()) {
			for (int i = 0; i < highSet.size(); i++) {
				Item current = highSet.get(i);
				List<Item> options = categoryItems.get(current.getCategory().getId());
				for (int j = options.size() - 2; j >= 0; j--) {
					highTotal -= current.getPrice();
					current = options.get(j);
					highTotal += current.getPrice();
					highSet.set(i, current);
					if (highTotal <= budget) break;
				}
				if (highTotal <= budget) break;
			}
		}
		if (highTotal <= budget && !highSet.isEmpty()) plans.put("ハイエンドプラン", highSet);

		return plans;
	}
}
