package jp.co.sss.shop.controller.client;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.service.GachaService;
import jp.co.sss.shop.service.GachaService.GachaResult;

@Controller
public class GachaController {

    @Autowired
    private GachaService gachaService;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/client/gacha")
    public String showGacha(HttpSession session, Model model) {
        UserBean userBean = (UserBean) session.getAttribute("user");
        if (userBean == null) {
            return "redirect:/login";
        }

        User user = userRepository.getReferenceById(userBean.getId());
        model.addAttribute("gachaCount", user.getGachaCount());
        return "client/gacha";
    }

    @PostMapping("/client/gacha/play")
    public String playGacha(HttpSession session, HttpServletRequest request, Model model) {
        UserBean userBean = (UserBean) session.getAttribute("user");
        if (userBean == null) {
            return "redirect:/login";
        }

        try {
            GachaResult result = gachaService.playGacha(userBean.getId(), request.getRemoteAddr());

            // セッションのチケット数を更新
            User user = userRepository.getReferenceById(userBean.getId());
            userBean.setGachaCount(user.getGachaCount());
            session.setAttribute("user", userBean);

            model.addAttribute("result", result);
            model.addAttribute("gachaCount", user.getGachaCount());
        } catch (Exception e) {
            model.addAttribute("errorMessage", e.getMessage());
        }

        return "client/gacha";
    }
}
