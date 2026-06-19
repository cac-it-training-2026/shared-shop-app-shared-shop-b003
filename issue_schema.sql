-- ==========================================
-- shared_shop 追加機能用スキーマ更新スクリプト
-- 対象DB: Oracle
-- ==========================================

-- 1. users テーブルへのカラム追加 (Issue #4, #5)
-- 権限管理用のロール、ログイン失敗回数、アカウントロック期限を追加
ALTER TABLE users ADD (
    role VARCHAR2(20) DEFAULT 'USER',
    failed_login_count NUMBER(10,0) DEFAULT 0,
    locked_until TIMESTAMP
);

-- ==========================================

-- 2. reviews テーブル作成 (Issue #6, #8)
-- 商品レビュー情報の保存
CREATE SEQUENCE seq_reviews NOCACHE;

CREATE TABLE reviews (
    id NUMBER(10,0) PRIMARY KEY,
    product_id NUMBER(10,0) NOT NULL,
    user_id NUMBER(10,0) NOT NULL,
    rating NUMBER(1,0) NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment_text VARCHAR2(500),
    created_time TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT fk_reviews_product FOREIGN KEY (product_id) REFERENCES items(id),
    CONSTRAINT fk_reviews_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ==========================================

-- 3. coupons テーブル作成 (Issue #7)
-- クーポンコードと割引条件の保存
CREATE SEQUENCE seq_coupons NOCACHE;

CREATE TABLE coupons (
    id NUMBER(10,0) PRIMARY KEY,
    code VARCHAR2(50) UNIQUE NOT NULL,
    discount_type VARCHAR2(20) NOT NULL CHECK (discount_type IN ('amount', 'percent')),
    discount_value NUMBER(10,0) NOT NULL,
    valid_from TIMESTAMP,
    valid_until TIMESTAMP,
    usage_limit NUMBER(10,0),
    created_by NUMBER(10,0)
);

-- orders テーブルへのカラム追加 (クーポン割引額)
ALTER TABLE orders ADD (
    discount_amount NUMBER(10,0) DEFAULT 0
);

-- ==========================================

-- 4. gacha_logs テーブル作成 (Issue #10)
-- ガチャの実行結果と付与されたクーポンの保存
CREATE SEQUENCE seq_gacha_logs NOCACHE;

CREATE TABLE gacha_logs (
    id NUMBER(10,0) PRIMARY KEY,
    user_id NUMBER(10,0) NOT NULL,
    event_type VARCHAR2(50) NOT NULL,
    outcome VARCHAR2(20) NOT NULL,
    coupon_id NUMBER(10,0),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT fk_gacha_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_gacha_coupon FOREIGN KEY (coupon_id) REFERENCES coupons(id)
);
