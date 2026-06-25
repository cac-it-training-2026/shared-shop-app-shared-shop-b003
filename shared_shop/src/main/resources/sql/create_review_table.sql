-- レビューテーブル
CREATE TABLE reviews (
    id NUMBER(10) PRIMARY KEY,
    product_id NUMBER(10) NOT NULL,
    user_id NUMBER(10) NOT NULL,
    rating NUMBER(1) CHECK (rating BETWEEN 1 AND 5),
    body CLOB,
    approved NUMBER(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reviews_product FOREIGN KEY (product_id) REFERENCES items(id),
    CONSTRAINT fk_reviews_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- レビュー用シーケンス
CREATE SEQUENCE seq_reviews START WITH 1 INCREMENT BY 1;
