--systemユーザで接続後、下記のSQLを実行する。
-- PDBに切り替え
ALTER SESSION SET CONTAINER = xepdb1;
-- ユーザの作成
CREATE USER shared_shop_user IDENTIFIED BY systemsss;
-- 権限の付与
GRANT ALL PRIVILEGES TO shared_shop_user;

--shared_shop_userで接続した後、下記のテーブル、シーケンス作成及びデータの追加を行う


-----------------------------------------------------------------------
/*初期化文*/
-- 1. 注文商品テーブル（注文と商品に依存）の削除
DROP TABLE order_items CASCADE CONSTRAINTS;

-- 2. 注文テーブル（会員に依存）の削除
DROP TABLE orders CASCADE CONSTRAINTS;

-- 3. 会員テーブルの削除
DROP TABLE users CASCADE CONSTRAINTS;

-- 4. 商品テーブル（カテゴリに依存）の削除
DROP TABLE items CASCADE CONSTRAINTS;

-- 5. カテゴリテーブルの削除
DROP TABLE categories CASCADE CONSTRAINTS;

-- 6. レビューテーブルの削除
DROP TABLE reviews;

-- シーケンスの削除
DROP SEQUENCE seq_order_items;
DROP SEQUENCE seq_orders;
DROP SEQUENCE seq_users;
DROP SEQUENCE seq_items;
DROP SEQUENCE seq_categories;
DROP SEQUENCE seq_reviews;

PURGE RECYCLEBIN;

-----------------------------------------------------------------------
-- カテゴリテーブルの作成

-- 削除フラグが初期値0
CREATE TABLE categories (
  id NUMBER(2) PRIMARY KEY,
  name VARCHAR2(15 CHAR) NOT NULL,
  description VARCHAR2(30 CHAR),
  delete_flag NUMBER(1) DEFAULT 0 NOT NULL,
  insert_date DATE DEFAULT SYSDATE NOT NULL
);

-- 削除フラグが初期値1 データ非表示テスト用
-- CREATE TABLE categories (
--   id NUMBER(2) PRIMARY KEY,
--   name VARCHAR2(15 CHAR) NOT NULL,
--   description VARCHAR2(30 CHAR),
--   delete_flag NUMBER(1) DEFAULT 1 NOT NULL,
--   insert_date DATE DEFAULT SYSDATE NOT NULL
-- );

-----------------------------------------------------------------------
-- 商品テーブルの作成

-- 削除フラグが初期値0
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

-- 削除フラグが初期値1 データ非表示テスト用
-- CREATE TABLE items (
--   id NUMBER(6) PRIMARY KEY,
--   name VARCHAR2(100 CHAR) NOT NULL,
--   price NUMBER(7) NOT NULL,
--   description VARCHAR2(400 CHAR),
--   stock NUMBER(4) DEFAULT 0 NOT NULL,
--   image VARCHAR2(64 CHAR),
--   category_id NUMBER(2) REFERENCES categories(id) NOT NULL,
--   delete_flag NUMBER(1) DEFAULT 1 NOT NULL,
--   insert_date DATE DEFAULT SYSDATE NOT NULL
-- );


-----------------------------------------------------------------------

-- 会員テーブルの作成

-- 削除フラグが初期値0
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
  insert_date DATE DEFAULT SYSDATE NOT NULL
);

-- 削除フラグが初期値1 データ非表示テスト用
-- CREATE TABLE users (
--   id NUMBER(6) PRIMARY KEY,
--   email VARCHAR2(256) UNIQUE NOT NULL,
--   password VARCHAR2(16) NOT NULL,
--   name VARCHAR2(30 CHAR) NOT NULL,
--   postal_code VARCHAR2(7) NOT NULL,
--   address VARCHAR2(150 CHAR) NOT NULL,
--   phone_number VARCHAR2(11) NOT NULL,
--   authority NUMBER(1) NOT NULL,
--   delete_flag NUMBER(1) DEFAULT 1 NOT NULL,
--   insert_date DATE DEFAULT SYSDATE NOT NULL
-- );


-----------------------------------------------------------------------
-- 注文テーブル
CREATE TABLE orders (
  id NUMBER(6) PRIMARY KEY,
  postal_code VARCHAR2(7) NOT NULL,
  address VARCHAR2(150 CHAR) NOT NULL,
  name VARCHAR2(30 CHAR) NOT NULL,
  phone_number VARCHAR2(11) NOT NULL,
  pay_method NUMBER(1) NOT NULL,
  user_id NUMBER(6) REFERENCES users(id) NOT NULL,
  insert_date DATE DEFAULT SYSDATE NOT NULL
);


