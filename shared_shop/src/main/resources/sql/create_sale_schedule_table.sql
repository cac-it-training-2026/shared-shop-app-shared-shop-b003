-- タイムセール用テーブル
CREATE TABLE sale_schedule (
    id NUMBER(10) PRIMARY KEY,
    category_id NUMBER(10),
    start_time VARCHAR2(8),
    end_time VARCHAR2(8),
    discount_rate NUMBER(3),
    delete_flag NUMBER(1) DEFAULT 0,
    CONSTRAINT fk_sale_category FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- シーケンス
CREATE SEQUENCE seq_sale_schedule START WITH 1 INCREMENT BY 1;

-- サンプルデータ
-- 食料品 (categoryId: 1を想定) 00:00〜23:59 20%OFF (動作確認用)
INSERT INTO sale_schedule (id, category_id, start_time, end_time, discount_rate, delete_flag)
VALUES (seq_sale_schedule.NEXTVAL, 1, '00:00:00', '23:59:59', 20, 0);

-- 書籍 (categoryId: 2を想定) 20:00〜23:00 15%OFF
INSERT INTO sale_schedule (id, category_id, start_time, end_time, discount_rate, delete_flag)
VALUES (seq_sale_schedule.NEXTVAL, 2, '20:00:00', '23:00:00', 15, 0);

-- 雑貨 (categoryId: 3を想定) 18:00〜21:00 10%OFF
INSERT INTO sale_schedule (id, category_id, start_time, end_time, discount_rate, delete_flag)
VALUES (seq_sale_schedule.NEXTVAL, 3, '18:00:00', '21:00:00', 10, 0);
