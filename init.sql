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

-- 2. タイムセール用テーブルの削除（カテゴリに依存）
DROP TABLE sale_schedule CASCADE CONSTRAINTS;

-- 3. ガチャログテーブルの削除（他からの参照なし）
DROP TABLE gacha_logs CASCADE CONSTRAINTS;

-- 4. 注文商品テーブル（注文と商品に依存）の削除
DROP TABLE order_items CASCADE CONSTRAINTS;

-- 5. レビューテーブル（商品と会員に依存）の削除
DROP TABLE reviews CASCADE CONSTRAINTS;

-- 6. 注文テーブル（会員とクーポンに依存）の削除
DROP TABLE orders CASCADE CONSTRAINTS;

-- 7. 商品テーブル（カテゴリに依存）の削除
DROP TABLE items CASCADE CONSTRAINTS;

-- 8. 会員テーブルの削除
DROP TABLE users CASCADE CONSTRAINTS;

-- 9. カテゴリテーブルの削除
DROP TABLE categories CASCADE CONSTRAINTS;

-- 10. クーポンテーブルの削除
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
DROP SEQUENCE seq_sale_schedule;

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

-----------------------------------------------------------------------
-- タイムセール用テーブルの作成
-----------------------------------------------------------------------
CREATE TABLE sale_schedule (
    id NUMBER(10) PRIMARY KEY,
    category_id NUMBER(10),
    start_time DATE,
    end_time DATE,
    discount_rate NUMBER(3),
    delete_flag NUMBER(1) DEFAULT 0 NOT NULL,
    CONSTRAINT fk_sale_category FOREIGN KEY (category_id) REFERENCES categories(id)
);

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
CREATE SEQUENCE seq_sale_schedule START WITH 1 INCREMENT BY 1;

-----------------------------------------------------------------------
-- レコード登録
-----------------------------------------------------------------------
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '食料品', '野菜類、肉類、海産物、加工食品などを扱います。', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '書籍', '和書、洋書、専門書、漫画、雑誌などを扱います。', DEFAULT, DEFAULT);

INSERT INTO items VALUES(seq_items.NEXTVAL, 'りんご', 100, '青森県産のりんごです。とってもみずみずしい！', 0, 'apple.jpg', 1, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, '辞書', 2000, 'これ一冊があれば大丈夫！', 1, 'dictionary.jpg', 2, DEFAULT, DEFAULT);

INSERT INTO users VALUES(seq_users.NEXTVAL, 'tanaka_taro@test.co.jp', 'Testtest0', 'システム管理太郎', '1111111', '東京都台東区1-2-3 ABCビル10階', '0123456789', 0, DEFAULT, DEFAULT, 0, 0, 0, 0, 0, NULL);
INSERT INTO users VALUES(seq_users.NEXTVAL, 'ippan_saburo@test.co.jp', 'Testtest2', '一般三郎', '1111111', '東京都台東区4-5-6 ABCマンション5階', '0123456789', 2, DEFAULT, DEFAULT, 0, 0, 0, 0, 0, NULL);

INSERT INTO orders VALUES(seq_orders.NEXTVAL, '1111111', '東京都台東区4-5-6 ABCマンション5階', '一般三郎', '0123456789', 2, 2, DEFAULT, NULL, NULL, 0, 0);

INSERT INTO order_items VALUES(seq_order_items.NEXTVAL, 4, 1, 1, 100);

UPDATE orders o SET payment_amount = (SELECT NVL(SUM(oi.price * oi.quantity), 0) FROM order_items oi WHERE oi.order_id = o.id) WHERE payment_amount = 0;

INSERT INTO coupons (id, code, discount_type, discount_value, valid_from, valid_until, usage_limit)
VALUES (seq_coupons.NEXTVAL, 'WELCOME2026', 'amount', 1000, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + 365, 1);

INSERT INTO reviews (id, item_id, user_id, evaluation, content, delete_flag, insert_date, stamp)
VALUES (seq_reviews.NEXTVAL, 1, 2, 5, 'とても美味しいりんごでした！', 0, CURRENT_TIMESTAMP, 0);

-- タイムセール初期データ
INSERT INTO sale_schedule (id, category_id, start_time, end_time, discount_rate, delete_flag)
VALUES (seq_sale_schedule.NEXTVAL, 1, TO_DATE('00:00:00', 'HH24:MI:SS'), TO_DATE('18:00:00', 'HH24:MI:SS'), 20, 0);

COMMIT;

-----------------------------------------------------------------------
-- テスト用SQL
-----------------------------------------------------------------------
-- 005
-- DELETE order_items;
-- DELETE items;

-- 008
-- UPDATE order_items SET item_id = 2 where id = 2;

-- 009
-- DELETE items WHERE category_id = 2;

-- 011
-- UPDATE items SET stock = 1;
-- UPDATE items SET stock = 0;
-- UPDATE items SET delete_flag = 1;
