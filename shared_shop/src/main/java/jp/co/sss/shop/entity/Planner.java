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
 * スマート購入プランナー情報のエンティティクラス
 */
@Entity
@Table(name = "planners")
public class Planner {
	/**
	 * プランナーID
	 */
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_planners_gen")
	@SequenceGenerator(name = "seq_planners_gen", sequenceName = "seq_planners", allocationSize = 1)
	private Integer id;

	/**
	 * 利用目的（用途）
	 */
	@Column(name = "use_case")
	private String useCase;

	/**
	 * 予算
	 */
	@Column
	private Integer budget;

	/**
	 * 会員情報
	 */
	@ManyToOne
	@JoinColumn(name = "user_id", referencedColumnName = "id")
	private User user;

	/**
	 * 登録日時
	 */
	@Column(name = "insert_date", insertable = false, updatable = false)
	private Timestamp insertDate;

	/**
	 * プランナーIDの取得
	 * @return プランナーID
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * プランナーIDのセット
	 * @param id プランナーID
	 */
	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * 利用目的の取得
	 * @return 利用目的
	 */
	public String getUseCase() {
		return useCase;
	}

	/**
	 * 利用目的のセット
	 * @param useCase 利用目的
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
	 * 登録日時の取得
	 * @return 登録日時
	 */
	public Timestamp getInsertDate() {
		return insertDate;
	}

	/**
	 * 登録日時のセット
	 * @param insertDate 登録日時
	 */
	public void setInsertDate(Timestamp insertDate) {
		this.insertDate = insertDate;
	}
}
