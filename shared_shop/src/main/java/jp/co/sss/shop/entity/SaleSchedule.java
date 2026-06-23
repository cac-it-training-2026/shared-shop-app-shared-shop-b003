package jp.co.sss.shop.entity;

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
     * カテゴリ
     */
    @ManyToOne
    @JoinColumn(name = "category_id", referencedColumnName = "id")
    private Category category;

    /**
     * 開始時間 (HH:mm:ss形式)
     */
    @Column(name = "start_time")
    private String startTime;

    /**
     * 終了時間 (HH:mm:ss形式)
     */
    @Column(name = "end_time")
    private String endTime;

    /**
     * 割引率
     */
    @Column(name = "discount_rate")
    private Integer discountRate;

    /**
     * 削除フラグ 0:未削除、1:削除済み
     */
    @Column(name = "delete_flag", insertable = false)
    private Integer deleteFlag;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public Integer getDiscountRate() {
        return discountRate;
    }

    public void setDiscountRate(Integer discountRate) {
        this.discountRate = discountRate;
    }

    public Integer getDeleteFlag() {
        return deleteFlag;
    }

    public void setDeleteFlag(Integer deleteFlag) {
        this.deleteFlag = deleteFlag;
    }
}
