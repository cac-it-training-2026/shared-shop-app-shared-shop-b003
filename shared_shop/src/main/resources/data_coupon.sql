-- サンプルクーポンの登録
-- 100円引きクーポン
INSERT INTO coupons (id, code, discount_type, discount_value, valid_from, valid_until, usage_limit)
VALUES (seq_coupons.NEXTVAL, 'SAVE100', 'amount', 100, TO_TIMESTAMP('2026-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), 100);

-- 10%引きクーポン
INSERT INTO coupons (id, code, discount_type, discount_value, valid_from, valid_until, usage_limit)
VALUES (seq_coupons.NEXTVAL, 'SAVE10', 'percent', 10, TO_TIMESTAMP('2026-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), 50);
