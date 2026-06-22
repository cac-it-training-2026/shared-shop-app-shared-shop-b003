package jp.co.sss.shop.controller.client.user;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.util.Constant;

/**
 * テーマ変更機能のコントローラクラス
 */
@Controller
public class ClientThemeController {

    @Autowired
    UserRepository userRepository;

    @Autowired
    HttpSession session;

    /**
     * テーマ変更画面表示処理
     *
     * @param model Viewとの値受渡し
     * @return "client/user/theme_input" テーマ変更画面表示
     */
    @RequestMapping(path = "/client/theme/input", method = RequestMethod.GET)
    public String themeInput(Model model) {
        UserBean userBean = (UserBean) session.getAttribute("user");
        if (userBean == null) {
            return "redirect:/login";
        }
        model.addAttribute("themeId", userBean.getThemeId());
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

        // DBの情報を更新
        User user = userRepository.findByIdAndDeleteFlag(userBean.getId(), Constant.NOT_DELETED);
        if (user != null) {
            user.setThemeId(themeId);
            userRepository.save(user);
        }

        // セッションの情報を更新
        userBean.setThemeId(themeId);
        session.setAttribute("user", userBean);

        return "redirect:/";
    }
}
