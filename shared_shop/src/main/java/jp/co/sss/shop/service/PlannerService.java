package jp.co.sss.shop.service;

import java.util.ArrayList;
import java.util.Arrays;
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

	/**
	 * 用途キーワードとカテゴリ名のマッピング
	 */
	private static final Map<String, List<String>> KEYWORD_TO_CATEGORIES = new HashMap<>();

	static {
		KEYWORD_TO_CATEGORIES.put("ゲーム", Arrays.asList("PC", "マウス", "キーボード", "モニター"));
		KEYWORD_TO_CATEGORIES.put("プログラミング", Arrays.asList("PC", "キーボード", "モニター"));
		KEYWORD_TO_CATEGORIES.put("動画編集", Arrays.asList("PC", "モニター"));
		KEYWORD_TO_CATEGORIES.put("在宅ワーク", Arrays.asList("PC", "マウス", "キーボード", "モニター"));
		KEYWORD_TO_CATEGORIES.put("配信", Arrays.asList("PC", "マイク", "Webカメラ"));
	}

	public List<List<Item>> suggestItemSets(String purpose, int budget) {
		// 1. キーワード解析
		List<String> targetCategoryNames = new ArrayList<>();
		for (String keyword : KEYWORD_TO_CATEGORIES.keySet()) {
			if (purpose.contains(keyword)) {
				targetCategoryNames.addAll(KEYWORD_TO_CATEGORIES.get(keyword));
			}
		}

		// 重複削除
		targetCategoryNames = targetCategoryNames.stream().distinct().collect(Collectors.toList());

		if (targetCategoryNames.isEmpty()) {
			// キーワードが見つからない場合は全カテゴリから適当に選ぶ（または空を返す）
			return new ArrayList<>();
		}

		// 2. カテゴリIDの取得
		List<Category> allCategories = categoryRepository.findAll();
		final List<String> finalTargetCategoryNames = targetCategoryNames;
		List<Integer> targetCategoryIds = allCategories.stream()
				.filter(c -> finalTargetCategoryNames.contains(c.getName()))
				.map(Category::getId)
				.collect(Collectors.toList());

		if (targetCategoryIds.isEmpty()) {
			return new ArrayList<>();
		}

		// 3. 各カテゴリから商品候補を取得 (在庫あり、未削除)
		Map<Integer, List<Item>> categoryItems = new HashMap<>();
		for (Integer catId : targetCategoryIds) {
			List<Item> items = itemRepository.findByCategoryIdAndDeleteFlagOrderByInsertDateDesc(catId, Constant.NOT_DELETED)
					.stream().filter(i -> i.getStock() > 0).collect(Collectors.toList());
			if (!items.isEmpty()) {
				categoryItems.put(catId, items);
			}
		}

		// 全ての必須カテゴリで商品が見つかる必要があるとする
		if (categoryItems.size() < targetCategoryIds.size()) {
			// 一部のカテゴリで商品がない場合、見つかったものだけで構成するか、諦める
			// 今回は諦める（セットにならないため）
			// ただし、緩いマッチングにするなら修正
		}

		// 4. 組合せ生成（簡易的な貪欲法）
		List<List<Item>> suggestions = new ArrayList<>();

		// パターン1: 安い順セット
		List<Item> cheapSet = new ArrayList<>();
		int cheapTotal = 0;
		for (Integer catId : targetCategoryIds) {
			if (categoryItems.containsKey(catId)) {
				Item cheapest = categoryItems.get(catId).stream()
						.min((a, b) -> a.getPrice().compareTo(b.getPrice())).get();
				cheapSet.add(cheapest);
				cheapTotal += cheapest.getPrice();
			}
		}
		if (cheapTotal <= budget && !cheapSet.isEmpty()) {
			suggestions.add(cheapSet);
		}

		// パターン2: 人気（最新）順セット
		List<Item> latestSet = new ArrayList<>();
		int latestTotal = 0;
		for (Integer catId : targetCategoryIds) {
			if (categoryItems.containsKey(catId)) {
				Item latest = categoryItems.get(catId).get(0); // リポジトリで新着順に取得しているため
				latestSet.add(latest);
				latestTotal += latest.getPrice();
			}
		}
		if (latestTotal <= budget && !latestSet.isEmpty() && latestTotal != cheapTotal) {
			suggestions.add(latestSet);
		}

		return suggestions;
	}
}
