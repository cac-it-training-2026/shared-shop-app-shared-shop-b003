-- ======================================================
-- スマート購入プランナー 拡充版データセット
-- より幅広い用途に対応するためのマッピング追加
-- ======================================================

-- 既存データのクリーンアップ (任意)
-- DELETE FROM planner_keyword_categories;

-- 1. 新生活・引越し (New Life / Moving)
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '新生活', 'PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '新生活', 'オフィス用品');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '新生活', 'キッチン用品');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '新生活', '雑貨');

-- 2. プレゼント・ギフト (Present / Gift)
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'プレゼント', '菓子');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'プレゼント', '雑貨');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'プレゼント', 'アクセサリー');

-- 3. 旅行・お出かけ (Travel / Outing)
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '旅行', 'バッグ');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '旅行', 'トラベル用品');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '旅行', '書籍');

-- 4. 健康・フィットネス (Health / Fitness)
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '健康・フィットネス', '健康器具');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '健康・フィットネス', 'サプリメント');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '健康・フィットネス', '食料品');

-- 5. 料理・自炊 (Cooking)
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '料理', '調理器具');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '料理', '食料品');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '料理', '書籍');

-- 6. クリエイティブ（イラスト・デザイン） (Creative / Design)
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'クリエイティブ', '高性能PC');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'クリエイティブ', 'モニター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'クリエイティブ', 'ペンタブレット');

-- 7. アウトドア・キャンプ (Outdoor / Camping)
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'アウトドア', 'キャンプ用品');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'アウトドア', 'ライト・ランタン');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'アウトドア', 'ウェア');

-- 8. ペットとの暮らし (Pet Life)
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ペット', 'ペットフード');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ペット', 'ペット用品');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ペット', '雑貨');

-- 9. 英語学習・資格試験 (Language Learning / Exam)
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '英語・資格', '書籍');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '英語・資格', '文房具');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '英語・資格', '電子辞書');

-- 10. ホームシアター・音楽鑑賞 (Home Theater / Music)
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'エンタメ鑑賞', 'スピーカー');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'エンタメ鑑賞', 'プロジェクター');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'エンタメ鑑賞', 'モニター');

COMMIT;
