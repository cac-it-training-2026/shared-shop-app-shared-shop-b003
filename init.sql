-- ==========================================
-- 1. システムユーザーでの設定（PDB切り替え・ユーザー作成）
-- ==========================================
---- PDBに切り替え
--ALTER SESSION SET CONTAINER = xepdb1;
---- ユーザの作成
--CREATE USER shared_shop_user IDENTIFIED BY systemsss;
---- 権限の付与
--GRANT ALL PRIVILEGES TO shared_shop_user;

-- ==========================================
-- 2. shared_shop_user で接続した後の設定
-- ==========================================

-----------------------------------------------------------------------
/*初期化文*/
-----------------------------------------------------------------------
-- 1. ポイント履歴テーブルの削除（会員に依存）
DROP TABLE point_histories CASCADE CONSTRAINTS;

-- 2. ガチャログテーブルの削除（他からの参照なし）
DROP TABLE gacha_logs CASCADE CONSTRAINTS;

-- 3. 注文商品テーブル（注文と商品に依存）の削除
DROP TABLE order_items CASCADE CONSTRAINTS;

-- 4. レビューテーブル（商品と会員に依存）の削除
DROP TABLE reviews CASCADE CONSTRAINTS;

-- 5. 注文テーブル（会員とクーポンに依存）の削除
DROP TABLE orders CASCADE CONSTRAINTS;

-- 6. 商品テーブル（カテゴリに依存）の削除
DROP TABLE items CASCADE CONSTRAINTS;

-- 7. 会員テーブルの削除
DROP TABLE users CASCADE CONSTRAINTS;

-- 8. カテゴリテーブルの削除
DROP TABLE categories CASCADE CONSTRAINTS;

-- 9. クーポンテーブルの削除
DROP TABLE coupons CASCADE CONSTRAINTS;

-- シーケンスの削除
DROP SEQUENCE seq_order_items;
DROP SEQUENCE seq_orders;
DROP SEQUENCE seq_users;
DROP SEQUENCE seq_items;
DROP SEQUENCE seq_categories;
DROP SEQUENCE seq_reviews;
DROP SEQUENCE seq_coupons;
DROP SEQUENCE seq_gacha_logs;
DROP SEQUENCE seq_point_histories;

PURGE RECYCLEBIN;

