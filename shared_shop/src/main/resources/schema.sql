-- Issue #4 & #5: Add role and account lock columns to users table
ALTER TABLE users ADD role VARCHAR2(10) DEFAULT 'USER';
ALTER TABLE users ADD failed_login_count NUMBER(10) DEFAULT 0;
ALTER TABLE users ADD locked_until TIMESTAMP;

-- Update existing users to have a role based on their authority
UPDATE users SET role = 'ADMIN' WHERE authority IN (0, 1);
UPDATE users SET role = 'USER' WHERE authority = 2;
UPDATE users SET role = 'USER' WHERE role IS NULL;
COMMIT;
