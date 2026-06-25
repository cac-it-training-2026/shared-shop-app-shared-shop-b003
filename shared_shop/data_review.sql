-- サンプルデータの投入
-- 商品IDやユーザーIDは既存のデータに合わせて調整が必要
INSERT INTO reviews (id, item_id, user_id, evaluation, content, stamp, insert_date)
VALUES (seq_reviews.NEXTVAL, 1, 1, 5, 'とても良い商品でした！', 1, SYSDATE);

INSERT INTO reviews (id, item_id, user_id, evaluation, content, stamp, insert_date)
VALUES (seq_reviews.NEXTVAL, 1, 2, 4, 'おすすめの逸品です。', 2, SYSDATE);

COMMIT;
