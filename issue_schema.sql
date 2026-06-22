-- ==========================================
-- shared_shop スキーマ構築・初期化スクリプト
-- 対象DB: Oracle 11g~
-- ==========================================

--systemユーザで接続後、下記のSQLを実行する想定
-- PDBに切り替え (環境によりコメントアウト)
-- ALTER SESSION SET CONTAINER = xepdb1;
-- ユーザの作成
-- CREATE USER shared_shop_user IDENTIFIED BY systemsss;
-- 権限の付与
-- GRANT ALL PRIVILEGES TO shared_shop_user;

--shared_shop_userで接続した後、下記のテーブル、シーケンス作成及びデータの追加を行う

-----------------------------------------------------------------------
/*初期化文*/
-- 1. 新機能テーブル（依存関係の末端）の削除
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE gacha_logs CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE coupons CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE reviews CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

-- 2. 既存テーブルの削除
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE order_items CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE orders CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE users CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE items CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE categories CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

-- シーケンスの削除
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_gacha_logs';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_coupons';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_reviews';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_order_items';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_orders';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_users';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_items';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_categories';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/

PURGE RECYCLEBIN;

-----------------------------------------------------------------------
-- カテゴリテーブルの作成

CREATE TABLE categories (
  id NUMBER(2) PRIMARY KEY,
  name VARCHAR2(15 CHAR) NOT NULL,
  description VARCHAR2(30 CHAR),
  delete_flag NUMBER(1) DEFAULT 0 NOT NULL,
  insert_date DATE DEFAULT SYSDATE NOT NULL
);

-----------------------------------------------------------------------
-- 商品テーブルの作成

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

