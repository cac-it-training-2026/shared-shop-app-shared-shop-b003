-- プランナーテーブルの作成
CREATE TABLE planners (
    id          NUMBER(10) PRIMARY KEY,
    use_case    VARCHAR2(1000) NOT NULL,
    budget      NUMBER(10) NOT NULL,
    user_id     NUMBER(10),
    insert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_planners_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- シーケンスの作成
CREATE SEQUENCE seq_planners START WITH 1 INCREMENT BY 1;
