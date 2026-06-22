package jp.co.sss.shop.entity;

import java.time.LocalTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

/**
 * タイムセールスケジュールのエンティティクラス
 */
@Entity
@Table(name = "sale_schedule")
public class SaleSchedule {
	/**
	 * セールID
	 */
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_sale_schedule_gen")
	@SequenceGenerator(name = "seq_sale_schedule_gen", sequenceName = "seq_sale_schedule", allocationSize = 1)
	private Integer id;

	/**
	 * カテゴリ情報
	 */
	@ManyToOne
	@JoinColumn(name = "category_id", referencedColumnName = "id")
	private Category category;

	/**
	 * 開始時間
	 */
	@Column(name = "start_time")
	private LocalTime startTime;

	/**
	 * 終了時間
	 */
	@Column(name = "end_time")
	private LocalTime endTime;

	/**
	 * 割引率
	 */
	@Column(name = "discount_rate")
	private Integer discountRate;

	/**
	 * 有効フラグ
	 */
	@Column(name = "enabled")
	private Integer enabled;

	/**
	 * 残り時間（表示用）
	 */
	@Transient
	private String remainingTime;

	/**
	 * コンストラクタ
	 */
	public SaleSchedule() {
	}

	/**
	 * セールIDの取得
	 * @return セールID
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * セールIDのセット
	 * @param id セールID
	 */
	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * カテゴリの取得
	 * @return カテゴリ
	 */
	public Category getCategory() {
		return category;
	}

	/**
	 * カテゴリのセット
	 * @param category カテゴリ
	 */
	public void setCategory(Category category) {
		this.category = category;
	}

	/**
	 * 開始時間の取得
	 * @return 開始時間
	 */
	public LocalTime getStartTime() {
		return startTime;
	}

	/**
	 * 開始時間のセット
	 * @param startTime 開始時間
	 */
	public void setStartTime(LocalTime startTime) {
		this.startTime = startTime;
	}

	/**
	 * 終了時間の取得
	 * @return 終了時間
	 */
	public LocalTime getEndTime() {
		return endTime;
	}

	/**
	 * 終了時間のセット
	 * @param endTime 終了時間
	 */
	public void setEndTime(LocalTime endTime) {
		this.endTime = endTime;
	}

	/**
	 * 割引率の取得
	 * @return 割引率
	 */
	public Integer getDiscountRate() {
		return discountRate;
	}

	/**
	 * 割引率のセット
	 * @param discountRate 割引率
	 */
	public void setDiscountRate(Integer discountRate) {
		this.discountRate = discountRate;
	}

	/**
	 * 有効フラグの取得
	 * @return 有効フラグ
	 */
	public Integer getEnabled() {
		return enabled;
	}

	/**
	 * 有効フラグのセット
	 * @param enabled 有効フラグ
	 */
	public void setEnabled(Integer enabled) {
		this.enabled = enabled;
	}

	/**
	 * 残り時間の取得
	 * @return 残り時間
	 */
	public String getRemainingTime() {
		return remainingTime;
	}

	/**
	 * 残り時間のセット
	 * @param remainingTime 残り時間
	 */
	public void setRemainingTime(String remainingTime) {
		this.remainingTime = remainingTime;
	}
}
