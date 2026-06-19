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
 * クーポン情報を保持するエンティティクラス
 */
@Entity
@Table(name = "coupons")
public class Coupon {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_coupons_gen")
	@SequenceGenerator(name = "seq_coupons_gen", sequenceName = "seq_coupons", allocationSize = 1)
	private Integer id;

	@Column(unique = true, nullable = false)
	private String code;

	@Column(name = "discount_type", nullable = false)
	private String discountType;

	@Column(name = "discount_value", nullable = false)
	private Integer discountValue;

	@Column(name = "valid_from")
	private Timestamp validFrom;

	@Column(name = "valid_until")
	private Timestamp validUntil;

	@Column(name = "usage_limit")
	private Integer usageLimit;

	@Column(name = "created_by")
	private Integer createdBy;

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

	public Integer getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(Integer createdBy) {
		this.createdBy = createdBy;
	}
}
