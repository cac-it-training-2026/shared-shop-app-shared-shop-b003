-- ======================================================
-- スマート購入プランナー 網羅版セットアップ
-- 全カテゴリ・広範な価格帯の商品およびキーワードマッピング
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
-- カテゴリ・商品の拡充 (参考: 既存DBに合わせてINSERT)
-- どの予算(100円〜)でも提案が出るように超低価格品も追加
-- ======================================================

-- PCカテゴリ
INSERT INTO items (id, name, price, description, stock, category_id, delete_flag, insert_date) VALUES (seq_items.NEXTVAL, '中古デスクトップPC', 5000, '格安PC', 5, 1, 0, SYSDATE);
INSERT INTO items (id, name, price, description, stock, category_id, delete_flag, insert_date) VALUES (seq_items.NEXTVAL, '高性能ゲーミングPC', 250000, '最新鋭PC', 3, 1, 0, SYSDATE);

-- 書籍カテゴリ
INSERT INTO items (id, name, price, description, stock, category_id, delete_flag, insert_date) VALUES (seq_items.NEXTVAL, '古本の豆知識', 100, '超格安本', 100, 2, 0, SYSDATE);
INSERT INTO items (id, name, price, description, stock, category_id, delete_flag, insert_date) VALUES (seq_items.NEXTVAL, '専門技術大百科', 15000, '高級技術書', 10, 2, 0, SYSDATE);

-- 食料品カテゴリ
INSERT INTO items (id, name, price, description, stock, category_id, delete_flag, insert_date) VALUES (seq_items.NEXTVAL, '駄菓子詰め合わせ', 50, '格安お菓子', 200, 3, 0, SYSDATE);
INSERT INTO items (id, name, price, description, stock, category_id, delete_flag, insert_date) VALUES (seq_items.NEXTVAL, '高級和牛セット', 30000, '贅沢食材', 5, 3, 0, SYSDATE);

-- 雑貨カテゴリ (100円〜)
INSERT INTO items (id, name, price, description, stock, category_id, delete_flag, insert_date) VALUES (seq_items.NEXTVAL, 'ポケットティッシュ', 10, '日用雑貨', 500, 4, 0, SYSDATE);
INSERT INTO items (id, name, price, description, stock, category_id, delete_flag, insert_date) VALUES (seq_items.NEXTVAL, 'デザイナーズ時計', 50000, '高級雑貨', 2, 4, 0, SYSDATE);

-- ======================================================
-- キーワードマッピングの網羅
-- ======================================================

-- ほぼ全カテゴリを網羅するキーワード
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '生活全般', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '生活全般', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '生活全般', '食料品');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '生活全般', '雑貨');

-- 既存キーワードの再登録
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'プログラミング', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'プログラミング', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '勉強・読書', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '仕事・テレワーク', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '食料品', '食料品');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '果物', '果物');

COMMIT;
