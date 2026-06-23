-- タイムセール用テーブル
CREATE TABLE sale_schedule (
    id NUMBER(10) PRIMARY KEY,
    category_id NUMBER(10),
    start_time DATE,
    end_time DATE,
    discount_rate NUMBER(3),
    delete_flag NUMBER(1) DEFAULT 0,
    CONSTRAINT fk_sale_category FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- シーケンス
CREATE SEQUENCE seq_sale_schedule START WITH 1 INCREMENT BY 1;

-- サンプルデータ
-- 注：OracleのDATE型は時刻も含むが、LocalTimeでマッピングする場合は注意が必要。
-- JPAでLocalTimeを使う場合、DB側はTIME型やTIMESTAMP型が望ましいが、既存の構成に合わせる。
-- ここでは例示のためのINSERT文（実際の型に合わせて調整が必要な場合あり）
-- 食料品 (categoryId: 1を想定) 12:00〜14:00 20%OFF
INSERT INTO sale_schedule (id, category_id, start_time, end_time, discount_rate, delete_flag)
VALUES (seq_sale_schedule.NEXTVAL, 1, TO_DATE('12:00:00', 'HH24:MI:SS'), TO_DATE('14:00:00', 'HH24:MI:SS'), 20, 0);

-- 書籍 (categoryId: 2を想定) 20:00〜23:00 15%OFF
INSERT INTO sale_schedule (id, category_id, start_time, end_time, discount_rate, delete_flag)
VALUES (seq_sale_schedule.NEXTVAL, 2, TO_DATE('20:00:00', 'HH24:MI:SS'), TO_DATE('23:00:00', 'HH24:MI:SS'), 15, 0);

-- 雑貨 (categoryId: 3を想定) 18:00〜21:00 10%OFF
INSERT INTO sale_schedule (id, category_id, start_time, end_time, discount_rate, delete_flag)
VALUES (seq_sale_schedule.NEXTVAL, 3, TO_DATE('18:00:00', 'HH24:MI:SS'), TO_DATE('21:00:00', 'HH24:MI:SS'), 10, 0);
