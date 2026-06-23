-- ==========================================
-- 商品レビュー機能用データベース定義 (Oracle 11g対応)
-- ==========================================

-- レビューテーブル
-- 評価、コメント、スタンプ、および関連商品・ユーザー情報を保持
CREATE TABLE reviews (
    id NUMBER(10) PRIMARY KEY,
    rating NUMBER(1) NOT NULL,          -- 評価 (1-5)
    comment VARCHAR2(1000) NOT NULL,     -- コメントテキスト
    stamp VARCHAR2(100),                -- スタンプ (😊 満足, 👍 おすすめ, 等)
    item_id NUMBER(10) NOT NULL,        -- 対象商品のID
    user_id NUMBER(10) NOT NULL,        -- 投稿ユーザーのID
    insert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 投稿日時
    CONSTRAINT fk_reviews_item FOREIGN KEY (item_id) REFERENCES items(id),
    CONSTRAINT fk_reviews_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- レビューID用シーケンス
CREATE SEQUENCE seq_reviews START WITH 1 INCREMENT BY 1;
