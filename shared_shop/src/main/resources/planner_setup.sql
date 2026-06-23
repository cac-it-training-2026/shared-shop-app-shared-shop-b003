-- スマート購入プランナー用テーブル作成
CREATE TABLE planner_keyword_categories (
    id NUMBER(6) PRIMARY KEY,
    keyword VARCHAR2(100 CHAR) NOT NULL,
    category_name VARCHAR2(100 CHAR) NOT NULL
);

-- シーケンス作成
CREATE SEQUENCE seq_planner_keyword_categories NOCACHE;

-- 初期データ投入（キーワードとカテゴリのマッピング）
-- ゲーム系
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'キーボード');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'マウス');

-- プログラミング系
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'プログラミング', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'プログラミング', '書籍');

-- 勉強・読書系
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '勉強・読書', '書籍');

-- 仕事・テレワーク系
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '仕事・テレワーク', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '仕事・テレワーク', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '仕事・テレワーク', 'オフィス用品');

-- 食料品系
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '食料品', '食料品');

-- 果物系
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '果物', '果物');

-- 動画編集系
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '動画編集', '高性能PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '動画編集', 'モニター');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '動画編集', 'SSD');

COMMIT;
