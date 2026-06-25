-- クーポンテーブルの作成
CREATE TABLE coupons (
    id NUMBER(10) PRIMARY KEY,
    code VARCHAR2(255) UNIQUE NOT NULL,
    discount_type VARCHAR2(50) NOT NULL,
    discount_value NUMBER(10) NOT NULL,
    valid_from TIMESTAMP,
    valid_until TIMESTAMP,
    usage_limit NUMBER(10)
);

-- クーポンID用シーケンスの作成
CREATE SEQUENCE seq_coupons START WITH 1 INCREMENT BY 1;

-- 注文テーブルにクーポン情報を追加
ALTER TABLE orders ADD (
    coupon_id NUMBER(10),
    discount NUMBER(10)
);

-- 外部キー制約の追加
ALTER TABLE orders ADD CONSTRAINT fk_orders_coupon FOREIGN KEY (coupon_id) REFERENCES coupons(id);
