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
 * ガチャログエンティティクラス
 */
@Entity
@Table(name = "gacha_logs")
public class GachaLog {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_gacha_logs_gen")
    @SequenceGenerator(name = "seq_gacha_logs_gen", sequenceName = "seq_gacha_logs", allocationSize = 1)
    private Integer id;

    @Column(nullable = false)
    private Integer userId;

    @Column(nullable = false)
    private String eventType; // "LOGIN", "ORDER"

    @Column(nullable = false)
    private String outcome; // "WIN", "LOSE"

    @Column
    private Integer couponId;

    @Column
    private Integer sourceOrderId;

    @Column
    private String ipAddress;

    @Column(nullable = false, updatable = false, insertable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private Timestamp createdAt;

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getEventType() { return eventType; }
    public void setEventType(String eventType) { this.eventType = eventType; }
    public String getOutcome() { return outcome; }
    public void setOutcome(String outcome) { this.outcome = outcome; }
    public Integer getCouponId() { return couponId; }
    public void setCouponId(Integer couponId) { this.couponId = couponId; }
    public Integer getSourceOrderId() { return sourceOrderId; }
    public void setSourceOrderId(Integer sourceOrderId) { this.sourceOrderId = sourceOrderId; }
    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