CREATE TABLE users (
  id NUMBER(6) PRIMARY KEY,
  email VARCHAR2(256) UNIQUE NOT NULL,
  password VARCHAR2(16) NOT NULL,
  name VARCHAR2(30 CHAR) NOT NULL,
  postal_code VARCHAR2(7) NOT NULL,
  address VARCHAR2(150 CHAR) NOT NULL,
  phone_number VARCHAR2(11) NOT NULL,
  authority NUMBER(1) NOT NULL,
  -- 権限管理用のロール、ログイン失敗回数、アカウントロック期限等を追加 (Issue #4, #5)
  role VARCHAR2(20) DEFAULT 'USER',
  failed_login_count NUMBER(10,0) DEFAULT 0,
  locked_until TIMESTAMP,
  purchase_count NUMBER(10) DEFAULT 0,
  theme_id NUMBER(10) DEFAULT 1,
  total_purchase_amount NUMBER(10) DEFAULT 0,
  delete_flag NUMBER(1) DEFAULT 0 NOT NULL,
  insert_date DATE DEFAULT SYSDATE NOT NULL
);

-----------------------------------------------------------------------
-- 注文テーブルの作成
CREATE TABLE orders (
  id NUMBER(6) PRIMARY KEY,
  postal_code VARCHAR2(7) NOT NULL,
  address VARCHAR2(150 CHAR) NOT NULL,
  name VARCHAR2(30 CHAR) NOT NULL,
  phone_number VARCHAR2(11) NOT NULL,
  pay_method NUMBER(1) NOT NULL,
  user_id NUMBER(6) REFERENCES users(id) NOT NULL,
  -- クーポン割引額を追加 (Issue #7)
  discount_amount NUMBER(10,0) DEFAULT 0,
  insert_date DATE DEFAULT SYSDATE NOT NULL
);

-----------------------------------------------------------------------
-- 注文商品テーブルの作成
CREATE TABLE order_items (
  id NUMBER(6) PRIMARY KEY,
  quantity NUMBER(4) NOT NULL,
  order_id NUMBER(6) REFERENCES orders(id) NOT NULL,
  item_id NUMBER(6) REFERENCES items(id) NOT NULL,
  price NUMBER(7) NOT NULL
);

-----------------------------------------------------------------------
-- 追加機能：レビューテーブル作成 (Issue #6, #8)
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

-----------------------------------------------------------------------
-- 追加機能：クーポンテーブル作成 (Issue #7)
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

-----------------------------------------------------------------------
-- 追加機能：ガチャログテーブル作成 (Issue #10)
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

-----------------------------------------------------------------------
-- シーケンスの作成(カテゴリテーブル用)
CREATE SEQUENCE seq_categories NOCACHE;

-- シーケンスの作成(商品テーブル用)
CREATE SEQUENCE seq_items NOCACHE;

-- シーケンスの作成(会員テーブル用)
CREATE SEQUENCE seq_users NOCACHE;

-- シーケンスの作成(注文テーブル用)
CREATE SEQUENCE seq_orders NOCACHE;

-- シーケンスの作成(注文商品テーブル用)
CREATE SEQUENCE seq_order_items NOCACHE;

-- シーケンスの作成(新機能テーブル用)
CREATE SEQUENCE seq_reviews NOCACHE;
CREATE SEQUENCE seq_coupons NOCACHE;
CREATE SEQUENCE seq_gacha_logs NOCACHE;


-----------------------------------------------------------------------
-- レコード登録(カテゴリ)
INSERT INTO categories (id, name, description) VALUES(seq_categories.NEXTVAL, '食料品', '野菜類、肉類、海産物、加工食品などを扱います。');
INSERT INTO categories (id, name, description) VALUES(seq_categories.NEXTVAL, '書籍', '和書、洋書、専門書、漫画、雑誌などを扱います。');

-- レコード登録(商品)
INSERT INTO items (id, name, price, description, stock, image, category_id) VALUES(seq_items.NEXTVAL, 'りんご', 100, '青森県産のりんごです。とってもみずみずしい！', 0, 'apple.jpg', 1);
INSERT INTO items (id, name, price, description, stock, image, category_id) VALUES(seq_items.NEXTVAL, '辞書', 2000, 'これ一冊があれば大丈夫！', 1, 'dictionary.jpg', 2);
INSERT INTO items (id, name, price, description, stock, image, category_id) VALUES(seq_items.NEXTVAL, 'オレンジ', 150, 'オーストラリア産のオレンジです。', 5, NULL, 1);
INSERT INTO items (id, name, price, description, stock, image, category_id) VALUES(seq_items.NEXTVAL, 'バナナ', 150, 'バナナです。', 6, NULL, 1);
INSERT INTO items (id, name, price, description, stock, image, category_id) VALUES(seq_items.NEXTVAL, 'テスト商品', 150, 'テスト用データです。', 9999, NULL, 1);

-- レコード登録(会員)
INSERT INTO users (id, email, password, name, postal_code, address, phone_number, authority, role) VALUES(seq_users.NEXTVAL, 'tanaka_taro@test.co.jp', 'Testtest0', 'システム管理太郎', '1111111', '東京都台東区1-2-3 ABCビル10階', '0123456789', 0, 'SYSTEM_ADMIN');
INSERT INTO users (id, email, password, name, postal_code, address, phone_number, authority, role) VALUES(seq_users.NEXTVAL, 'unyo_jiro@test.co.jp', 'Testtest1', '運用管理二郎', '1111111', '東京都台東区1-2-3 ABCビル10階', '0123456789', 1, 'ADMIN');
INSERT INTO users (id, email, password, name, postal_code, address, phone_number, authority, role) VALUES(seq_users.NEXTVAL, 'ippan_saburo@test.co.jp', 'Testtest2', '一般三郎', '1111111', '東京都台東区4-5-6 ABCマンション5階', '0123456789', 2, 'USER');

-- レコード登録(注文)
INSERT INTO orders (id, postal_code, address, name, phone_number, pay_method, user_id) VALUES(seq_orders.NEXTVAL, '1111111', '東京都台東区4-5-6 ABCマンション5階', '一般三郎', '0123456789', 2, 3);
INSERT INTO orders (id, postal_code, address, name, phone_number, pay_method, user_id) VALUES(seq_orders.NEXTVAL, '1111111', '東京都台東区4-5-6 ABCマンション5階', '一般三郎', '0123456789', 2, 3);
INSERT INTO orders (id, postal_code, address, name, phone_number, pay_method, user_id) VALUES(seq_orders.NEXTVAL, '1111111', '東京都台東区4-5-6 ABCマンション5階', '一般三郎', '0123456789', 2, 3);

-- レコード登録(商品注文)
INSERT INTO order_items (id, quantity, order_id, item_id, price) VALUES(seq_order_items.NEXTVAL, 4, 1, 1, 100);
INSERT INTO order_items (id, quantity, order_id, item_id, price) VALUES(seq_order_items.NEXTVAL, 4, 2, 1, 100);
INSERT INTO order_items (id, quantity, order_id, item_id, price) VALUES(seq_order_items.NEXTVAL, 4, 3, 1, 100);

-- レコード登録(テスト用クーポン)
INSERT INTO coupons (id, code, discount_type, discount_value, valid_from, valid_until, usage_limit, created_by) VALUES (seq_coupons.NEXTVAL, 'TEST500', 'amount', 500, SYSTIMESTAMP, SYSTIMESTAMP + 365, 100, 2);
INSERT INTO coupons (id, code, discount_type, discount_value, valid_from, valid_until, usage_limit, created_by) VALUES (seq_coupons.NEXTVAL, 'HALF', 'percent', 50, SYSTIMESTAMP, SYSTIMESTAMP + 365, 100, 2);

-----------------------------------------------------------------------
-- コミット
COMMIT;

-- （以下、提供されたテストデータの削除/更新用コマンド）
-- 005
-- DELETE order_items; -- 売れ筋商品の削除
-- DELETE items; -- 商品情報の削除

-- 008
-- 売れた数を同じに
-- UPDATE order_items SET item_id = 2 where id = 2;
-- UPDATE order_items SET item_id = 3 where id = 3;

-- 009
-- DELETE items WHERE category_id = 2; -- 商品情報の削除

-- 011
-- UPDATE items SET stock = 1; -- 在庫を1に
-- UPDATE items SET stock = 0; -- 在庫を0に
-- UPDATE items SET delete_flag = 1; -- 商品を削除
