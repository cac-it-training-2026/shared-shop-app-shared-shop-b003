-- ======================================================
-- 1. 既存の基本テーブル構造 (参考: すでに存在する場合、作成不要)
-- ======================================================

-- カテゴリテーブル
-- CREATE TABLE categories (
--     id NUMBER(6) PRIMARY KEY,
--     name VARCHAR2(100 CHAR) NOT NULL,
--     description VARCHAR2(500 CHAR),
--     delete_flag NUMBER(1) DEFAULT 0,
--     insert_date DATE DEFAULT SYSDATE
-- );

-- 商品テーブル
-- CREATE TABLE items (
--     id NUMBER(6) PRIMARY KEY,
--     name VARCHAR2(100 CHAR) NOT NULL,
--     price NUMBER(10) NOT NULL,
--     description VARCHAR2(500 CHAR),
--     stock NUMBER(6) NOT NULL,
--     image VARCHAR2(200 CHAR),
--     category_id NUMBER(6) REFERENCES categories(id),
--     delete_flag NUMBER(1) DEFAULT 0,
--     insert_date DATE DEFAULT SYSDATE
-- );


-- ======================================================
-- 2. スマート購入プランナー用 新規テーブル・シーケンス
-- ======================================================

-- 既存のテーブルやシーケンスがある場合は削除 (初期化用)
DROP TABLE planner_keyword_categories CASCADE CONSTRAINTS;
DROP SEQUENCE seq_planner_keyword_categories;

-- 用途キーワードとカテゴリのマッピングテーブル作成
CREATE TABLE planner_keyword_categories (
    id NUMBER(6) PRIMARY KEY,
    keyword VARCHAR2(100 CHAR) NOT NULL,
    category_name VARCHAR2(100 CHAR) NOT NULL
);

-- ID自動採番用シーケンス作成
CREATE SEQUENCE seq_planner_keyword_categories NOCACHE;


-- ======================================================
-- 3. 初期データ投入 (キーワードとカテゴリの紐付け)
-- ======================================================

-- ゲーム系
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'キーボード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'マウス');

-- プログラミング系
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'プログラミング', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'プログラミング', '書籍');

-- 勉強・読書系
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '勉強・読書', '書籍');

-- 仕事・テレワーク系
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '仕事・テレワーク', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '仕事・テレワーク', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '仕事・テレワーク', 'オフィス用品');

-- 食料品系
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '食料品', '食料品');

-- 果物系
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '果物', '果物');

-- 動画編集系
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '動画編集', '高性能PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '動画編集', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '動画編集', 'SSD');

COMMIT;