-----------------------------------------------------------------------
-- クーポンテーブルの作成
-----------------------------------------------------------------------
CREATE TABLE coupons (
    id NUMBER(10) PRIMARY KEY,
    code VARCHAR2(255) UNIQUE NOT NULL,
    discount_type VARCHAR2(50) NOT NULL,
    discount_value NUMBER(10) NOT NULL,
    valid_from TIMESTAMP,
    valid_until TIMESTAMP,
    usage_limit NUMBER(10),
    user_id NUMBER(10),
    insert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN coupons.id IS 'クーポンID';
COMMENT ON COLUMN coupons.code IS 'クーポンコード';
COMMENT ON COLUMN coupons.discount_type IS '割引タイプ(amount/percent)';
COMMENT ON COLUMN coupons.discount_value IS '割引値(額または率)';
COMMENT ON COLUMN coupons.valid_from IS '有効期限(開始)';
COMMENT ON COLUMN coupons.valid_until IS '有効期限(終了)';
COMMENT ON COLUMN coupons.usage_limit IS '使用可能回数';
COMMENT ON COLUMN coupons.user_id IS '対象ユーザーID';
COMMENT ON COLUMN coupons.insert_date IS '登録日時';

-----------------------------------------------------------------------
-- カテゴリテーブルの作成
-----------------------------------------------------------------------
CREATE TABLE categories (
  id NUMBER(2) PRIMARY KEY,
  name VARCHAR2(15 CHAR) NOT NULL,
  description VARCHAR2(30 CHAR),
  delete_flag NUMBER(1) DEFAULT 0 NOT NULL,
  insert_date DATE DEFAULT SYSDATE NOT NULL
);

COMMENT ON COLUMN categories.id IS 'カテゴリID';
COMMENT ON COLUMN categories.name IS 'カテゴリ名';
COMMENT ON COLUMN categories.description IS 'カテゴリ説明';
COMMENT ON COLUMN categories.delete_flag IS '削除フラグ(0:未削除, 1:削除済)';
COMMENT ON COLUMN categories.insert_date IS '登録日';

-----------------------------------------------------------------------
-- 商品テーブルの作成
-----------------------------------------------------------------------
CREATE TABLE items (
  id NUMBER(6) PRIMARY KEY,
  name VARCHAR2(100 CHAR) NOT NULL,
  price NUMBER(7) NOT NULL,
  description VARCHAR2(400 CHAR),
  stock NUMBER(4) DEFAULT 0 NOT NULL,
  image VARCHAR2(64 CHAR),
  category_id NUMBER(2) REFERENCES categories(id) NOT NULL,
  delete_flag NUMBER(1) DEFAULT 0 NOT NULL,
  insert_date DATE DEFAULT SYSDATE NOT NULL
);

COMMENT ON COLUMN items.id IS '商品ID';
COMMENT ON COLUMN items.name IS '商品名';
COMMENT ON COLUMN items.price IS '価格';
COMMENT ON COLUMN items.description IS '商品説明';
COMMENT ON COLUMN items.stock IS '在庫数';
COMMENT ON COLUMN items.image IS '画像ファイル名';
COMMENT ON COLUMN items.category_id IS 'カテゴリID';
COMMENT ON COLUMN items.delete_flag IS '削除フラグ(0:未削除, 1:削除済)';
COMMENT ON COLUMN items.insert_date IS '登録日';

-----------------------------------------------------------------------
-- 会員テーブルの作成
-----------------------------------------------------------------------
CREATE TABLE users (
  id NUMBER(6) PRIMARY KEY,
  email VARCHAR2(256) UNIQUE NOT NULL,
  password VARCHAR2(16) NOT NULL,
  name VARCHAR2(30 CHAR) NOT NULL,
  postal_code VARCHAR2(7) NOT NULL,
  address VARCHAR2(150 CHAR) NOT NULL,
  phone_number VARCHAR2(11) NOT NULL,
  authority NUMBER(1) NOT NULL,
  delete_flag NUMBER(1) DEFAULT 0 NOT NULL,
  insert_date DATE DEFAULT SYSDATE NOT NULL,
  theme_id NUMBER(1,0) DEFAULT 0,
  purchase_count NUMBER(5) DEFAULT 0,
  total_purchase_amount NUMBER(10) DEFAULT 0,
  current_point NUMBER DEFAULT 0 NOT NULL,
  failed_login_count NUMBER DEFAULT 0,
  locked_until TIMESTAMP
);

COMMENT ON COLUMN users.id IS '会員ID';
COMMENT ON COLUMN users.email IS 'メールアドレス';
COMMENT ON COLUMN users.password IS 'パスワード';
COMMENT ON COLUMN users.name IS '氏名';
COMMENT ON COLUMN users.postal_code IS '郵便番号';
COMMENT ON COLUMN users.address IS '住所';
COMMENT ON COLUMN users.phone_number IS '電話番号';
COMMENT ON COLUMN users.authority IS '権限(0:管理者, 1:運用者, 2:一般)';
COMMENT ON COLUMN users.delete_flag IS '削除フラグ(0:未削除, 1:削除済)';
COMMENT ON COLUMN users.insert_date IS '登録日';
COMMENT ON COLUMN users.theme_id IS 'きせかえテーマID';
COMMENT ON COLUMN users.purchase_count IS '購入回数';
COMMENT ON COLUMN users.total_purchase_amount IS '累計購入金額';
COMMENT ON COLUMN users.current_point IS '保有ポイント数';
COMMENT ON COLUMN users.failed_login_count IS 'ログイン失敗回数';
COMMENT ON COLUMN users.locked_until IS 'アカウントロック解除日時';

-----------------------------------------------------------------------
-- 注文テーブルの作成
-----------------------------------------------------------------------
CREATE TABLE orders (
  id NUMBER(6) PRIMARY KEY,
  postal_code VARCHAR2(7) NOT NULL,
  address VARCHAR2(150 CHAR) NOT NULL,
  name VARCHAR2(30 CHAR) NOT NULL,
  phone_number VARCHAR2(11) NOT NULL,
  pay_method NUMBER(1) NOT NULL,
  user_id NUMBER(6) REFERENCES users(id) NOT NULL,
  insert_date DATE DEFAULT SYSDATE NOT NULL,
  coupon_id NUMBER(10),
  discount NUMBER(10),
  used_point NUMBER DEFAULT 0 NOT NULL,
  payment_amount NUMBER DEFAULT 0 NOT NULL,
  CONSTRAINT fk_orders_coupon FOREIGN KEY (coupon_id) REFERENCES coupons(id)
);

COMMENT ON COLUMN orders.id IS '注文ID';
COMMENT ON COLUMN orders.postal_code IS 'お届け先郵便番号';
COMMENT ON COLUMN orders.address IS 'お届け先住所';
COMMENT ON COLUMN orders.name IS 'お届け先氏名';
COMMENT ON COLUMN orders.phone_number IS 'お届け先電話番号';
COMMENT ON COLUMN orders.pay_method IS '支払方法(1:クレジットカード, 2:銀行振込, 等)';
COMMENT ON COLUMN orders.user_id IS '注文会員ID';
COMMENT ON COLUMN orders.insert_date IS '注文日';
COMMENT ON COLUMN orders.coupon_id IS '適用クーポンID';
COMMENT ON COLUMN orders.discount IS 'クーポン割引額';
COMMENT ON COLUMN orders.used_point IS '利用ポイント数';
COMMENT ON COLUMN orders.payment_amount IS '最終支払金額';

-----------------------------------------------------------------------
-- 注文商品テーブルの作成
-----------------------------------------------------------------------
CREATE TABLE order_items (
  id NUMBER(6) PRIMARY KEY,
  quantity NUMBER(4) NOT NULL,
  order_id NUMBER(6) REFERENCES orders(id) NOT NULL,
  item_id NUMBER(6) REFERENCES items(id) NOT NULL,
  price NUMBER(7) NOT NULL
);

COMMENT ON COLUMN order_items.id IS '注文商品ID';
COMMENT ON COLUMN order_items.quantity IS '数量';
COMMENT ON COLUMN order_items.order_id IS '注文ID';
COMMENT ON COLUMN order_items.item_id IS '商品ID';
COMMENT ON COLUMN order_items.price IS '購入時単価';

-----------------------------------------------------------------------
-- レビューテーブルの作成
-----------------------------------------------------------------------
CREATE TABLE reviews (
    id NUMBER(10) PRIMARY KEY,
    item_id NUMBER(10) NOT NULL,
    user_id NUMBER(10) NOT NULL,
    evaluation NUMBER(1) NOT NULL,
    content VARCHAR2(1000) NOT NULL,
    delete_flag NUMBER(1) DEFAULT 0 NOT NULL,
    insert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    stamp NUMBER(10) DEFAULT 0,
    CONSTRAINT fk_reviews_item FOREIGN KEY (item_id) REFERENCES items(id),
    CONSTRAINT fk_reviews_user FOREIGN KEY (user_id) REFERENCES users(id)
);

COMMENT ON COLUMN reviews.id IS 'レビューID';
COMMENT ON COLUMN reviews.item_id IS '対象商品ID';
COMMENT ON COLUMN reviews.user_id IS '投稿会員ID';
COMMENT ON COLUMN reviews.evaluation IS '評価点数';
COMMENT ON COLUMN reviews.content IS 'レビュー本文';
COMMENT ON COLUMN reviews.delete_flag IS '削除フラグ(0:非表示前, 1:非表示済)';
COMMENT ON COLUMN reviews.insert_date IS '投稿日時';
COMMENT ON COLUMN reviews.stamp IS '高評価スタンプ数';

-----------------------------------------------------------------------
-- ガチャログテーブルの作成
-----------------------------------------------------------------------
CREATE TABLE gacha_logs (
    id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    event_type VARCHAR2(50) NOT NULL,
    outcome VARCHAR2(50) NOT NULL,
    coupon_id NUMBER(10),
    source_order_id NUMBER(10),
    ip_address VARCHAR2(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN gacha_logs.id IS 'ガチャ履歴ID';
COMMENT ON COLUMN gacha_logs.user_id IS '実行会員ID';
COMMENT ON COLUMN gacha_logs.event_type IS '契機イベント(login/order)';
COMMENT ON COLUMN gacha_logs.outcome IS '結果(win/lose)';
COMMENT ON COLUMN gacha_logs.coupon_id IS '当選クーポンID';
COMMENT ON COLUMN gacha_logs.source_order_id IS '契機注文ID';
COMMENT ON COLUMN gacha_logs.ip_address IS 'IPアドレス';
COMMENT ON COLUMN gacha_logs.created_at IS '実行日時';

-----------------------------------------------------------------------
-- ポイント履歴テーブルの作成
-----------------------------------------------------------------------
CREATE TABLE point_histories (
  id NUMBER(6) PRIMARY KEY,
  user_id NUMBER(6) REFERENCES users(id) NOT NULL,
  point NUMBER NOT NULL,
  balance NUMBER NOT NULL,
  type VARCHAR2(20) NOT NULL,
  description VARCHAR2(255),
  created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN point_histories.id IS 'ポイント履歴ID';
COMMENT ON COLUMN point_histories.user_id IS '会員ID';
COMMENT ON COLUMN point_histories.point IS '変動ポイント(正:獲得, 負:利用)';
COMMENT ON COLUMN point_histories.balance IS '変動後ポイント残高';
COMMENT ON COLUMN point_histories.type IS '変動タイプ(USE/EARN)';
COMMENT ON COLUMN point_histories.description IS '履歴詳細説明';
COMMENT ON COLUMN point_histories.created_time IS '履歴発生日時';

-----------------------------------------------------------------------
-- シーケンスの作成
-----------------------------------------------------------------------
CREATE SEQUENCE seq_categories NOCACHE;
CREATE SEQUENCE seq_items NOCACHE;
CREATE SEQUENCE seq_users NOCACHE;
CREATE SEQUENCE seq_orders NOCACHE;
CREATE SEQUENCE seq_order_items NOCACHE;
CREATE SEQUENCE seq_reviews START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_coupons START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE seq_gacha_logs START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_point_histories NOCACHE;

-----------------------------------------------------------------------
-- レコード登録(カテゴリ)
-----------------------------------------------------------------------
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '食料品', '野菜類、肉類、海産物、加工食品などを扱います。', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '書籍', '和書、洋書、専門書、漫画、雑誌などを扱います。', DEFAULT, DEFAULT);

-----------------------------------------------------------------------
-- レコード登録(商品)
-----------------------------------------------------------------------
INSERT INTO items VALUES(seq_items.NEXTVAL, 'りんご', 100, '青森県産のりんごです。とってもみずみずしい！', 0, 'apple.jpg', 1, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, '辞書', 2000, 'これ一冊があれば大丈夫！', 1, 'dictionary.jpg', 2, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'オレンジ', 150, 'オーストラリア産のオレンジです。', 5, NULL, 1, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'バナナ', 150, 'バナナです。', 6, NULL, 1, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'テスト商品', 150, 'テスト用データです。', 9999, NULL, 1, DEFAULT, DEFAULT);

-----------------------------------------------------------------------
-- レコード登録(会員)
-----------------------------------------------------------------------
INSERT INTO users VALUES(seq_users.NEXTVAL, 'tanaka_taro@test.co.jp', 'Testtest0', 'システム管理太郎', '1111111', '東京都台東区1-2-3 ABCビル10階', '0123456789', 0, DEFAULT, DEFAULT, 0, 0, 0, 0, 0, NULL);
INSERT INTO users VALUES(seq_users.NEXTVAL, 'unyo_jiro@test.co.jp', 'Testtest1', '運用管理二郎', '1111111', '東京都台東区1-2-3 ABCビル10階', '0123456789', 1, DEFAULT, DEFAULT, 0, 0, 0, 0, 0, NULL);
INSERT INTO users VALUES(seq_users.NEXTVAL, 'ippan_saburo@test.co.jp', 'Testtest2', '一般三郎', '1111111', '東京都台東区4-5-6 ABCマンション5階', '0123456789', 2, DEFAULT, DEFAULT, 0, 0, 0, 0, 0, NULL);

-----------------------------------------------------------------------
-- レコード登録(注文)
-----------------------------------------------------------------------
INSERT INTO orders VALUES(seq_orders.NEXTVAL, '1111111', '東京都台東区4-5-6 ABCマンション5階', '一般三郎', '0123456789', 2, 3, DEFAULT, NULL, NULL, 0, 0);
INSERT INTO orders VALUES(seq_orders.NEXTVAL, '1111111', '東京都台東区4-5-6 ABCマンション5階', '一般三郎', '0123456789', 2, 3, DEFAULT, NULL, NULL, 0, 0);
INSERT INTO orders VALUES(seq_orders.NEXTVAL, '1111111', '東京都台東区4-5-6 ABCマンション5階', '一般三郎', '0123456789', 2, 3, DEFAULT, NULL, NULL, 0, 0);

-----------------------------------------------------------------------
-- レコード登録(商品注文)
-----------------------------------------------------------------------
INSERT INTO order_items VALUES(seq_order_items.NEXTVAL, 4, 1, 1, 100);
INSERT INTO order_items VALUES(seq_order_items.NEXTVAL, 4, 2, 1, 100);
INSERT INTO order_items VALUES(seq_order_items.NEXTVAL, 4, 3, 1, 100);

-----------------------------------------------------------------------
-- 既存注文の payment_amount を自動計算更新
-----------------------------------------------------------------------
UPDATE orders o
SET payment_amount = (
  SELECT NVL(SUM(oi.price * oi.quantity), 0)
  FROM order_items oi
  WHERE oi.order_id = o.id
)
WHERE payment_amount = 0;

-----------------------------------------------------------------------
-- レコード登録(クーポン初期データ)
-----------------------------------------------------------------------
INSERT INTO coupons (id, code, discount_type, discount_value, valid_from, valid_until, usage_limit)
VALUES (seq_coupons.NEXTVAL, 'WELCOME2026', 'amount', 1000, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + 365, 1);

INSERT INTO coupons (id, code, discount_type, discount_value, valid_from, valid_until, usage_limit)
VALUES (seq_coupons.NEXTVAL, 'SPECIAL10', 'percent', 10, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + 365, 5);

-----------------------------------------------------------------------
-- レコード登録(レビュー初期データ)
-----------------------------------------------------------------------
INSERT INTO reviews (id, item_id, user_id, evaluation, content, delete_flag, insert_date, stamp)
VALUES (seq_reviews.NEXTVAL, 1, 3, 5, 'とてもみずみずしくて美味しいりんごでした！また購入します。', 0, CURRENT_TIMESTAMP, 0);

INSERT INTO reviews (id, item_id, user_id, evaluation, content, delete_flag, insert_date, stamp)
VALUES (seq_reviews.NEXTVAL, 2, 3, 4, '非常に詳しくて分かりやすい辞書です。勉強が捗ります。', 0, CURRENT_TIMESTAMP, 0);

-----------------------------------------------------------------------
-- コミット
-----------------------------------------------------------------------
COMMIT;

-----------------------------------------------------------------------
-- テスト用SQL
-----------------------------------------------------------------------
---- 005
--DELETE order_items; -- 売れ筋商品の削除
--DELETE items; -- 商品情報の削除
--
---- 008
--  -- 売れた数を同じに
--UPDATE order_items SET item_id = 2 where id = 2;
--UPDATE order_items SET item_id = 3 where id = 3;
--
---- 009
--DELETE items WHERE category_id = 2; -- 商品情報の削除
--
---- 011
--UPDATE items SET stock = 1; -- 在庫を1に
--UPDATE items SET stock = 0; -- 在庫を0に
--UPDATE items SET delete_flag = 1; -- 商品を削除
