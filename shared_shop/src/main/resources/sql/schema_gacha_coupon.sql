-- ==========================================
-- クーポン・ガチャ機能用データベース定義 (Oracle 11g対応)
-- ==========================================

-- クーポンテーブル
-- ガチャで当選したクーポンや管理者から付与されたクーポンを保持
CREATE TABLE coupons (
    id NUMBER(10) PRIMARY KEY,
    code VARCHAR2(255) UNIQUE NOT NULL, -- クーポンコード
    discount_type VARCHAR2(50) NOT NULL, -- 'amount' (円) または 'percent' (%)
    discount_value NUMBER(10) NOT NULL,   -- 割引額 または 割引率
    valid_from TIMESTAMP,                -- 有効期限(開始)
    valid_until TIMESTAMP,               -- 有効期限(終了)
    usage_limit NUMBER(10),              -- 使用可能回数
    user_id NUMBER(10),                  -- ユーザーID (NULLの場合は全ユーザー可)
    insert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- クーポンID用シーケンス
CREATE SEQUENCE seq_coupons START WITH 100 INCREMENT BY 1;

-- 既存の注文(orders)テーブルにクーポン適用情報を追加
-- すでにカラムが存在する場合はエラーになります
ALTER TABLE orders ADD (
    coupon_id NUMBER(10),
    discount NUMBER(10)
);

-- 外部キー制約の追加 (クーポン削除時に注文データは残す)
ALTER TABLE orders ADD CONSTRAINT fk_orders_coupon FOREIGN KEY (coupon_id) REFERENCES coupons(id);

-- ガチャログテーブル
-- ガチャの実行履歴を記録
CREATE TABLE gacha_logs (
    id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    event_type VARCHAR2(50) NOT NULL, -- 'login' または 'order'
    outcome VARCHAR2(50) NOT NULL,    -- 'win' または 'lose'
    coupon_id NUMBER(10),             -- 当選したクーポンのID
    source_order_id NUMBER(10),       -- 注文契機の場合の注文ID
    ip_address VARCHAR2(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ガチャログ用シーケンス
CREATE SEQUENCE seq_gacha_logs START WITH 1 INCREMENT BY 1;
