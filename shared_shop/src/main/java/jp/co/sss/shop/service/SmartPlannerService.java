package jp.co.sss.shop.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.util.Constant;

@Service
public class SmartPlannerService {

    @Autowired
    ItemRepository itemRepository;

    @Autowired
    BeanTools beanTools;

    /**
     * キーワードとカテゴリの対応マップ
     */
    private static final Map<String, List<String>> KEYWORD_CATEGORY_MAP = new HashMap<>();

    static {
        KEYWORD_CATEGORY_MAP.put("ゲーム", List.of("PC", "マウス", "キーボード", "モニター"));
        KEYWORD_CATEGORY_MAP.put("FPS", List.of("PC", "マウス", "キーボード", "モニター"));
        KEYWORD_CATEGORY_MAP.put("プログラミング", List.of("PC", "マウス", "キーボード", "モニター"));
        KEYWORD_CATEGORY_MAP.put("動画編集", List.of("PC", "モニター", "SSD"));
        KEYWORD_CATEGORY_MAP.put("配信", List.of("PC", "マイク", "Webカメラ"));
        KEYWORD_CATEGORY_MAP.put("在宅ワーク", List.of("PC", "モニター", "キーボード", "マウス"));
        KEYWORD_CATEGORY_MAP.put("レポート", List.of("PC", "USBメモリ"));
        KEYWORD_CATEGORY_MAP.put("AI", List.of("PC", "モニター"));
        KEYWORD_CATEGORY_MAP.put("開発", List.of("PC", "モニター", "キーボード"));
    }

    /**
     * おすすめセットを生成する
     *
     * @param useCase 用途
     * @param budget  予算
     * @return おすすめセットのリスト
     */
    public List<RecommendedSet> generateRecommendedSets(String useCase, Integer budget) {
        // 1. 用途から必要なカテゴリを決定
        List<String> requiredCategories = determineRequiredCategories(useCase);

        if (requiredCategories.isEmpty()) {
            // 用途に合うカテゴリが見つからない場合は空リストを返す（またはデフォルトセット）
            return Collections.emptyList();
        }

        // 2. 在庫あり商品を全取得
        List<Item> allAvailableItems = itemRepository.findByDeleteFlagOrderByInsertDateDesc(Constant.NOT_DELETED)
                .stream()
                .filter(item -> item.getStock() > 0)
                .collect(Collectors.toList());

        // 3. 予算内で最適な組み合わせを生成（貪欲法による近似）
        List<RecommendedSet> results = new ArrayList<>();

        // 複数の組み合わせを試行（ここではシンプルに1つ生成）
        RecommendedSet set = createOptimalSet(requiredCategories, allAvailableItems, budget);
        if (set != null) {
            results.add(set);
        }

        return results;
    }

    private List<String> determineRequiredCategories(String useCase) {
        List<String> categories = new ArrayList<>();
        for (Map.Entry<String, List<String>> entry : KEYWORD_CATEGORY_MAP.entrySet()) {
            if (useCase.contains(entry.getKey())) {
                categories.addAll(entry.getValue());
            }
        }
        return categories.stream().distinct().collect(Collectors.toList());
    }

    private RecommendedSet createOptimalSet(List<String> requiredCategories, List<Item> availableItems, int budget) {
        List<Item> selectedItems = new ArrayList<>();
        int currentTotal = 0;

        // カテゴリごとに、予算内で最高評価（または最新）の商品を選択する
        // ※評価機能が未実装の場合は最新を優先
        for (String categoryName : requiredCategories) {
            final int remainingBudget = budget - currentTotal;
            Item bestItem = availableItems.stream()
                    .filter(i -> i.getCategory().getName().equals(categoryName))
                    .filter(i -> i.getPrice() <= remainingBudget)
                    .findFirst() // 既に新着順でソートされている想定
                    .orElse(null);

            if (bestItem != null) {
                selectedItems.add(bestItem);
                currentTotal += bestItem.getPrice();
            }
        }

        if (selectedItems.isEmpty()) {
            return null;
        }

        RecommendedSet set = new RecommendedSet();
        set.setItems(beanTools.copyEntityListToItemBeanList(selectedItems));
        set.setTotalPrice(currentTotal);
        set.setReason("用途に適した構成、予算内に収まる、新着の商品を優先");
        return set;
    }

    public static class RecommendedSet {
        private List<ItemBean> items;
        private int totalPrice;
        private String reason;

        // Getter/Setter
        public List<ItemBean> getItems() { return items; }
        public void setItems(List<ItemBean> items) { this.items = items; }
        public int getTotalPrice() { return totalPrice; }
        public void setTotalPrice(int totalPrice) { this.totalPrice = totalPrice; }
        public String getReason() { return reason; }
        public void setReason(String reason) { this.reason = reason; }
    }
}
