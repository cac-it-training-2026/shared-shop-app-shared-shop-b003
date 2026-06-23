package jp.co.sss.shop.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import jp.co.sss.shop.entity.SaleSchedule;
import jp.co.sss.shop.service.SaleService;

/**
 * 全コントローラ共通の処理を行うクラス
 */
@ControllerAdvice(basePackages = "jp.co.sss.shop.controller.client")
public class GlobalControllerAdvice {

    @Autowired
    private SaleService saleService;

    /**
     * すべてのテンプレートで利用可能なアクティブセール情報をモデルに追加
     * @param model モデル
     */
    @ModelAttribute
    public void addAttributes(Model model) {
        try {
            Map<Integer, SaleSchedule> activeSales = saleService.getActiveSales();
            if (activeSales == null) {
                activeSales = new HashMap<>();
            }
            model.addAttribute("activeSales", activeSales);
        } catch (Exception e) {
            // 万が一サービス側でハンドリングしきれなかった場合も、画面表示を妨げない
            model.addAttribute("activeSales", new HashMap<>());
        }
    }
}
