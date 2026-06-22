-- usersテーブルにcurrent_pointカラムを追加
ALTER TABLE users ADD current_point NUMBER DEFAULT 0 NOT NULL;

-- 既存ユーザーのポイントを0で初期化（DEFAULT 0があるので基本不要だが念のため）
UPDATE users SET current_point = 0 WHERE current_point IS NULL;

-- point_historiesテーブルの作成
CREATE TABLE point_histories (
    id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    point NUMBER NOT NULL,
    balance NUMBER NOT NULL,
    type VARCHAR2(20) NOT NULL,
    description VARCHAR2(255),
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_point_histories_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- point_histories用シーケンスの作成
CREATE SEQUENCE seq_point_histories START WITH 1 INCREMENT BY 1;

-- ordersテーブルにポイント利用情報を追加
ALTER TABLE orders ADD used_point NUMBER DEFAULT 0 NOT NULL;
ALTER TABLE orders ADD payment_amount NUMBER DEFAULT 0 NOT NULL;

-- 既存の注文データの支払金額を商品合計金額で更新（簡易的な対応）
-- 本来はサブクエリが必要だが、要件に従いpayment_amountを初期化
UPDATE orders o SET payment_amount = (
    SELECT SUM(oi.price * oi.quantity)
    FROM order_items oi
    WHERE oi.order_id = o.id
) WHERE payment_amount = 0;
