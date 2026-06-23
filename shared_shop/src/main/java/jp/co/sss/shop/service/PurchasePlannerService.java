package jp.co.sss.shop.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jp.co.sss.shop.entity.Category;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.repository.CategoryRepository;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.util.Constant;

/**
 * スマート購入プランナーのサービスクラス
 */
@Service
public class PurchasePlannerService {

	@Autowired
	ItemRepository itemRepository;

	@Autowired
	CategoryRepository categoryRepository;

	/**
	 * おすすめの商品セットを生成する
	 * @param usage 利用目的
	 * @param budget 予算
	 * @return おすすめセットのリスト
	 */
	public List<Map<String, Object>> plan(String usage, Integer budget) {
		// 1. キーワード解析
		List<String> categoryNames = analyzeKeywords(usage);

		// 2. カテゴリごとに商品候補を取得 (在庫あり、削除フラグなし、高評価/売れ筋優先)
		Map<String, List<Item>> candidatesByCategory = new HashMap<>();
		for (String catName : categoryNames) {
			Category category = categoryRepository.findByNameAndDeleteFlag(catName, Constant.NOT_DELETED);
			if (category != null) {
				List<Item> items = itemRepository.findByCategoryIdAndDeleteFlagOrderByInsertDateDesc(category.getId(), Constant.NOT_DELETED);
				// 在庫ありのみフィルタリング
				List<Item> inStockItems = items.stream().filter(i -> i.getStock() > 0).toList();
				if (!inStockItems.isEmpty()) {
					candidatesByCategory.put(catName, inStockItems);
				}
			}
		}

		List<Map<String, Object>> results = new ArrayList<>();

		// 3. 組み合わせ生成 (貪欲法的な簡易実装)
		// 予算内で、各カテゴリから1つずつ選ぶ
		List<Item> selectedItems = new ArrayList<>();
		int currentTotal = 0;

		// 各カテゴリの最も安い商品を選んでみて、予算に収まるか確認
		for (String catName : categoryNames) {
			List<Item> items = candidatesByCategory.get(catName);
			if (items != null) {
				// 価格昇順でソートして一番安いのを選ぶ (予算重視)
				Item cheapest = items.stream().min((i1, i2) -> i1.getPrice().compareTo(i2.getPrice())).get();
				if (currentTotal + cheapest.getPrice() <= budget) {
					selectedItems.add(cheapest);
					currentTotal += cheapest.getPrice();
				}
			}
		}

		if (!selectedItems.isEmpty()) {
			Map<String, Object> plan = new HashMap<>();
			plan.put("title", "コストパフォーマンス重視セット");
			plan.put("totalPrice", currentTotal);
			plan.put("items", selectedItems);
			plan.put("reason", "ご指定の用途に必要なカテゴリから、予算内に収まる最もお求めやすい商品を組み合わせました。");
			results.add(plan);
		}

		return results;
	}

	private List<String> analyzeKeywords(String usage) {
		List<String> categories = new ArrayList<>();
		if (usage.contains("ゲーム") || usage.contains("FPS")) {
			categories.add("デスクトップPC");
			categories.add("モニター");
			categories.add("キーボード");
			categories.add("マウス");
		} else if (usage.contains("プログラミング") || usage.contains("開発")) {
			categories.add("ノートPC");
			categories.add("モニター");
			categories.add("キーボード");
		} else if (usage.contains("動画編集") || usage.contains("クリエイティブ")) {
			categories.add("デスクトップPC");
			categories.add("モニター");
			categories.add("外部ストレージ");
		} else if (usage.contains("在宅ワーク") || usage.contains("リモート")) {
			categories.add("ノートPC");
			categories.add("Webカメラ");
			categories.add("ヘッドセット");
		} else if (usage.contains("配信") || usage.contains("YouTube")) {
			categories.add("デスクトップPC");
			categories.add("マイク");
			categories.add("Webカメラ");
		} else {
			// デフォルト
			categories.add("ノートPC");
			categories.add("周辺機器");
		}
		return categories;
	}
}
