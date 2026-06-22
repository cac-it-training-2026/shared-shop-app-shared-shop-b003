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

	private static final List<String> INVALID_KEYWORDS = Arrays.asList("asdf", "qwer", "aaaa", "test", "テスト");

	public Map<String, List<Item>> suggestPlannedSets(String purpose, int budget) {

		if (purpose == null || purpose.trim().length() < 2) {
			return new HashMap<>();
		}

		String lowerPurpose = purpose.toLowerCase().trim();
		if (INVALID_KEYWORDS.contains(lowerPurpose)) {
			return new HashMap<>();
		}

		List<PlannerKeywordCategory> mappings = plannerKeywordCategoryRepository.findByKeyword(purpose.trim());

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

		if (categoryItems.size() < targetCategories.size()) {
			return new HashMap<>();
		}

		Map<String, List<Item>> plans = new HashMap<>();

		// 1. コスパ重視
		List<Item> costSet = new ArrayList<>();
		int costTotal = 0;
		for (Integer catId : categoryItems.keySet()) {
			Item item = categoryItems.get(catId).get(0);
			costSet.add(item);
			costTotal += item.getPrice();
		}
		if (costTotal <= budget) plans.put("コスパ重視プラン", costSet);

		// 2. バランス
		List<Item> balanceSet = new ArrayList<>();
		int balanceTotal = 0;
		for (Integer catId : categoryItems.keySet()) {
			List<Item> items = categoryItems.get(catId);
			Item item = items.get(items.size() / 2);
			balanceSet.add(item);
			balanceTotal += item.getPrice();
		}
		if (balanceTotal <= budget) plans.put("バランスプラン", balanceSet);

		// 3. ハイエンド
		List<Item> highSet = new ArrayList<>();
		int highTotal = 0;
		for (Integer catId : categoryItems.keySet()) {
			List<Item> items = categoryItems.get(catId);
			Item expensive = items.get(items.size() - 1);
			highSet.add(expensive);
			highTotal += expensive.getPrice();
		}

		if (highTotal > budget) {
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
		if (highTotal <= budget) plans.put("ハイエンドプラン", highSet);

		return plans;
	}
}
