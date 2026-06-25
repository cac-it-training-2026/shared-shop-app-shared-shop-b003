package jp.co.sss.shop.bean;

import java.io.Serializable;

/**
 * クーポン情報クラス
 */
public class CouponBean implements Serializable {
    private Integer id;
    private String code;
    private String discountType;
    private Integer discountValue;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }
    public Integer getDiscountValue() { return discountValue; }
    public void setDiscountValue(Integer discountValue) { this.discountValue = discountValue; }
}
