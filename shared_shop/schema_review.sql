-- レビューテーブルの作成
CREATE TABLE reviews (
    id NUMBER(10) PRIMARY KEY,
    item_id NUMBER(10) NOT NULL,
    user_id NUMBER(10) NOT NULL,
    evaluation NUMBER(1) NOT NULL,
    content VARCHAR2(1000),
    stamp NUMBER(1),
    insert_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_review_item FOREIGN KEY (item_id) REFERENCES items(id),
    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- シーケンスの作成
CREATE SEQUENCE seq_reviews START WITH 1 INCREMENT BY 1;