-----------------------------------------------------------------------
-- 注文商品テーブル
CREATE TABLE order_items (
  id NUMBER(6) PRIMARY KEY,
  quantity NUMBER(4) NOT NULL,
  order_id NUMBER(6) REFERENCES orders(id) NOT NULL,
  item_id NUMBER(6) REFERENCES items(id) NOT NULL,
  price NUMBER(7) NOT NULL
);

-----------------------------------------------------------------------
-- レビューテーブルの作成
CREATE TABLE reviews (
    id NUMBER(10) PRIMARY KEY,
    item_id NUMBER(10) NOT NULL,
    user_id NUMBER(10) NOT NULL,
    rating NUMBER(1) NOT NULL,
    body VARCHAR2(1000) NOT NULL,
    delete_flag NUMBER(1) DEFAULT 0 NOT NULL,
    insert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_reviews_item FOREIGN KEY (item_id) REFERENCES items(id),
    CONSTRAINT fk_reviews_user FOREIGN KEY (user_id) REFERENCES users(id)
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

-- シーケンスの作成(レビューテーブル用)
CREATE SEQUENCE seq_reviews START WITH 1 INCREMENT BY 1;



-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- レコード登録(カテゴリ)
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '食料品', '野菜類、肉類、海産物、加工食品などを扱います。', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '書籍', '和書、洋書、専門書、漫画、雑誌などを扱います。', DEFAULT, DEFAULT);

-- レコード登録(商品)
INSERT INTO items VALUES(seq_items.NEXTVAL, 'りんご', 100, '青森県産のりんごです。とってもみずみずしい！', 0, 'apple.jpg', 1, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, '辞書', 2000, 'これ一冊があれば大丈夫！', 1, 'dictionary.jpg', 2, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'オレンジ', 150, 'オーストラリア産のオレンジです。', 5, NULL, 1, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'バナナ', 150, 'バナナです。', 6, NULL, 1, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'テスト商品', 150, 'テスト用データです。', 9999, NULL, 1, DEFAULT, DEFAULT);

-- レコード登録(会員)
INSERT INTO users VALUES(seq_users.NEXTVAL, 'tanaka_taro@test.co.jp', 'Testtest0', 'システム管理太郎', '1111111', '東京都台東区1-2-3 ABCビル10階', '0123456789', 0, DEFAULT, DEFAULT);
INSERT INTO users VALUES(seq_users.NEXTVAL, 'unyo_jiro@test.co.jp', 'Testtest1', '運用管理二郎', '1111111', '東京都台東区1-2-3 ABCビル10階', '0123456789', 1, DEFAULT, DEFAULT);
INSERT INTO users VALUES(seq_users.NEXTVAL, 'ippan_saburo@test.co.jp', 'Testtest2', '一般三郎', '1111111', '東京都台東区4-5-6 ABCマンション5階', '0123456789', 2, DEFAULT, DEFAULT);


-- データ件数テスト等で行を追加
-- レコード登録(注文)
INSERT INTO orders VALUES(seq_orders.NEXTVAL, '1111111', '東京都台東区4-5-6 ABCマンション5階', '一般三郎', '0123456789', 2, 3, DEFAULT);
INSERT INTO orders VALUES(seq_orders.NEXTVAL, '1111111', '東京都台東区4-5-6 ABCマンション5階', '一般三郎', '0123456789', 2, 3, DEFAULT);
INSERT INTO orders VALUES(seq_orders.NEXTVAL, '1111111', '東京都台東区4-5-6 ABCマンション5階', '一般三郎', '0123456789', 2, 3, DEFAULT);

-- データ件数テスト等で行を追加
-- レコード登録(商品注文)
INSERT INTO order_items VALUES(seq_order_items.NEXTVAL, 4, 1, 1, 100);
INSERT INTO order_items VALUES(seq_order_items.NEXTVAL, 4, 2, 1, 100);
INSERT INTO order_items VALUES(seq_order_items.NEXTVAL, 4, 3, 1, 100);



-----------------------------------------------------------------------

-- usersテーブルにテーマID、購入回数、累計購入金額のカラムを追加
ALTER TABLE users ADD purchase_count NUMBER(10) DEFAULT 0;
ALTER TABLE users ADD theme_id NUMBER(10) DEFAULT 1;
ALTER TABLE users ADD total_purchase_amount NUMBER(10) DEFAULT 0;

-----------------------------------------------------------------------
-- コミット
COMMIT;




-- テスト用SQL
-- 005
DELETE order_items; -- 売れ筋商品の削除
DELETE items; -- 商品情報の削除


-- 008
  -- 売れた数を同じに
UPDATE order_items SET item_id = 2 where id = 2;
UPDATE order_items SET item_id = 3 where id = 3;

-- 009
DELETE items WHERE category_id = 2; -- 商品情報の削除

-- 011
UPDATE items SET stock = 1; -- 在庫を1に
UPDATE items SET stock = 0; -- 在庫を0に
UPDATE items SET delete_flag = 1; -- 商品を削除