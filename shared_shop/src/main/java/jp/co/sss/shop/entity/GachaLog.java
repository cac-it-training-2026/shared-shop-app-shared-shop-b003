package jp.co.sss.shop.entity;

import java.sql.Timestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;

/**
 * ガチャの実行履歴と結果を保持するエンティティクラス
 */
@Entity
@Table(name = "gacha_logs")
public class GachaLog {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_gacha_logs_gen")
	@SequenceGenerator(name = "seq_gacha_logs_gen", sequenceName = "seq_gacha_logs", allocationSize = 1)
	private Integer id;

	@ManyToOne
	@JoinColumn(name = "user_id", referencedColumnName = "id", nullable = false)
	private User user;

	@Column(name = "event_type", nullable = false)
	private String eventType;

	@Column(nullable = false)
	private String outcome;

	@ManyToOne
	@JoinColumn(name = "coupon_id", referencedColumnName = "id")
	private Coupon coupon;

	@Column(name = "created_at", insertable = false, updatable = false)
	private Timestamp createdAt;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
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

	public Coupon getCoupon() {
		return coupon;
	}

	public void setCoupon(Coupon coupon) {
		this.coupon = coupon;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
}
