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

--11. プランナーキーワードテーブルの削除
DROP TABLE planner_keyword_categories CASCADE CONSTRAINTS;

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
DROP SEQUENCE seq_planner_keyword_categories;

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
-- プランナーキーワードテーブルの作成
-----------------------------------------------------------------------
CREATE TABLE planner_keyword_categories (
    id NUMBER(6) PRIMARY KEY,
    keyword VARCHAR2(100 CHAR) NOT NULL,
    category_name VARCHAR2(100 CHAR) NOT NULL
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
CREATE SEQUENCE seq_planner_keyword_categories START WITH 1 INCREMENT BY 1 NOCACHE;

-----------------------------------------------------------------------
-- レコード登録
-----------------------------------------------------------------------
-- レコード登録(カテゴリ)
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '食料品', '野菜類、肉類、海産物、加工食品などを扱います。', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '書籍', '和書、洋書、専門書、漫画、雑誌などを扱います。', DEFAULT, DEFAULT);

-- レコード登録(商品)
INSERT INTO items VALUES(seq_items.NEXTVAL, 'りんご', 100, '青森県産のりんごです。とってもみずみずしい！', 0, 'apple.jpg', 1, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, '辞書', 2000, 'これ一冊があれば大丈夫！', 1, 'dictionary.jpg', 2, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'オレンジ', 150, 'オーストラリア産のオレンジです。', 5, 'orange.jpg', 1, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'バナナ', 150, 'バナナです。', 6, NULL, 1, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'テスト商品', 150, 'テスト用データです。', 9999, NULL, 1, DEFAULT, DEFAULT);

-- レコード登録(会員)
INSERT INTO users VALUES(seq_users.NEXTVAL, 'tanaka_taro@test.co.jp', 'Testtest0', 'システム管理太郎', '1111111', '東京都台東区1-2-3 ABCビル10階', '0123456789', 0, DEFAULT, DEFAULT, 0, 0, 0, 0, 0, NULL);
INSERT INTO users VALUES(seq_users.NEXTVAL, 'unyo_jiro@test.co.jp', 'Testtest1', '運用管理二郎', '1111111', '東京都台東区1-2-3 ABCビル10階', '0123456789', 1, DEFAULT, DEFAULT, 0, 0, 0, 0, 0, NULL);
INSERT INTO users VALUES(seq_users.NEXTVAL, 'ippan_saburo@test.co.jp', 'Testtest2', '一般三郎', '1111111', '東京都台東区4-5-6 ABCマンション5階', '0123456789', 2, DEFAULT, DEFAULT, 0, 0, 0, 0, 0, NULL);

-- レコード登録(注文)
INSERT INTO orders VALUES(seq_orders.NEXTVAL, '1111111', '東京都台東区4-5-6 ABCマンション5階', '一般三郎', '0123456789', 2, 3, DEFAULT, NULL, NULL, 0, 0);
INSERT INTO orders VALUES(seq_orders.NEXTVAL, '1111111', '東京都台東区4-5-6 ABCマンション5階', '一般三郎', '0123456789', 2, 3, DEFAULT, NULL, NULL, 0, 0);
INSERT INTO orders VALUES(seq_orders.NEXTVAL, '1111111', '東京都台東区4-5-6 ABCマンション5階', '一般三郎', '0123456789', 2, 3, DEFAULT, NULL, NULL, 0, 0);

-- レコード登録(商品注文)
INSERT INTO order_items VALUES(seq_order_items.NEXTVAL, 4, 1, 1, 100);
INSERT INTO order_items VALUES(seq_order_items.NEXTVAL, 4, 2, 1, 100);
INSERT INTO order_items VALUES(seq_order_items.NEXTVAL, 4, 3, 1, 100);

-- レコード登録(クーポン・レビュー・セール)
-- クーポン
INSERT INTO coupons (id, code, discount_type, discount_value, valid_from, valid_until, usage_limit)
VALUES (seq_coupons.NEXTVAL, 'WELCOME2026', 'amount', 1000, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + 365, 1);
INSERT INTO coupons (id, code, discount_type, discount_value, valid_from, valid_until, usage_limit)
VALUES (seq_coupons.NEXTVAL, 'SPECIAL10', 'percent', 10, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + 365, 5);

-- レビュー
INSERT INTO reviews (id, item_id, user_id, evaluation, content, delete_flag, insert_date, stamp)
VALUES (seq_reviews.NEXTVAL, 1, 3, 5, 'とてもみずみずしくて美味しいりんごでした！また購入します。', 0, CURRENT_TIMESTAMP, 0);
INSERT INTO reviews (id, item_id, user_id, evaluation, content, delete_flag, insert_date, stamp)
VALUES (seq_reviews.NEXTVAL, 2, 3, 4, '非常に詳しくて分かりやすい辞書です。勉強が捗ります。', 0, CURRENT_TIMESTAMP, 0);

-- タイムセール初期データ
INSERT INTO sale_schedule (id, category_id, start_time, end_time, discount_rate, delete_flag)
VALUES (seq_sale_schedule.NEXTVAL, 1, TO_DATE('00:00:00', 'HH24:MI:SS'), TO_DATE('18:00:00', 'HH24:MI:SS'), 20, 0);
INSERT INTO sale_schedule (id, category_id, start_time, end_time, discount_rate, delete_flag)
VALUES (seq_sale_schedule.NEXTVAL, 2, TO_DATE('20:00:00', 'HH24:MI:SS'), TO_DATE('23:00:00', 'HH24:MI:SS'), 15, 0);

