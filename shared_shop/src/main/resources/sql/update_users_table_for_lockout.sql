-- usersテーブルにログイン失敗回数とロック解除時刻を追加するSQL
ALTER TABLE users ADD failed_login_count NUMBER(10) DEFAULT 0;
ALTER TABLE users ADD locked_until TIMESTAMP;

COMMENT ON COLUMN users.failed_login_count IS 'ログイン失敗回数';
COMMENT ON COLUMN users.locked_until IS 'ロック解除時刻';
