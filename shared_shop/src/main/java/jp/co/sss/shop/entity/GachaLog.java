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
 * ガチャログエンティティ
 *
 * @author Jules
 */
@Entity
@Table(name = "gacha_logs")
public class GachaLog {
	/**
	 * ログID
	 */
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_gacha_logs_gen")
	@SequenceGenerator(name = "seq_gacha_logs_gen", sequenceName = "seq_gacha_logs", allocationSize = 1)
	private Integer id;

	/**
	 * ユーザーID
	 */
	@Column(name = "user_id", nullable = false)
	private Integer userId;

	/**
	 * イベントタイプ ("login" または "order")
	 */
	@Column(name = "event_type", nullable = false)
	private String eventType;

	/**
	 * 結果 ("win" または "lose")
	 */
	@Column(nullable = false)
	private String outcome;

	/**
	 * 当選したクーポンID (外れの場合はnull)
	 */
	@Column(name = "coupon_id")
	private Integer couponId;

	/**
	 * 元の注文ID (注文完了イベントの場合)
	 */
	@Column(name = "source_order_id")
	private Integer sourceOrderId;

	/**
	 * IPアドレス
	 */
	@Column(name = "ip_address")
	private String ipAddress;

	/**
	 * 作成日時
	 */
	@Column(name = "created_at", insertable = false, updatable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private Timestamp createdAt;

	// ゲッターとセッター
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public String getEventType() {
		return eventType;
	}

	public void setEventType(String eventType) {
		this.eventType = eventType;
	}

	public String getOutcome() {
		return outcome;
	}

	public void setOutcome(String outcome) {
		this.outcome = outcome;
	}

	public Integer getCouponId() {
		return couponId;
	}

	public void setCouponId(Integer couponId) {
		this.couponId = couponId;
	}

	public Integer getSourceOrderId() {
		return sourceOrderId;
	}

	public void setSourceOrderId(Integer sourceOrderId) {
		this.sourceOrderId = sourceOrderId;
	}

	public String getIpAddress() {
		return ipAddress;
	}

	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
}
