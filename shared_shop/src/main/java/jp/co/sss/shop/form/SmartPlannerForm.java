package jp.co.sss.shop.form;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * スマート購入プランナーのフォームクラス
 */
public class SmartPlannerForm implements Serializable {

    /** 用途 */
    @NotBlank
    private String useCase;

    /** 予算 */
    @NotNull
    @Min(0)
    private Integer budget;

    /**
     * 用途の取得
     * @return 用途
     */
    public String getUseCase() {
        return useCase;
    }

    /**
     * 用途のセット
     * @param useCase 用途
     */
    public void setUseCase(String useCase) {
        this.useCase = useCase;
    }

    /**
     * 予算の取得
     * @return 予算
     */
    public Integer getBudget() {
        return budget;
    }

    /**
     * 予算のセット
     * @param budget 予算
     */
    public void setBudget(Integer budget) {
        this.budget = budget;
    }
}
