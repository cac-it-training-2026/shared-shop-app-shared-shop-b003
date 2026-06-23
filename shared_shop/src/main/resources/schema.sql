-- Issue #5: Account Lock functionality
ALTER TABLE users ADD failed_login_count NUMBER(10) DEFAULT 0;
ALTER TABLE users ADD locked_until TIMESTAMP;
COMMIT;
