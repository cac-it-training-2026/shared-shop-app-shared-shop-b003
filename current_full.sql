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
-----------------------------------------------------------------------
-- 繝励Λ繝ｳ繝翫繧ｭ繝ｼ繝ｯ繝ｼ繝峨き繝ざ繝ｪ繝繝悶Ν縺ｮ菴懈
-- カテゴリ追加
INSERT INTO categories VALUES(seq_categories.NEXTVAL, 'PC', 'デスクトップPC、ノートPCなど', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, 'モニター', '液晶ディスプレイ、ゲーミングモニターなど', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, 'キーボード', 'メカニカル、メンブレン、静電容量無接点方式など', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, 'マウス', 'ワイヤレス、ゲーミングマウスなど', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '高性能PC', '動画編集や3Dゲーム向けのハイスペックPC', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, 'SSD', '高速ストレージ装置', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, 'オフィス用品', 'デスク、チェア、文房具など', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '果物', '旬のフルーツ', DEFAULT, DEFAULT);

-- 商品追加 (各カテゴリ3点以上、在庫あり、削除フラグ0)

-- PC (Category ID: 3)
INSERT INTO items VALUES(seq_items.NEXTVAL, 'スタンダードノートPC', 50000, '普段使いに最適なPC', 10, NULL, 3, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'ビジネスノートPC', 80000, '仕事に最適なPC', 10, NULL, 3, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'プレミアムノートPC', 120000, '高性能なPC', 10, NULL, 3, 0, SYSDATE);

-- モニター (Category ID: 4)
INSERT INTO items VALUES(seq_items.NEXTVAL, '21インチモニター', 15000, 'コンパクトなモニター', 10, NULL, 4, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '24インチフルHDモニター', 25000, '標準的なモニター', 10, NULL, 4, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '27インチ4Kモニター', 45000, '高精細なモニター', 10, NULL, 4, 0, SYSDATE);

-- キーボード (Category ID: 5)
INSERT INTO items VALUES(seq_items.NEXTVAL, 'メンブレンキーボード', 2000, '静かなキーボード', 10, NULL, 5, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'メカニカルキーボード', 8000, '心地よい打鍵感', 10, NULL, 5, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '高級静電容量無接点キーボード', 25000, '最高のタイピング体験', 10, NULL, 5, 0, SYSDATE);

-- マウス (Category ID: 6)
INSERT INTO items VALUES(seq_items.NEXTVAL, '有線光学式マウス', 1000, 'シンプルなマウス', 10, NULL, 6, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'ワイヤレスマウス', 3000, '便利なマウス', 10, NULL, 6, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '多ボタンゲーミングマウス', 10000, '多機能なマウス', 10, NULL, 6, 0, SYSDATE);

-- 書籍 (Category ID: 2)
INSERT INTO items VALUES(seq_items.NEXTVAL, 'Java入門', 3000, 'Javaの基礎を学ぶ', 10, NULL, 2, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'Spring Boot徹底解説', 4500, '実践的なフレームワーク学習', 10, NULL, 2, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'ソフトウェアアーキテクチャ', 6000, '高度な設計手法', 10, NULL, 2, 0, SYSDATE);

-- 高性能PC (Category ID: 7)
INSERT INTO items VALUES(seq_items.NEXTVAL, 'エントリーゲーミングPC', 150000, 'ゲーム入門に', 5, NULL, 7, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'ミドルレンジゲーミングPC', 250000, 'ほとんどのゲームが快適', 5, NULL, 7, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'ハイエンドワークステーション', 450000, 'プロの動画編集に', 5, NULL, 7, 0, SYSDATE);

-- SSD (Category ID: 8)
INSERT INTO items VALUES(seq_items.NEXTVAL, '500GB SSD', 7000, '手軽に増設', 20, NULL, 8, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '1TB NVMe SSD', 15000, '高速なデータ転送', 20, NULL, 8, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '2TB 高耐久SSD', 30000, '大容量で安心', 20, NULL, 8, 0, SYSDATE);

