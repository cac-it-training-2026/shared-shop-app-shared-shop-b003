package jp.co.sss.shop.service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jp.co.sss.shop.entity.Category;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.PlannerKeywordCategory;
import jp.co.sss.shop.repository.CategoryRepository;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.repository.PlannerKeywordCategoryRepository;
import jp.co.sss.shop.util.Constant;

@Service
public class PlannerService {

	@Autowired
	CategoryRepository categoryRepository;

	@Autowired
	ItemRepository itemRepository;

	@Autowired
	PlannerKeywordCategoryRepository plannerKeywordCategoryRepository;

	/**
	 * プラン生成結果を保持する内部クラス
	 */
	public static class PlanResult {
		private List<Item> items;
		private String recommendation;

		public PlanResult(List<Item> items, String recommendation) {
			this.items = items;
			this.recommendation = recommendation;
		}

		public List<Item> getItems() { return items; }
		public String getRecommendation() { return recommendation; }
	}

	/**
	 * プラン生成ロジック
	 */
	public Map<String, PlanResult> suggestPlannedSets(String purpose, int budget) {
		if (purpose == null || purpose.trim().isEmpty()) {
			return new HashMap<>();
		}

		// 1. キーワードからカテゴリを取得
		List<PlannerKeywordCategory> mappings = plannerKeywordCategoryRepository.findByKeyword(purpose.trim());

		// 部分一致検索
		if (mappings.isEmpty()) {
			List<PlannerKeywordCategory> allMappings = plannerKeywordCategoryRepository.findAll();
			mappings = allMappings.stream()
					.filter(m -> purpose.contains(m.getKeyword()))
					.collect(Collectors.toList());
		}

		if (mappings.isEmpty()) {
			return new HashMap<>();
		}

		List<String> targetCategoryNames = mappings.stream()
				.map(PlannerKeywordCategory::getCategoryName)
				.distinct()
				.collect(Collectors.toList());

		List<Category> allCategories = categoryRepository.findAll();
		List<Category> targetCategories = allCategories.stream()
				.filter(c -> targetCategoryNames.contains(c.getName()))
				.collect(Collectors.toList());

		if (targetCategories.isEmpty()) {
			return new HashMap<>();
		}

		// 2. 各カテゴリの有効な商品リストを取得
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

		if (categoryItems.size() < targetCategories.size()) {
			return new HashMap<>();
		}

		Map<String, PlanResult> plans = new LinkedHashMap<>();

		// A. コスパ重視
		List<Item> costSet = new ArrayList<>();
		int costTotal = 0;
		for (Category cat : targetCategories) {
			Item item = categoryItems.get(cat.getId()).get(0);
			costSet.add(item);
			costTotal += item.getPrice();
		}
		if (costTotal <= budget) {
			plans.put("コスパ重視", new PlanResult(costSet, "各カテゴリで最もお求めやすい商品を揃えた、経済的なプランです。"));
		}

		// B. バランス
		List<Item> balanceSet = new ArrayList<>();
		int balanceTotal = 0;
		for (Category cat : targetCategories) {
			List<Item> items = categoryItems.get(cat.getId());
			Item item = items.get(items.size() / 2);
			balanceSet.add(item);
			balanceTotal += item.getPrice();
		}
		if (balanceTotal <= budget) {
			plans.put("バランス", new PlanResult(balanceSet, "価格と品質のバランスが取れた、最もおすすめの構成です。"));
		}

		// C. ハイエンド
		List<Item> highSet = new ArrayList<>();
		int highTotal = 0;
		for (Category cat : targetCategories) {
			List<Item> items = categoryItems.get(cat.getId());
			Item item = items.get(items.size() - 1);
			highSet.add(item);
			highTotal += item.getPrice();
		}

		if (highTotal > budget) {
			boolean adjusted = true;
			while (highTotal > budget && adjusted) {
				adjusted = false;
				int maxPrice = -1;
				int maxIdx = -1;
				for (int i = 0; i < highSet.size(); i++) {
					if (highSet.get(i).getPrice() > maxPrice) {
						List<Item> options = categoryItems.get(highSet.get(i).getCategory().getId());
						int currentPos = options.indexOf(highSet.get(i));
						if (currentPos > 0) {
							maxPrice = highSet.get(i).getPrice();
							maxIdx = i;
						}
					}
				}

				if (maxIdx != -1) {
					Item current = highSet.get(maxIdx);
					List<Item> options = categoryItems.get(current.getCategory().getId());
					int currentPos = options.indexOf(current);
					Item nextBest = options.get(currentPos - 1);
					highTotal = highTotal - current.getPrice() + nextBest.getPrice();
					highSet.set(maxIdx, nextBest);
					adjusted = true;
				}
			}
		}

		if (highTotal <= budget) {
			plans.put("ハイエンド", new PlanResult(highSet, "ご予算の範囲内で最高のパフォーマンスを追求した、妥協のないプランです。"));
		}

		return plans;
	}
}