-----------------------------------------------------------------------
-- テスト商品登録(商品)
-----------------------------------------------------------------------
INSERT INTO categories VALUES(seq_categories.NEXTVAL,'PC','パソコン関連商品',0,SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL,'マウス','マウス関連商品',0,SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL,'キーボード','キーボード関連商品',0,SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL,'モニター','モニター関連商品',0,SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL,'マイク','マイク関連商品',0,SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL,'Webカメラ','Webカメラ関連商品',0,SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL,'ゲーム','PCゲーム・コンシューマゲーム機',0,SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL,'家電','最新の電化製品',0,SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL,'日用品','生活に欠かせない消耗品',0,SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL,'ファッション','衣類・アクセサリー',0,SYSDATE);

-- PC
INSERT INTO items VALUES(seq_items.NEXTVAL,'ビジネスノートPC',79800,'仕事向けノートPC',15,NULL,(SELECT id FROM categories WHERE name = 'PC'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'クリエイターPC',158000,'動画編集向け',8,NULL,(SELECT id FROM categories WHERE name = 'PC'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'エントリーPC',59800,'初心者向けPC',20,NULL,(SELECT id FROM categories WHERE name = 'PC'),0,SYSDATE);

-- マウス
INSERT INTO items VALUES(seq_items.NEXTVAL,'Bluetoothマウス',2480,'持ち運び向け',20,NULL,(SELECT id FROM categories WHERE name = 'マウス'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'静音マウス',1980,'クリック音軽減',20,NULL,(SELECT id FROM categories WHERE name = 'マウス'),0,SYSDATE);

-- キーボード
INSERT INTO items VALUES(seq_items.NEXTVAL,'テンキーレスキーボード',4980,'省スペース',15,NULL,(SELECT id FROM categories WHERE name = 'キーボード'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'Bluetoothキーボード',3980,'無線接続',15,NULL,(SELECT id FROM categories WHERE name = 'キーボード'),0,SYSDATE);

-- モニター
INSERT INTO items VALUES(seq_items.NEXTVAL,'34インチウルトラワイドモニター',49800,'作業効率向上',5,NULL,(SELECT id FROM categories WHERE name = 'モニター'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'4Kモニター',59800,'高解像度',5,NULL,(SELECT id FROM categories WHERE name = 'モニター'),0,SYSDATE);

-- マイク
INSERT INTO items VALUES(seq_items.NEXTVAL,'配信用USBマイク',7980,'初心者配信向け',10,NULL,(SELECT id FROM categories WHERE name = 'マイク'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'ダイナミックマイク',15800,'ノイズに強い',5,NULL,(SELECT id FROM categories WHERE name = 'マイク'),0,SYSDATE);

-- Webカメラ
INSERT INTO items VALUES(seq_items.NEXTVAL,'4K Webカメラ',19800,'高画質配信向け',5,NULL,(SELECT id FROM categories WHERE name = 'Webカメラ'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'広角Webカメラ',5980,'会議向け',10,NULL,(SELECT id FROM categories WHERE name = 'Webカメラ'),0,SYSDATE);

-- ゲーム
INSERT INTO items VALUES(seq_items.NEXTVAL,'格闘ゲーム',6980,'オンライン対戦対応',20,NULL,(SELECT id FROM categories WHERE name = 'ゲーム'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'レーシングゲーム',5980,'リアルドライブ体験',20,NULL,(SELECT id FROM categories WHERE name = 'ゲーム'),0,SYSDATE);

-- 家電
INSERT INTO items VALUES(seq_items.NEXTVAL,'ロボット掃除機',29800,'自動掃除',10,NULL,(SELECT id FROM categories WHERE name = '家電'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'空気清浄機',19800,'花粉対策',10,NULL,(SELECT id FROM categories WHERE name = '家電'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'電子レンジ',12800,'一人暮らし向け',10,NULL,(SELECT id FROM categories WHERE name = '家電'),0,SYSDATE);

-- 日用品
INSERT INTO items VALUES(seq_items.NEXTVAL,'ティッシュペーパー',298,'5箱セット',50,NULL,(SELECT id FROM categories WHERE name = '日用品'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'洗濯洗剤',498,'大容量タイプ',30,NULL,(SELECT id FROM categories WHERE name = '日用品'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'歯ブラシセット',398,'3本入り',50,NULL,(SELECT id FROM categories WHERE name = '日用品'),0,SYSDATE);

-- ファッション
INSERT INTO items VALUES(seq_items.NEXTVAL,'無地Tシャツ',1980,'定番アイテム',30,NULL,(SELECT id FROM categories WHERE name = 'ファッション'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'デニムパンツ',4980,'カジュアル向け',20,NULL,(SELECT id FROM categories WHERE name = 'ファッション'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'スニーカー',7980,'人気モデル',15,NULL,(SELECT id FROM categories WHERE name = 'ファッション'),0,SYSDATE);

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
