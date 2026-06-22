-- ======================================================
-- 1. 追加カテゴリの登録
-- ======================================================
INSERT INTO categories (id, name, description, delete_flag, insert_date) VALUES (seq_categories.NEXTVAL, 'ゲーム', 'PCゲーム・コンシューマーゲーム機', 0, SYSDATE);
INSERT INTO categories (id, name, description, delete_flag, insert_date) VALUES (seq_categories.NEXTVAL, '家電', '最新の電化製品', 0, SYSDATE);
INSERT INTO categories (id, name, description, delete_flag, insert_date) VALUES (seq_categories.NEXTVAL, '日用品', '生活に欠かせない消耗品', 0, SYSDATE);
INSERT INTO categories (id, name, description, delete_flag, insert_date) VALUES (seq_categories.NEXTVAL, 'ファッション', '衣類・アクセサリー', 0, SYSDATE);
INSERT INTO categories (id, name, description, delete_flag, insert_date) VALUES (seq_categories.NEXTVAL, '食料品', '食品全般', 0, SYSDATE);
INSERT INTO categories (id, name, description, delete_flag, insert_date) VALUES (seq_categories.NEXTVAL, '書籍', '本・雑誌・電子書籍', 0, SYSDATE);

-- ======================================================
-- 2. キーワードマッピングの追加
-- ======================================================
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'ゲーム');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '家電', '家電');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '生活', '日用品');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '服', 'ファッション');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '食料', '食料品');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '本', '書籍');

-- ======================================================
-- 3. 商品データの登録 (カテゴリごとに10件以上)
-- ======================================================

-- ------------------------------------------------------
-- ゲーム
-- ------------------------------------------------------
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '中古コントローラー', 1500, '状態良好', 10, 0, id FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'インディーズゲーム', 2500, 'DL版カード', 100, 0, id FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'ゲーミングマウス', 4500, 'エントリーモデル', 30, 0, id FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '新作RPG', 7800, '初回限定版', 50, 0, id FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'ゲーミングキーボード', 9800, 'メカニカル', 20, 0, id FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'ワイヤレスヘッドセット', 12800, 'ノイズキャンセリング', 15, 0, id FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'ゲーミングモニター', 29800, '24インチ 144Hz', 12, 0, id FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '最新ゲーム機', 49980, '4K対応', 5, 0, id FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'ゲーミングチェア', 65000, 'エルゴノミクス', 3, 0, id FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'ハイエンドゲーミングPC', 248000, 'RTX4080搭載', 2, 0, id FROM categories WHERE name = 'ゲーム';

-- ------------------------------------------------------
-- 食料品
-- ------------------------------------------------------
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '天然水 2L', 100, '山梨県産', 500, 0, id FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'インスタントラーメン', 150, '醤油味', 200, 0, id FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'レトルトカレー', 280, '中辛', 150, 0, id FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'パスタ 500g', 350, 'デュラム小麦', 100, 0, id FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '国産鶏もも肉', 800, '2枚セット', 40, 0, id FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'コシヒカリ 5kg', 2500, '令和5年産', 60, 0, id FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '特選和牛', 5500, 'サーロイン 200g', 20, 0, id FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '大トロ刺身', 6800, '天然マグロ', 10, 0, id FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '高級シャンパン', 9800, 'フランス産', 15, 0, id FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'キャビア 50g', 15000, 'ベルーガ', 5, 0, id FROM categories WHERE name = '食料品';

-- ------------------------------------------------------
-- 書籍
-- ------------------------------------------------------
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '中古文庫', 300, 'ミステリー', 10, 0, id FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '月刊雑誌', 880, '最新号', 50, 0, id FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '新書判', 1100, '教養', 30, 0, id FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'ベストセラー小説', 1760, '単行本', 100, 0, id FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '料理本', 2200, 'フルカラー', 25, 0, id FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'ビジネス書', 2800, '経営戦略', 40, 0, id FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '技術専門書', 4500, 'AIプログラミング', 15, 0, id FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '大型写真集', 8500, '絶景100選', 8, 0, id FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '百科事典セット', 35000, '全10巻', 3, 0, id FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '希少古書', 120000, '初版サイン入り', 1, 0, id FROM categories WHERE name = '書籍';

-- ------------------------------------------------------
-- 家電
-- ------------------------------------------------------
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'USB加湿器', 1980, '卓上タイプ', 50, 0, id FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '電気ケトル', 3980, '1.0L', 30, 0, id FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '低価格炊飯器', 5980, '3合炊き', 20, 0, id FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'ドライヤー', 8500, 'マイナスイオン', 25, 0, id FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'コードレス掃除機', 15800, '軽量モデル', 15, 0, id FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '空気清浄機', 24800, '20畳対応', 10, 0, id FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '多機能オーブンレンジ', 45000, 'スチーム機能付き', 8, 0, id FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '4K液晶テレビ', 88000, '50インチ', 5, 0, id FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'ドラム式洗濯機', 198000, '乾燥機能付き', 3, 0, id FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '最新冷蔵庫', 258000, 'AI搭載 600L', 2, 0, id FROM categories WHERE name = '家電';

-- ------------------------------------------------------
-- 日用品
-- ------------------------------------------------------
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'ポケットティッシュ', 100, '10個パック', 1000, 0, id FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '歯ブラシ', 250, '極細毛', 500, 0, id FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '食器用洗剤', 380, '大容量', 300, 0, id FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'トイレットペーパー', 680, '12ロール', 200, 0, id FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '柔軟剤', 980, 'フローラルの香り', 150, 0, id FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '多目的クリーナー', 1500, 'スプレータイプ', 80, 0, id FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '高機能タオル', 2800, '吸水速乾', 60, 0, id FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'アロマディフューザー', 5500, '超音波式', 20, 0, id FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '高級ハンガーセット', 8800, '10本セット', 15, 0, id FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '高級ゴミ箱', 12800, 'センサー自動開閉', 10, 0, id FROM categories WHERE name = '日用品';

-- ------------------------------------------------------
-- ファッション
-- ------------------------------------------------------
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'ソックス', 500, '3足セット', 200, 0, id FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '無地Tシャツ', 1200, 'コットン100%', 150, 0, id FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'カジュアルベルト', 2800, '合成皮革', 50, 0, id FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'デニムパンツ', 4500, 'スリムフィット', 80, 0, id FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'オフィスカジュアルシャツ', 6800, '形態安定', 60, 0, id FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'レザースニーカー', 12800, '本革使用', 30, 0, id FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'ウールコート', 25800, 'ロング丈', 15, 0, id FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'ブランド腕時計', 48000, '防水・ソーラー', 10, 0, id FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, '高級本革バッグ', 85000, 'イタリアンレザー', 5, 0, id FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id)
SELECT seq_items.NEXTVAL, 'オーダースーツ', 158000, '最高級生地使用', 2, 0, id FROM categories WHERE name = 'ファッション';

COMMIT;
