package jp.co.sss.shop.entity;

import java.sql.Timestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;

/**
 * クーポンエンティティ
 *
 * @author Jules
 */
@Entity
@Table(name = "coupons")
public class Coupon {
	/**
	 * クーポンID
	 */
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_coupons_gen")
	@SequenceGenerator(name = "seq_coupons_gen", sequenceName = "seq_coupons", allocationSize = 1)
	private Integer id;

	/**
	 * クーポンコード
	 */
	@Column(unique = true, nullable = false)
	private String code;

	/**
	 * 割引タイプ ("amount" または "percent")
	 */
	@Column(name = "discount_type", nullable = false)
	private String discountType;

	/**
	 * 割引額または割引率
	 */
	@Column(name = "discount_value", nullable = false)
	private Integer discountValue;

	/**
	 * 有効開始日時
	 */
	@Column(name = "valid_from")
	private Timestamp validFrom;

	/**
	 * 有効終了日時
	 */
	@Column(name = "valid_until")
	private Timestamp validUntil;

	/**
	 * 使用上限数
	 */
	@Column(name = "usage_limit")
	private Integer usageLimit;

	/**
	 * ユーザーID (特定ユーザー向けのクーポンの場合)
	 */
	@Column(name = "user_id")
	private Integer userId;

	/**
	 * 作成日時
	 */
	@Column(name = "insert_date", insertable = false, updatable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private Timestamp insertDate;

	// ゲッターとセッター
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getDiscountType() {
		return discountType;
	}

	public void setDiscountType(String discountType) {
		this.discountType = discountType;
	}

	public Integer getDiscountValue() {
		return discountValue;
	}

	public void setDiscountValue(Integer discountValue) {
		this.discountValue = discountValue;
	}

	public Timestamp getValidFrom() {
		return validFrom;
	}

	public void setValidFrom(Timestamp validFrom) {
		this.validFrom = validFrom;
	}

	public Timestamp getValidUntil() {
		return validUntil;
	}

	public void setValidUntil(Timestamp validUntil) {
		this.validUntil = validUntil;
	}

	public Integer getUsageLimit() {
		return usageLimit;
	}

	public void setUsageLimit(Integer usageLimit) {
		this.usageLimit = usageLimit;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public Timestamp getInsertDate() {
		return insertDate;
	}

	public void setInsertDate(Timestamp insertDate) {
		this.insertDate = insertDate;
	}
}
