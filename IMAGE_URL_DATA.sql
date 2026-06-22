-- ======================================================
-- 1. プランナーおよび画像表示用テーブル・カラムの追加 (DDL)
-- ======================================================

-- itemsテーブルへのimage_urlカラム追加
ALTER TABLE items ADD image_url VARCHAR2(1000);

-- 用途キーワードと商品カテゴリのマッピングを管理するテーブル
CREATE TABLE planner_keyword_categories (
    id            NUMBER(10, 0) PRIMARY KEY,
    keyword       VARCHAR2(100) NOT NULL,
    category_name VARCHAR2(100) NOT NULL
);

-- プランナー管理用シーケンス
CREATE SEQUENCE seq_planner_keyword_categories START WITH 1 INCREMENT BY 1;

-- ======================================================
-- 2. カテゴリおよびキーワードマッピングの追加 (DML)
-- ======================================================
INSERT INTO categories (id, name, description, delete_flag, insert_date) VALUES (seq_categories.NEXTVAL, 'ゲーム', 'PCゲーム・コンシューマーゲーム機', 0, SYSDATE);
INSERT INTO categories (id, name, description, delete_flag, insert_date) VALUES (seq_categories.NEXTVAL, '家電', '最新の電化製品', 0, SYSDATE);
INSERT INTO categories (id, name, description, delete_flag, insert_date) VALUES (seq_categories.NEXTVAL, '日用品', '生活に欠かせない消耗品', 0, SYSDATE);
INSERT INTO categories (id, name, description, delete_flag, insert_date) VALUES (seq_categories.NEXTVAL, 'ファッション', '衣類・アクセサリー', 0, SYSDATE);
INSERT INTO categories (id, name, description, delete_flag, insert_date) VALUES (seq_categories.NEXTVAL, '食料品', '食品全般', 0, SYSDATE);
INSERT INTO categories (id, name, description, delete_flag, insert_date) VALUES (seq_categories.NEXTVAL, '書籍', '本・雑誌・電子書籍', 0, SYSDATE);

INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, 'ゲーム', 'ゲーム');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '家電', '家電');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '生活', '日用品');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '服', 'ファッション');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '食料', '食料品');
INSERT INTO planner_keyword_categories (id, keyword, category_name) VALUES (seq_planner_keyword_categories.NEXTVAL, '本', '書籍');

-- ======================================================
-- 3. 商品データ登録 (各カテゴリ10件、価格帯と画像設定)
-- ======================================================

-- ------------------------------------------------------
-- ゲーム (低・中・高価格帯)
-- ------------------------------------------------------
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '中古コントローラー', 1500, '状態良好', 10, 0, id, 'https://images.unsplash.com/photo-1612287230202-1ff1d85d1bdf?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'インディーズゲーム', 2500, 'DL版カード', 100, 0, id, 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'ゲーミングマウス', 4500, 'エントリー', 30, 0, id, 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '新作RPG', 7800, '初回限定版', 50, 0, id, 'https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'ゲーミングキーボード', 9800, 'メカニカル', 20, 0, id, 'https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'ワイヤレスヘッドセット', 12800, 'NC機能付き', 15, 0, id, 'https://images.unsplash.com/photo-1605398407421-91ac19a3b711?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'ゲーミングモニター', 29800, '144Hz対応', 12, 0, id, 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '最新ゲーム機', 49980, '4K Ultra HD', 5, 0, id, 'https://images.unsplash.com/photo-1486401899868-0e435ed85128?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'ゲーミングチェア', 65000, 'プロ仕様', 3, 0, id, 'https://images.unsplash.com/photo-1598550476439-6847785fce66?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ゲーム';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'ハイエンドPC', 248000, '水冷式', 2, 0, id, 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ゲーム';

-- ------------------------------------------------------
-- 食料品
-- ------------------------------------------------------
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '天然水', 100, '500ml', 500, 0, id, 'https://images.unsplash.com/photo-1523362628742-0c2602ee327a?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'スナック菓子', 150, '塩味', 200, 0, id, 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'カップ麺', 280, '豚骨味', 150, 0, id, 'https://images.unsplash.com/photo-1618449840665-9ed506d73a34?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '新鮮野菜セット', 1200, '農家直送', 100, 0, id, 'https://images.unsplash.com/photo-1551462147-37885abb3e4a?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '輸入ビール 6缶', 1800, 'プレミアム', 40, 0, id, 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '特大ホールケーキ', 3500, '生クリーム', 60, 0, id, 'https://images.unsplash.com/photo-1586201375761-83865001e31c?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '特選黒毛和牛', 5500, 'A5ランク', 20, 0, id, 'https://images.unsplash.com/photo-1558030006-450675393462?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'ワイン 紅白セット', 8800, '熟成', 10, 0, id, 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '高級果物詰め合わせ', 12000, '桐箱入り', 15, 0, id, 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '食料品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '希少価値焼酎', 25000, '限定品', 5, 0, id, 'https://images.unsplash.com/photo-1535924204746-880be0a7516a?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '食料品';

