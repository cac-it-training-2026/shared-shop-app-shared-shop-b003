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
