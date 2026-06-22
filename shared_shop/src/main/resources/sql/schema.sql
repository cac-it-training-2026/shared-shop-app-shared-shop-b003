-- usersテーブルにcurrent_pointカラムを追加
ALTER TABLE users ADD current_point NUMBER DEFAULT 0 NOT NULL;

-- 既存ユーザーのポイントを0で初期化（DEFAULT 0があるので基本不要だが念のため）
UPDATE users SET current_point = 0 WHERE current_point IS NULL;

-- point_historiesテーブルの作成
CREATE TABLE point_histories (
    id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    point NUMBER NOT NULL,
    balance NUMBER NOT NULL,
    type VARCHAR2(20) NOT NULL,
    description VARCHAR2(255),
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_point_histories_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- point_histories用シーケンスの作成
CREATE SEQUENCE seq_point_histories START WITH 1 INCREMENT BY 1;
