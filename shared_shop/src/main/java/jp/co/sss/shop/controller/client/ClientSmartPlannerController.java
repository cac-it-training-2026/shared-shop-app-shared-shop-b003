package jp.co.sss.shop.controller.client;

import java.util.List;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Planner;
import jp.co.sss.shop.form.SmartPlannerForm;
import jp.co.sss.shop.repository.PlannerRepository;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.service.SmartPlannerService;
import jp.co.sss.shop.service.SmartPlannerService.RecommendedSet;

/**
 * スマート購入プランナーのコントローラクラス
 */
@Controller
public class ClientSmartPlannerController {

    @Autowired
    SmartPlannerService smartPlannerService;

    @Autowired
    UserRepository userRepository;

    @Autowired
    PlannerRepository plannerRepository;

    @Autowired
    HttpSession session;

    /**
     * 入力画面表示
     *
     * @param model Viewとの値受渡し
     * @return "client/planner/input" 入力画面へ
     */
    @RequestMapping(path = "/client/planner/input", method = RequestMethod.GET)
    public String input(Model model) {
        if (!model.containsAttribute("smartPlannerForm")) {
            model.addAttribute("smartPlannerForm", new SmartPlannerForm());
        }
        return "client/planner/input";
    }

    /**
     * 提案実行・結果表示
     *
     * @param form   入力フォーム
     * @param result 入力チェック結果
     * @param model  Viewとの値受渡し
     * @return "client/planner/result" 結果画面へ
     */
    @RequestMapping(path = "/client/planner/result", method = RequestMethod.POST)
    public String result(@Valid @ModelAttribute SmartPlannerForm form, BindingResult result, Model model) {
        if (result.hasErrors()) {
            return "client/planner/input";
        }

        // 提案生成
        List<RecommendedSet> recommendedSets = smartPlannerService.generateRecommendedSets(form.getUseCase(), form.getBudget());

        // 提案理由などの補足情報を設定
        model.addAttribute("recommendedSets", recommendedSets);
        model.addAttribute("useCase", form.getUseCase());
        model.addAttribute("budget", form.getBudget());

        // 利用目的と予算をDBに保存 (ログインユーザーのみ)
        UserBean userBean = (UserBean) session.getAttribute("user");
        if (userBean != null) {
            Planner planner = new Planner();
            planner.setUseCase(form.getUseCase());
            planner.setBudget(form.getBudget());
            planner.setUser(userRepository.getReferenceById(userBean.getId()));
            plannerRepository.save(planner);
        }

        return "client/planner/result";
    }
}
