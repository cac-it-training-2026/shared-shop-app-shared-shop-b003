-- Issue #4 & #5: Add role and account lock columns to users table
ALTER TABLE users ADD role VARCHAR2(10) DEFAULT 'USER';
ALTER TABLE users ADD failed_login_count NUMBER(10) DEFAULT 0;
ALTER TABLE users ADD locked_until TIMESTAMP;
ALTER TABLE users ADD gacha_count NUMBER(10) DEFAULT 0;

-- Issue #7: Coupon table
CREATE TABLE coupons (
    id NUMBER(10) PRIMARY KEY,
    code VARCHAR2(20) UNIQUE NOT NULL,
    discount_type VARCHAR2(10) NOT NULL,
    discount_value NUMBER(10) NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_until TIMESTAMP NOT NULL,
    usage_limit NUMBER(10),
    created_by NUMBER(10)
);

CREATE SEQUENCE seq_coupons START WITH 1 INCREMENT BY 1;

-- Issue #10: Gacha Log table
CREATE TABLE gacha_logs (
    id NUMBER(10) PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    event_type VARCHAR2(20) NOT NULL,
    outcome VARCHAR2(10) NOT NULL,
    coupon_id NUMBER(10),
    source_order_id NUMBER(10),
    ip_address VARCHAR2(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE SEQUENCE seq_gacha_logs START WITH 1 INCREMENT BY 1;

-- Sample Coupons
INSERT INTO coupons (id, code, discount_type, discount_value, valid_from, valid_until, created_by)
VALUES (1, 'WELCOME10', 'percent', 10, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '30' DAY, 1);
INSERT INTO coupons (id, code, discount_type, discount_value, valid_from, valid_until, created_by)
VALUES (2, 'THANKS500', 'amount', 500, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '30' DAY, 1);

-- Update existing users to have a role based on their authority
UPDATE users SET role = 'ADMIN' WHERE authority IN (0, 1);
UPDATE users SET role = 'USER' WHERE authority = 2;
UPDATE users SET role = 'USER' WHERE role IS NULL;
COMMIT;