-- オフィス用品 (Category ID: 9)
INSERT INTO items VALUES(seq_items.NEXTVAL, 'シンプルデスク', 10000, '使いやすいデスク', 10, NULL, 9, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'エルゴノミクスチェア', 30000, '疲れにくい椅子', 10, NULL, 9, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '昇降デスク', 60000, '立っても座っても使える', 10, NULL, 9, 0, SYSDATE);

-- 食料品 (Category ID: 1)
INSERT INTO items VALUES(seq_items.NEXTVAL, '特大おにぎり', 200, 'ボリューム満点', 50, NULL, 1, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '高級レトルトカレー', 800, 'お店の味', 50, NULL, 1, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '豪華お取り寄せセット', 5000, '自分へのご褒美', 10, NULL, 1, 0, SYSDATE);

-- 果物 (Category ID: 10)
INSERT INTO items VALUES(seq_items.NEXTVAL, 'サンふじ(りんご)', 200, '甘みが強い', 30, NULL, 10, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '高級完熟メロン', 3000, '芳醇な香り', 5, NULL, 10, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'シャインマスカット', 5000, '種なしで食べやすい', 5, NULL, 10, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '完熟バナナ', 300, '栄養満点', 20, NULL, 10, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '温州みかん 5kg', 2500, '冬の定番', 15, NULL, 10, 0, SYSDATE);

-- キーワードマッピングのクリア
-- カテゴリ確認・追加
-- 食料品 (1), 書籍 (2) は既にある想定
-- 新規: PC (3), モニター (4), キーボード (5), マウス (6), 高性能PC (7), SSD (8), オフィス用品 (9), 果物 (10)

-- キーワードマッピング拡張
TRUNCATE TABLE planner_keyword_categories;
-- シーケンスのリセットは環境に依存するため、削除して再作成が安全
DROP SEQUENCE seq_planner_keyword_categories;
CREATE SEQUENCE seq_planner_keyword_categories NOCACHE;

-- ゲーム系 -> PC, モニター, キーボード, マウス
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'game', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'game', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'game', 'キーボード');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'game', 'マウス');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'gaming', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'gaming', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'gaming', 'キーボード');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'gaming', 'マウス');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'キーボード');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'マウス');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'FPS', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'FPS', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'FPS', 'キーボード');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'FPS', 'マウス');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fps', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fps', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fps', 'キーボード');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fps', 'マウス');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'RPG', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'RPG', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'RPG', 'キーボード');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'RPG', 'マウス');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'rpg', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'rpg', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'rpg', 'キーボード');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'rpg', 'マウス');

-- プログラミング系 -> PC, 書籍
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'programming', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'programming', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'java', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'java', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'python', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'python', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ai', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ai', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'development', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'development', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'coding', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'coding', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'プログラミング', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'プログラミング', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '開発', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'Java', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'Java', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'Python', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'Python', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'AI', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'AI', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '人工知能', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '人工知能', '書籍');

-- 勉強系・書籍系 -> 書籍
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'study', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'learning', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'school', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '勉強', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '学習', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '大学', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'レポート', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '資格', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '参考書', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'book', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'books', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'reading', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '本', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '書籍', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '読書', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '小説', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '漫画', '書籍');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'マンガ', '書籍');

-- 仕事系 -> PC, モニター, オフィス用品
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'work', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'work', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'office', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'office', 'オフィス用品');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'business', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'business', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '仕事', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '仕事', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '在宅ワーク', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '在宅ワーク', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'テレワーク', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'テレワーク', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'オフィス', 'オフィス用品');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '事務作業', 'オフィス用品');

-- 食料品系 -> 食料品
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'food', '食料品');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'meal', '食料品');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'grocery', '食料品');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '食べ物', '食料品');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '食品', '食料品');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '食料品', '食料品');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ご飯', '食料品');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '料理', '食料品');

-- 果物系 -> 果物
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fruit', '果物');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fruits', '果物');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '果物', '果物');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'フルーツ', '果物');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'りんご', '果物');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'リンゴ', '果物');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'みかん', '果物');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'バナナ', '果物');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ぶどう', '果物');

-- 動画編集 -> 高性能PC, モニター, SSD
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '動画編集', '高性能PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '動画編集', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '動画編集', 'SSD');

COMMIT;