-- ------------------------------------------------------
-- 書籍
-- ------------------------------------------------------
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '古本の文庫', 300, '読書用', 10, 0, id, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'コミック最新刊', 550, '人気シリーズ', 50, 0, id, 'https://images.unsplash.com/photo-1532012197367-2d970726401f?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '文芸雑誌', 980, '文学', 30, 0, id, 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '話題の小説', 1700, '直木賞候補', 100, 0, id, 'https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'ビジネス書ベストセラー', 2200, '自己啓発', 25, 0, id, 'https://images.unsplash.com/photo-1495195129352-aec325b55b65?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '写真集', 3500, '世界の絶景', 40, 0, id, 'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '専門技術書', 6800, 'Java開発', 15, 0, id, 'https://images.unsplash.com/photo-1516116216624-53e697fedbea?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '豪華版図鑑', 12000, '宇宙の神秘', 8, 0, id, 'https://images.unsplash.com/photo-1542992015-4a0b729b1385?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '全巻セット', 45000, '歴史大百科', 3, 0, id, 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '書籍';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '超希少サイン本', 98000, '初版本', 1, 0, id, 'https://images.unsplash.com/photo-1491841573634-28140fc7ced7?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '書籍';

-- ------------------------------------------------------
-- 家電
-- ------------------------------------------------------
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'ミニ扇風機', 1200, 'USB充電', 50, 0, id, 'https://images.unsplash.com/photo-1585771724684-252702b6443e?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '電気ケトル', 3500, '1.2L', 30, 0, id, 'https://images.unsplash.com/photo-1520338661084-680395cb57c9?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'オーブントースター', 5800, '2枚焼き', 20, 0, id, 'https://images.unsplash.com/photo-1585241641321-7299a9b70742?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'マイナスイオンドライヤー', 9800, '大風量', 25, 0, id, 'https://images.unsplash.com/photo-1522338140262-f46f5913618a?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'ロボット掃除機', 24000, '自動充電', 15, 0, id, 'https://images.unsplash.com/photo-1558317374-067fb5f30001?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '空気清浄機', 38000, 'HEPAフィルタ', 10, 0, id, 'https://images.unsplash.com/photo-1585245360634-11003e00181b?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'スチームオーブン', 55000, '過熱水蒸気', 8, 0, id, 'https://images.unsplash.com/photo-1527204883983-8bc68e002120?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '4K 液晶テレビ 55型', 89000, 'Android搭載', 5, 0, id, 'https://images.unsplash.com/photo-1593344484962-796055d4a3a4?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'ドラム式洗濯乾燥機', 218000, 'ヒートポンプ', 3, 0, id, 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '家電';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'プレミアム冷蔵庫 700L', 320000, '真空チルド', 2, 0, id, 'https://images.unsplash.com/photo-1583922606661-0822ed0bd916?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '家電';

-- ------------------------------------------------------
-- 日用品
-- ------------------------------------------------------
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '詰替用洗剤', 250, '抗菌', 1000, 0, id, 'https://images.unsplash.com/photo-1627384113972-f4c0392fe5aa?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'デザイン歯ブラシ', 480, '北欧風', 500, 0, id, 'https://images.unsplash.com/photo-1610499984198-132d7821636c?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '今治タオル', 1500, '吸水性抜群', 300, 0, id, 'https://images.unsplash.com/photo-1585333127302-d29247444383?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'アロマキャンドル', 2800, 'ラベンダー', 200, 0, id, 'https://images.unsplash.com/photo-1583947215259-38e31be8751f?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'ディフューザーセット', 4500, '天然オイル', 150, 0, id, 'https://images.unsplash.com/photo-1563453392212-326f5e854473?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '高機能ごみ箱', 6800, 'ペダル式', 80, 0, id, 'https://images.unsplash.com/photo-1584622781564-1d9876a13d00?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '電動お掃除ブラシ', 12000, 'コードレス', 60, 0, id, 'https://images.unsplash.com/photo-1540555700478-4be289fbece8?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '高級寝具カバー', 18500, 'シルク混', 20, 0, id, 'https://images.unsplash.com/photo-1602928321679-560bb453f190?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'デザイナーズ掛け時計', 32000, 'モダンデザイン', 15, 0, id, 'https://images.unsplash.com/photo-1600170311833-c2cf5280ce49?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '日用品';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '全自動ダストボックス', 55000, 'AIセンサー', 10, 0, id, 'https://images.unsplash.com/photo-1554110397-9bac083977c6?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = '日用品';

-- ------------------------------------------------------
-- ファッション
-- ------------------------------------------------------
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'アンクルソックス', 500, '綿100%', 200, 0, id, 'https://images.unsplash.com/photo-1586350977771-b3b0abd50c82?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '無地VネックTシャツ', 1200, '各色あり', 150, 0, id, 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'レザータッチベルト', 2500, '調整可能', 50, 0, id, 'https://images.unsplash.com/photo-1624222247344-550fb8ec5522?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'ストレッチデニム', 4900, 'スキニー', 80, 0, id, 'https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '形態安定シャツ', 6800, 'ホワイト', 60, 0, id, 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'イタリアンレザースニーカー', 15000, '本革', 30, 0, id, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'チェスターコート', 28000, 'カシミヤ混', 15, 0, id, 'https://images.unsplash.com/photo-1539533377285-3004b615a9f4?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'ダイバーズウォッチ', 55000, 'ソーラー', 10, 0, id, 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, '高級本革トートバッグ', 98000, '職人手作り', 5, 0, id, 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ファッション';
INSERT INTO items (id, name, price, description, stock, delete_flag, category_id, image_url)
SELECT seq_items.NEXTVAL, 'フルオーダースーツ', 188000, '高級生地', 2, 0, id, 'https://images.unsplash.com/photo-1594932224828-b4b059b6f6f9?q=80&w=1000&auto=format&fit=crop' FROM categories WHERE name = 'ファッション';

COMMIT;
