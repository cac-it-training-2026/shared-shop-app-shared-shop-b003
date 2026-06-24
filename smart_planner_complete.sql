

-----------------------------------------------------------------------
-- プランナーキーワードテーブルの作成
-----------------------------------------------------------------------


CREATE TABLE planner_keyword_categories (
    id NUMBER(6) PRIMARY KEY,
    keyword VARCHAR2(100 CHAR) NOT NULL,
    category_name VARCHAR2(100 CHAR) NOT NULL
);


CREATE SEQUENCE seq_planner_keyword_categories
START WITH 1
INCREMENT BY 1
NOCACHE;



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
INSERT INTO items VALUES(seq_items.NEXTVAL,'ビジネスノートPC',79800,'仕事向けノートPC',15,'noimage.jpg',3,0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'クリエイターPC',158000,'動画編集向け',8,'noimage.jpg',3,0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'エントリーPC',59800,'初心者向けPC',20,'noimage.jpg',3,0,SYSDATE);

-- マウス
INSERT INTO items VALUES(seq_items.NEXTVAL,'Bluetoothマウス',2480,'持ち運び向け',20,'noimage.jpg',4,0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'静音マウス',1980,'クリック音軽減',20,'noimage.jpg',4,0,SYSDATE);

-- キーボード
INSERT INTO items VALUES(seq_items.NEXTVAL,'テンキーレスキーボード',4980,'省スペース',15,'noimage.jpg',5,0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'Bluetoothキーボード',3980,'無線接続',15,'noimage.jpg',5,0,SYSDATE);

-- モニター
INSERT INTO items VALUES(seq_items.NEXTVAL,'34インチウルトラワイドモニター',49800,'作業効率向上',5,'noimage.jpg',6,0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'4Kモニター',59800,'高解像度',5,'noimage.jpg',6,0,SYSDATE);

-- マイク
INSERT INTO items VALUES(seq_items.NEXTVAL,'配信用USBマイク',7980,'初心者配信向け',10,'noimage.jpg',7,0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'ダイナミックマイク',15800,'ノイズに強い',5,'noimage.jpg',7,0,SYSDATE);

-- Webカメラ
INSERT INTO items VALUES(seq_items.NEXTVAL,'4K Webカメラ',19800,'高画質配信向け',5,'noimage.jpg',8,0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'広角Webカメラ',5980,'会議向け',10,'noimage.jpg',8,0,SYSDATE);

-- ゲーム
INSERT INTO items VALUES(seq_items.NEXTVAL,'格闘ゲーム',6980,'オンライン対戦対応',20,NULL,9,0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'レーシングゲーム',5980,'リアルドライブ体験',20,NULL,9,0,SYSDATE);

-- 家電
INSERT INTO items VALUES(seq_items.NEXTVAL,'ロボット掃除機',29800,'自動掃除',10,NULL,10,0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'空気清浄機',19800,'花粉対策',10,NULL,10,0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'電子レンジ',12800,'一人暮らし向け',10,NULL,10,0,SYSDATE);

-- 日用品
INSERT INTO items VALUES(seq_items.NEXTVAL,'ティッシュペーパー',298,'5箱セット',50,NULL,11,0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'洗濯洗剤',498,'大容量タイプ',30,NULL,11,0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'歯ブラシセット',398,'3本入り',50,NULL,11,0,SYSDATE);

-- ファッション
INSERT INTO items VALUES(seq_items.NEXTVAL,'無地Tシャツ',1980,'定番アイテム',30,NULL,12,0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'デニムパンツ',4980,'カジュアル向け',20,NULL,12,0,SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL,'スニーカー',7980,'人気モデル',15,NULL,12,0,SYSDATE);

COMMIT;
