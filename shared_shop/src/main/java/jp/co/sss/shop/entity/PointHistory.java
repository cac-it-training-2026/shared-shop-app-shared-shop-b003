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
 * ポイント履歴情報エンティティクラス
 *
 */
@Entity
@Table(name = "point_histories")
public class PointHistory {

	/**
	 * ポイント履歴ID
	 */
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_point_histories_gen")
	@SequenceGenerator(name = "seq_point_histories_gen", sequenceName = "seq_point_histories", allocationSize = 1)
	private Integer id;

	/**
	 * 会員情報
	 */
	@ManyToOne
	@JoinColumn(name = "user_id", referencedColumnName = "id")
	private User user;

	/**
	 * 増減ポイント
	 */
	@Column
	private Integer point;

	/**
	 * 処理後の残高
	 */
	@Column
	private Integer balance;

	/**
	 * 種類
	 */
	@Column
	private String type;

	/**
	 * 内容
	 */
	@Column
	private String description;

	/**
	 * 作成日時
	 */
	@Column(insertable = false, updatable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private Timestamp createdTime;

	/**
	 * ポイント履歴IDの取得
	 * @return ポイント履歴ID
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * ポイント履歴IDのセット
	 * @param id ポイント履歴ID
	 */
	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * 会員情報の取得
	 * @return 会員情報
	 */
	public User getUser() {
		return user;
	}

	/**
	 * 会員情報のセット
	 * @param user 会員情報
	 */
	public void setUser(User user) {
		this.user = user;
	}

	/**
	 * 増減ポイントの取得
	 * @return 増減ポイント
	 */
	public Integer getPoint() {
		return point;
	}

	/**
	 * 増減ポイントのセット
	 * @param point 増減ポイント
	 */
	public void setPoint(Integer point) {
		this.point = point;
	}

	/**
	 * 処理後の残高の取得
	 * @return 処理後の残高
	 */
	public Integer getBalance() {
		return balance;
	}

	/**
	 * 処理後の残高のセット
	 * @param balance 処理後の残高
	 */
	public void setBalance(Integer balance) {
		this.balance = balance;
	}

	/**
	 * 種類の取得
	 * @return 種類
	 */
	public String getType() {
		return type;
	}

	/**
	 * 種類のセット
	 * @param type 種類
	 */
	public void setType(String type) {
		this.type = type;
	}

	/**
	 * 内容の取得
	 * @return 内容
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * 内容のセット
	 * @param description 内容
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * 作成日時の取得
	 * @return 作成日時
	 */
	public Timestamp getCreatedTime() {
		return createdTime;
	}

	/**
	 * 作成日時のセット
	 * @param createdTime 作成日時
	 */
	public void setCreatedTime(Timestamp createdTime) {
		this.createdTime = createdTime;
	}
}
