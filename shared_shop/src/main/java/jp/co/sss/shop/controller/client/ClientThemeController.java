package jp.co.sss.shop.controller.client;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.util.Constant;

@Controller
public class ClientThemeController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/client/theme/list")
    public String showThemeList(HttpSession session, Model model) {
        UserBean userBean = (UserBean) session.getAttribute("user");
        if (userBean == null) {
            return "redirect:/login";
        }

        User user = userRepository.getReferenceById(userBean.getId());
        model.addAttribute("user", user);
        model.addAttribute("themeClasses", Constant.THEME_CLASSES);
        return "client/theme/list";
    }

    @GetMapping("/client/theme/change/{themeId}")
    public String changeTheme(@PathVariable Integer themeId, HttpSession session) {
        UserBean userBean = (UserBean) session.getAttribute("user");
        if (userBean == null) {
            return "redirect:/login";
        }

        if (themeId >= 0 && themeId < Constant.THEME_CLASSES.length) {
            User user = userRepository.getReferenceById(userBean.getId());

            // 解放条件の簡易チェック
            boolean accessible = false;
            if (themeId == 0) accessible = true; // 通常
            else if (themeId == 1 && user.getPurchaseCount() >= 1) accessible = true; // さくら
            else if (themeId == 2 && user.getPurchaseCount() >= 3) accessible = true; // 海
            else if (themeId == 3 && user.getPurchaseCount() >= 5) accessible = true; // ゲーム
            else if (themeId == 4 && user.getTotalPurchaseAmount() >= 10000) accessible = true; // 宇宙
            else if (themeId == 5 && user.getPurchaseCount() >= 10) accessible = true; // ゴールド
            else if (themeId == 6 && user.getPurchaseCount() >= 20) accessible = true; // P3tech

            if (accessible) {
                user.setThemeId(themeId);
                userRepository.save(user);

                userBean.setThemeClass(Constant.THEME_CLASSES[themeId]);
                session.setAttribute("user", userBean);
            }
        }

        return "redirect:/client/theme/list";
    }
}
