package jp.co.sss.shop.controller.client.user;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.entity.Order;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.repository.OrderRepository;
import jp.co.sss.shop.util.Constant;
import java.util.ArrayList;
import java.util.List;

/**
 * テーマ変更機能のコントローラクラス
 */
@Controller
public class ClientThemeController {

    @Autowired
    UserRepository userRepository;

    @Autowired
    OrderRepository orderRepository;

    @Autowired
    HttpSession session;

    /**
     * テーマ情報の内部クラス
     */
    public static class ThemeInfo {
        private int id;
        private String nameKey;
        private String descKey;
        private boolean unlocked;

        public ThemeInfo(int id, String nameKey, String descKey, boolean unlocked) {
            this.id = id;
            this.nameKey = nameKey;
            this.descKey = descKey;
            this.unlocked = unlocked;
        }

        public int getId() { return id; }
        public String getNameKey() { return nameKey; }
        public String getDescKey() { return descKey; }
        public boolean isUnlocked() { return unlocked; }
    }

    /**
     * テーマ変更画面表示処理
     *
     * @param model Viewとの値受渡し
     * @return "client/theme/theme_input" テーマ変更画面表示
     */
    @RequestMapping(path = "/client/theme/input", method = RequestMethod.GET)
    public String themeInput(Model model) {
        UserBean userBean = (UserBean) session.getAttribute("user");
        if (userBean == null) {
            return "redirect:/login";
        }

        // 注文履歴から実績を計算
        List<Order> orders = orderRepository.findByUserId(userBean.getId());
        int orderCount = orders.size();
        int totalAmount = 0;
        for (Order order : orders) {
            totalAmount += order.getTotal();
        }

        userBean.setOrderCount(orderCount);
        userBean.setTotalAmount(totalAmount);
        session.setAttribute("user", userBean);

        List<ThemeInfo> themes = new ArrayList<>();
        themes.add(new ThemeInfo(0, "theme.default", "theme.desc.default", true));
        themes.add(new ThemeInfo(1, "theme.sakura", "theme.desc.sakura", orderCount >= 1));
        themes.add(new ThemeInfo(2, "theme.sea", "theme.desc.sea", orderCount >= 3));
        themes.add(new ThemeInfo(3, "theme.game", "theme.desc.game", orderCount >= 5));
        themes.add(new ThemeInfo(4, "theme.space", "theme.desc.space", totalAmount >= 10000));
        themes.add(new ThemeInfo(5, "theme.gold", "theme.desc.gold", orderCount >= 10));
        themes.add(new ThemeInfo(6, "theme.p3tech", "theme.desc.p3tech", orderCount >= 20));

        model.addAttribute("themes", themes);
        model.addAttribute("currentThemeId", userBean.getThemeId());

        return "client/theme/theme_input";
    }

    /**
     * テーマ変更処理
     *
     * @param themeId 変更後のテーマID
     * @return "redirect:/" トップ画面へ
     */
    @RequestMapping(path = "/client/theme/update", method = RequestMethod.POST)
    public String themeUpdate(Integer themeId) {
        UserBean userBean = (UserBean) session.getAttribute("user");
        if (userBean == null) {
            return "redirect:/login";
        }

        // 解放条件の再チェック（安全のため）
        List<Order> orders = orderRepository.findByUserId(userBean.getId());
        int orderCount = orders.size();
        int totalAmount = 0;
        for (Order order : orders) {
            totalAmount += order.getTotal();
        }

        boolean canUnlock = false;
        switch (themeId) {
            case 0: canUnlock = true; break;
            case 1: canUnlock = orderCount >= 1; break;
            case 2: canUnlock = orderCount >= 3; break;
            case 3: canUnlock = orderCount >= 5; break;
            case 4: canUnlock = totalAmount >= 10000; break;
            case 5: canUnlock = orderCount >= 10; break;
            case 6: canUnlock = orderCount >= 20; break;
        }

        if (canUnlock) {
            // DBの情報を更新
            User user = userRepository.findByIdAndDeleteFlag(userBean.getId(), Constant.NOT_DELETED);
            if (user != null) {
                user.setThemeId(themeId);
                userRepository.save(user);
            }

            // セッションの情報を更新
            userBean.setThemeId(themeId);
            session.setAttribute("user", userBean);
        }

        return "redirect:/client/theme/input";
    }
}
