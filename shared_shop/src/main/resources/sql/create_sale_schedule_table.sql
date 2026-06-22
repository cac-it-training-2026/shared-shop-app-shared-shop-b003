-- タイムセールスケジュールテーブルの作成
CREATE TABLE sale_schedule (
    id NUMBER(10) PRIMARY KEY,
    category_id NUMBER(10) NOT NULL,
    start_time VARCHAR2(8) NOT NULL, -- HH:mm:ss形式
    end_time VARCHAR2(8) NOT NULL,   -- HH:mm:ss形式
    discount_rate NUMBER(3) NOT NULL,
    enabled NUMBER(1) DEFAULT 1 NOT NULL,
    CONSTRAINT fk_sale_category FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- シーケンスの作成
CREATE SEQUENCE seq_sale_schedule START WITH 1 INCREMENT BY 1;

-- サンプルデータの挿入
-- カテゴリIDは既存のデータに合わせて調整が必要ですが、一般的なIDを想定
INSERT INTO sale_schedule (id, category_id, start_time, end_time, discount_rate, enabled)
VALUES (seq_sale_schedule.NEXTVAL, 1, '12:00:00', '14:00:00', 20, 1); -- 食料品（12:00〜14:00 20%OFF）

INSERT INTO sale_schedule (id, category_id, start_time, end_time, discount_rate, enabled)
VALUES (seq_sale_schedule.NEXTVAL, 2, '20:00:00', '23:00:00', 15, 1); -- 書籍（20:00〜23:00 15%OFF）

INSERT INTO sale_schedule (id, category_id, start_time, end_time, discount_rate, enabled)
VALUES (seq_sale_schedule.NEXTVAL, 3, '18:00:00', '21:00:00', 10, 1); -- 雑貨（18:00〜21:00 10%OFF）

COMMIT;
