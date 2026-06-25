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
    content VARCHAR2(1000),
    delete_flag NUMBER(1) DEFAULT 0 NOT NULL,
    insert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    approved NUMBER(1) DEFAULT 1 NOT NULL,
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
INSERT INTO items VALUES(seq_items.NEXTVAL, 'バナナ', 150, 'バナナです。', 6, 'banana.jpg', 1, DEFAULT, DEFAULT);
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
INSERT INTO items VALUES(seq_items.NEXTVAL,'ビジネスノートPC',79800,'仕事向けノートPC',15,'BusinessPC.png',(SELECT id FROM categories WHERE name = 'PC'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'クリエイターPC',158000,'動画編集向け',8,'VideoEditingPC.jpeg',(SELECT id FROM categories WHERE name = 'PC'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'エントリーPC',59800,'初心者向けPC',20,'pc.png',(SELECT id FROM categories WHERE name = 'PC'),0,SYSDATE);

-- マウス
INSERT INTO items VALUES(seq_items.NEXTVAL,'Bluetoothマウス',2480,'持ち運び向け',20,'BluetoothMouse.jpeg',(SELECT id FROM categories WHERE name = 'マウス'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'静音マウス',1980,'クリック音軽減',20,'SilentMouse.png',(SELECT id FROM categories WHERE name = 'マウス'),0,SYSDATE);

-- キーボード
INSERT INTO items VALUES(seq_items.NEXTVAL,'テンキーレスキーボード',4980,'省スペース',15,'TKLKeyboard.jpeg',(SELECT id FROM categories WHERE name = 'キーボード'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'Bluetoothキーボード',3980,'無線接続',15,'BluetoothKeyboard.jpg',(SELECT id FROM categories WHERE name = 'キーボード'),0,SYSDATE);

-- モニター
INSERT INTO items VALUES(seq_items.NEXTVAL,'34インチウルトラワイドモニター',49800,'作業効率向上',5,'moniter.png',(SELECT id FROM categories WHERE name = 'モニター'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'4Kモニター',59800,'高解像度',5,'4KMonitor.jpeg',(SELECT id FROM categories WHERE name = 'モニター'),0,SYSDATE);

-- マイク
INSERT INTO items VALUES(seq_items.NEXTVAL,'配信用USBマイク',7980,'初心者配信向け',10,'USBMicrophone.jpeg',(SELECT id FROM categories WHERE name = 'マイク'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'ダイナミックマイク',15800,'ノイズに強い',5,'dynamic.jpg',(SELECT id FROM categories WHERE name = 'マイク'),0,SYSDATE);

-- Webカメラ
INSERT INTO items VALUES(seq_items.NEXTVAL,'4K Webカメラ',19800,'高画質配信向け',5,'4kweb.png',(SELECT id FROM categories WHERE name = 'Webカメラ'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'広角Webカメラ',5980,'会議向け',10,'wideweb.png',(SELECT id FROM categories WHERE name = 'Webカメラ'),0,SYSDATE);

-- ゲーム
INSERT INTO items VALUES(seq_items.NEXTVAL,'格闘ゲーム',6980,'オンライン対戦対応',20,'fighter_game.png',(SELECT id FROM categories WHERE name = 'ゲーム'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'レーシングゲーム',5980,'リアルドライブ体験',20,'race_game.png',(SELECT id FROM categories WHERE name = 'ゲーム'),0,SYSDATE);

-- 家電
INSERT INTO items VALUES(seq_items.NEXTVAL,'ロボット掃除機',29800,'自動掃除',10,'robbot.png',(SELECT id FROM categories WHERE name = '家電'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'空気清浄機',19800,'花粉対策',10,'air_cleaner.png',(SELECT id FROM categories WHERE name = '家電'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'電子レンジ',12800,'一人暮らし向け',10,'denshi.jpg',(SELECT id FROM categories WHERE name = '家電'),0,SYSDATE);

-- 日用品
INSERT INTO items VALUES(seq_items.NEXTVAL,'ティッシュペーパー',298,'5箱セット',50,'haburasi3.png',(SELECT id FROM categories WHERE name = '日用品'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'洗濯洗剤',498,'大容量タイプ',30,'LaundryDetergent.png',(SELECT id FROM categories WHERE name = '日用品'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'歯ブラシセット',398,'3本入り',50,'ToothbrushSet.jpeg',(SELECT id FROM categories WHERE name = '日用品'),0,SYSDATE);

-- ファッション
INSERT INTO items VALUES(seq_items.NEXTVAL,'無地Tシャツ',1980,'定番アイテム',30,'Tshirt.jpg',(SELECT id FROM categories WHERE name = 'ファッション'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'デニムパンツ',4980,'カジュアル向け',20,'Jeans.jpeg',(SELECT id FROM categories WHERE name = 'ファッション'),0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'スニーカー',7980,'人気モデル',15,'sneakers.jpg',(SELECT id FROM categories WHERE name = 'ファッション'),0,SYSDATE);

-----------------------------------------------------------------------
-- スマート購入プランナー（検索キーワード）
-----------------------------------------------------------------------
-- プランナーキーワード: ゲーム・eスポーツ一般
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーミング', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーミング', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーミング', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーミング', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム用', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム用', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム用', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム用', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーミングPC', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーミングPC', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーミングPC', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーミングPC', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'game', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'game', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'game', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'game', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'gaming', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'gaming', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'gaming', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'gaming', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'FPS', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'FPS', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'FPS', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'FPS', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'TPS', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'TPS', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'TPS', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'TPS', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'RPG', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'RPG', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'RPG', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'RPG', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'MMO', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'MMO', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'MMO', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'MMO', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'eスポーツ', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'eスポーツ', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'eスポーツ', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'eスポーツ', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'esports', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'esports', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'esports', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'esports', 'マウス');
-- プランナーキーワード: 具体的なゲームタイseq_planner_keyword_categories.NEXTVAL
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'League of Legends', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'League of Legends', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'League of Legends', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'League of Legends', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'LoL', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'LoL', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'LoL', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'LoL', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Arknights', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Arknights', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Arknights', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'アークナイツ', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'アークナイツ', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'アークナイツ', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Slay the Spire', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Slay the Spire', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Slay the Spire', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Balatro', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Balatro', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Balatro', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '崩壊スターレイル', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '崩壊スターレイル', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '崩壊スターレイル', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '雀魂', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '雀魂', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '雀魂', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'パズドラ', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'パズドラ', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'パズドラ', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Valorant', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Valorant', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Valorant', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Valorant', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'APEX', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'APEX', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'APEX', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'APEX', 'マウス');
-- プランナーキーワード: プログラミング・seq_planner_keyword_categories.NEXTVAL
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'プログラミング', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'プログラミング', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'プログラミング', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'プログラミング', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'コーディング', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'コーディング', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'コーディング', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'コーディング', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '開発', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '開発', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '開発', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '開発', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'エンジニア', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'エンジニア', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'エンジニア', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'エンジニア', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'JavaScript', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'JavaScript', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'JavaScript', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'JavaScript', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'JS', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'JS', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'JS', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'JS', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'VS Code', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'VS Code', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'VS Code', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'VS Code', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Chrome拡張機能', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Chrome拡張機能', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Chrome拡張機能', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Chrome拡張機能', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Web開発', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Web開発', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Web開発', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Web開発', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'フロントエンド', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'フロントエンド', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'フロントエンド', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'フロントエンド', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'アプリ開発', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'アプリ開発', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'アプリ開発', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'アプリ開発', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Java', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Java', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Java', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Java', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Python', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Python', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Python', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Python', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'C++', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'C++', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'C++', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'C++', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'C#', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'C#', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'C#', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'C#', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'React', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'React', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'React', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'React', '書籍');
-- プランナーキーワード: 配信・録画・動seq_planner_keyword_categories.NEXTVAL
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '配信', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '配信', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '配信', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '配信', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '実況', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '実況', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '実況', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '実況', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'OBS', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'OBS', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'OBS', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'OBS', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'OBS録画', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'OBS録画', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'OBS録画', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'OBS録画', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'HDR', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'HDR', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'HDR', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'HDR', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'HDR録画', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'HDR録画', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'HDR録画', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'HDR録画', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'VTuber', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'VTuber', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'VTuber', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'VTuber', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '動画編集', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '動画編集', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '動画編集', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '動画編集', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'クリエイター', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'クリエイター', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'クリエイター', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'クリエイター', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '動画制作', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '動画制作', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '動画制作', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '画像編集', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '画像編集', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '画像編集', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Photoshop', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Photoshop', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Photoshop', 'マウス');
-- プランナーキーワード: 事務・ビジネス・テレseq_planner_keyword_categories.NEXTVAL
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '事務', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '事務', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '事務', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '事務', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'テレワーク', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'テレワーク', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'テレワーク', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'テレワーク', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'リモートワーク', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'リモートワーク', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'リモートワーク', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'リモートワーク', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '在宅勤務', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '在宅勤務', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '在宅勤務', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '在宅勤務', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'オンライン授業', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'オンライン授業', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'オンライン授業', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'オンライン授業', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '仕事', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '仕事', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '仕事', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '仕事', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ビジネス', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ビジネス', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ビジネス', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ビジネス', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'レポート', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'レポート', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'レポート', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'レポート', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '卒論', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '卒論', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '卒論', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '卒論', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '資料作成', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '資料作成', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '資料作成', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '資料作成', 'マウス');
-- プランナーキーワード: 一般用途・カジseq_planner_keyword_categories.NEXTVAL
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ブラウジング', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ブラウジング', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ブラウジング', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '動画視聴', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '動画視聴', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '動画視聴', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ネットサーフィン', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ネットサーフィン', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ネットサーフィン', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '普段使い', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '普段使い', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '普段使い', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '日常使い', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '日常使い', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '日常使い', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '初心者', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '初心者', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '初心者', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'YouTube', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'YouTube', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'YouTube', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Netflix', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Netflix', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Netflix', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'SNS', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'SNS', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'SNS', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ブログ', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ブログ', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ブログ', 'マウス');
-- プランナーキーワード: スペック・環seq_planner_keyword_categories.NEXTVAL
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '10Gbps', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '10Gbps', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '10Gbps', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '10Gbps', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '高速回線', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '高速回線', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '高速回線', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '高速回線', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'WQHD', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'WQHD', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'WQHD', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'WQHD', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '180Hz', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '180Hz', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '180Hz', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '180Hz', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '144Hz', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '144Hz', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '144Hz', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '144Hz', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '240Hz', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '240Hz', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '240Hz', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '240Hz', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ハイスペック', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ハイスペック', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ハイスペック', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ハイスペック', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'コスパ', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'コスパ', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'コスパ', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'コスパ', 'マウス');
-- プランナーキーワード: デザイン・クリエイティブ・seq_planner_keyword_categories.NEXTVAL
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'イラスト', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'イラスト', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'イラスト', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'お絵描き', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'お絵描き', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'お絵描き', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '3Dモデリング', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '3Dモデリング', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '3Dモデリング', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Blender', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Blender', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Blender', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Unity', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Unity', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Unity', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'Unity', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'DTM', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'DTM', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'DTM', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'DTM', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '音楽制作', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '音楽制作', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '音楽制作', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '音楽制作', 'マウス');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'CAD', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'CAD', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'CAD', 'マウス');

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
