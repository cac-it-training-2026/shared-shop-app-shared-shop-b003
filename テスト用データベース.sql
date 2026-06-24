--system\x83\x86\x81[\x83U\x82Őڑ\xb1\x8c\xe3\x81A\x89\xba\x8bL\x82\xccSQL\x82\xf0\x8e\xc0\x8ds\x82\xb7\x82\xe9\x81B
-- PDB\x82ɐ؂\xe8\x91ւ\xa6
ALTER SESSION SET CONTAINER = xepdb1;
-- \x83\x86\x81[\x83U\x82̍쐬
CREATE USER shared_shop_user IDENTIFIED BY systemsss;
-- \x8c\xa0\x8c\xc0\x82̕t\x97^
GRANT ALL PRIVILEGES TO shared_shop_user;

--shared_shop_user\x82Őڑ\xb1\x82\xb5\x82\xbd\x8c\xe3\x81A\x89\xba\x8bL\x82̃e\x81[\x83u\x83\x8b\x81A\x83V\x81[\x83P\x83\x93\x83X\x8d쐬\x8by\x82уf\x81[\x83^\x82̒ǉ\xc1\x82\xf0\x8ds\x82\xa4


-----------------------------------------------------------------------
/*\x8f\x89\x8a\xfa\x89\xbb\x95\xb6*/
-- 1. \x92\x8d\x95\xb6\x8f\xa4\x95i\x83e\x81[\x83u\x83\x8b\x81i\x92\x8d\x95\xb6\x82Ə\xa4\x95i\x82Ɉˑ\xb6\x81j\x82̍폜
DROP TABLE order_items CASCADE CONSTRAINTS;

-- 2. \x92\x8d\x95\xb6\x83e\x81[\x83u\x83\x8b\x81i\x89\xef\x88\xf5\x82Ɉˑ\xb6\x81j\x82̍폜
DROP TABLE orders CASCADE CONSTRAINTS;

-- 3. \x89\xef\x88\xf5\x83e\x81[\x83u\x83\x8b\x82̍폜
DROP TABLE users CASCADE CONSTRAINTS;

-- 4. \x8f\xa4\x95i\x83e\x81[\x83u\x83\x8b\x81i\x83J\x83e\x83S\x83\x8a\x82Ɉˑ\xb6\x81j\x82̍폜
DROP TABLE items CASCADE CONSTRAINTS;

-- 5. \x83J\x83e\x83S\x83\x8a\x83e\x81[\x83u\x83\x8b\x82̍폜
DROP TABLE categories CASCADE CONSTRAINTS;

-- 6. \x83\x8c\x83r\x83\x85\x81[\x83e\x81[\x83u\x83\x8b\x82̍폜
DROP TABLE reviews;

-- \x83V\x81[\x83P\x83\x93\x83X\x82̍폜
DROP SEQUENCE seq_order_items;
DROP SEQUENCE seq_orders;
DROP SEQUENCE seq_users;
DROP SEQUENCE seq_items;
DROP SEQUENCE seq_categories;
DROP SEQUENCE seq_reviews;

PURGE RECYCLEBIN;

-----------------------------------------------------------------------
-- \x83J\x83e\x83S\x83\x8a\x83e\x81[\x83u\x83\x8b\x82̍쐬

-- \x8d폜\x83t\x83\x89\x83O\x82\xaa\x8f\x89\x8a\xfa\x92l0
CREATE TABLE categories (
  id NUMBER(2) PRIMARY KEY,
  name VARCHAR2(15 CHAR) NOT NULL,
  description VARCHAR2(30 CHAR),
  delete_flag NUMBER(1) DEFAULT 0 NOT NULL,
  insert_date DATE DEFAULT SYSDATE NOT NULL
);

-- \x8d폜\x83t\x83\x89\x83O\x82\xaa\x8f\x89\x8a\xfa\x92l1 \x83f\x81[\x83^\x94\xf1\x95\\x8e\xa6\x83e\x83X\x83g\x97p
-- CREATE TABLE categories (
--   id NUMBER(2) PRIMARY KEY,
--   name VARCHAR2(15 CHAR) NOT NULL,
--   description VARCHAR2(30 CHAR),
--   delete_flag NUMBER(1) DEFAULT 1 NOT NULL,
--   insert_date DATE DEFAULT SYSDATE NOT NULL
-- );

-----------------------------------------------------------------------
-- \x8f\xa4\x95i\x83e\x81[\x83u\x83\x8b\x82̍쐬

-- \x8d폜\x83t\x83\x89\x83O\x82\xaa\x8f\x89\x8a\xfa\x92l0
CREATE TABLE items (
  id NUMBER(6) PRIMARY KEY,
  name VARCHAR2(100 CHAR) NOT NULL,
  price NUMBER(7) NOT NULL,
  description VARCHAR2(400 CHAR),
  stock NUMBER(4) DEFAULT 0 NOT NULL,
  image VARCHAR2(64 CHAR),
  category_id NUMBER(2) REFERENCES categories(id) NOT NULL,
  delete_flag NUMBER(1) DEFAULT 0 NOT NULL,
  insert_date DATE DEFAULT SYSDATE NOT NULL
);

-- \x8d폜\x83t\x83\x89\x83O\x82\xaa\x8f\x89\x8a\xfa\x92l1 \x83f\x81[\x83^\x94\xf1\x95\\x8e\xa6\x83e\x83X\x83g\x97p
-- CREATE TABLE items (
--   id NUMBER(6) PRIMARY KEY,
--   name VARCHAR2(100 CHAR) NOT NULL,
--   price NUMBER(7) NOT NULL,
--   description VARCHAR2(400 CHAR),
--   stock NUMBER(4) DEFAULT 0 NOT NULL,
--   image VARCHAR2(64 CHAR),
--   category_id NUMBER(2) REFERENCES categories(id) NOT NULL,
--   delete_flag NUMBER(1) DEFAULT 1 NOT NULL,
--   insert_date DATE DEFAULT SYSDATE NOT NULL
-- );


-----------------------------------------------------------------------

-- \x89\xef\x88\xf5\x83e\x81[\x83u\x83\x8b\x82̍쐬

-- \x8d폜\x83t\x83\x89\x83O\x82\xaa\x8f\x89\x8a\xfa\x92l0
CREATE TABLE users (
  id NUMBER(6) PRIMARY KEY,
  email VARCHAR2(256) UNIQUE NOT NULL,
  password VARCHAR2(16) NOT NULL,
  name VARCHAR2(30 CHAR) NOT NULL,
  postal_code VARCHAR2(7) NOT NULL,
  address VARCHAR2(150 CHAR) NOT NULL,
  phone_number VARCHAR2(11) NOT NULL,
  authority NUMBER(1) NOT NULL,
  delete_flag NUMBER(1) DEFAULT 0 NOT NULL,
  insert_date DATE DEFAULT SYSDATE NOT NULL
);

-- \x8d폜\x83t\x83\x89\x83O\x82\xaa\x8f\x89\x8a\xfa\x92l1 \x83f\x81[\x83^\x94\xf1\x95\\x8e\xa6\x83e\x83X\x83g\x97p
-- CREATE TABLE users (
--   id NUMBER(6) PRIMARY KEY,
--   email VARCHAR2(256) UNIQUE NOT NULL,
--   password VARCHAR2(16) NOT NULL,
--   name VARCHAR2(30 CHAR) NOT NULL,
--   postal_code VARCHAR2(7) NOT NULL,
--   address VARCHAR2(150 CHAR) NOT NULL,
--   phone_number VARCHAR2(11) NOT NULL,
--   authority NUMBER(1) NOT NULL,
--   delete_flag NUMBER(1) DEFAULT 1 NOT NULL,
--   insert_date DATE DEFAULT SYSDATE NOT NULL
-- );


-----------------------------------------------------------------------
-- \x92\x8d\x95\xb6\x83e\x81[\x83u\x83\x8b
CREATE TABLE orders (
  id NUMBER(6) PRIMARY KEY,
  postal_code VARCHAR2(7) NOT NULL,
  address VARCHAR2(150 CHAR) NOT NULL,
  name VARCHAR2(30 CHAR) NOT NULL,
  phone_number VARCHAR2(11) NOT NULL,
  pay_method NUMBER(1) NOT NULL,
  user_id NUMBER(6) REFERENCES users(id) NOT NULL,
  insert_date DATE DEFAULT SYSDATE NOT NULL
);


-----------------------------------------------------------------------
-- \x92\x8d\x95\xb6\x8f\xa4\x95i\x83e\x81[\x83u\x83\x8b
CREATE TABLE order_items (
  id NUMBER(6) PRIMARY KEY,
  quantity NUMBER(4) NOT NULL,
  order_id NUMBER(6) REFERENCES orders(id) NOT NULL,
  item_id NUMBER(6) REFERENCES items(id) NOT NULL,
  price NUMBER(7) NOT NULL
);

-----------------------------------------------------------------------
-- \x83\x8c\x83r\x83\x85\x81[\x83e\x81[\x83u\x83\x8b\x82̍쐬
CREATE TABLE reviews (
    id NUMBER(10) PRIMARY KEY,
    item_id NUMBER(10) NOT NULL,
    user_id NUMBER(10) NOT NULL,
    rating NUMBER(1) NOT NULL,
    body VARCHAR2(1000) NOT NULL,
    delete_flag NUMBER(1) DEFAULT 0 NOT NULL,
    insert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_reviews_item FOREIGN KEY (item_id) REFERENCES items(id),
    CONSTRAINT fk_reviews_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-----------------------------------------------------------------------
-- \x83V\x81[\x83P\x83\x93\x83X\x82̍쐬(\x83J\x83e\x83S\x83\x8a\x83e\x81[\x83u\x83\x8b\x97p)
CREATE SEQUENCE seq_categories NOCACHE;

-- \x83V\x81[\x83P\x83\x93\x83X\x82̍쐬(\x8f\xa4\x95i\x83e\x81[\x83u\x83\x8b\x97p)
CREATE SEQUENCE seq_items NOCACHE;

-- \x83V\x81[\x83P\x83\x93\x83X\x82̍쐬(\x89\xef\x88\xf5\x83e\x81[\x83u\x83\x8b\x97p)
CREATE SEQUENCE seq_users NOCACHE;

-- \x83V\x81[\x83P\x83\x93\x83X\x82̍쐬(\x92\x8d\x95\xb6\x83e\x81[\x83u\x83\x8b\x97p)
CREATE SEQUENCE seq_orders NOCACHE;

-- \x83V\x81[\x83P\x83\x93\x83X\x82̍쐬(\x92\x8d\x95\xb6\x8f\xa4\x95i\x83e\x81[\x83u\x83\x8b\x97p)
CREATE SEQUENCE seq_order_items NOCACHE;

-- \x83V\x81[\x83P\x83\x93\x83X\x82̍쐬(\x83\x8c\x83r\x83\x85\x81[\x83e\x81[\x83u\x83\x8b\x97p)
CREATE SEQUENCE seq_reviews START WITH 1 INCREMENT BY 1;



-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- \x83\x8c\x83R\x81[\x83h\x93o\x98^(\x83J\x83e\x83S\x83\x8a)
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '\x90H\x97\xbf\x95i', '\x96\xec\x8dؗށA\x93\xf7\x97ށA\x8aC\x8eY\x95\xa8\x81A\x89\xc1\x8dH\x90H\x95i\x82Ȃǂ\xf0\x88\xb5\x82\xa2\x82܂\xb7\x81B', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '\x8f\x91\x90\xd0', '\x98a\x8f\x91\x81A\x97m\x8f\x91\x81A\x90\xea\x96发\x81A\x96\x9f\x89\xe6\x81A\x8eG\x8e\x8f\x82Ȃǂ\xf0\x88\xb5\x82\xa2\x82܂\xb7\x81B', DEFAULT, DEFAULT);

-- \x83\x8c\x83R\x81[\x83h\x93o\x98^(\x8f\xa4\x95i)
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x82\xe8\x82\xf1\x82\xb2', 100, '\x90X\x8c\xa7\x8eY\x82̂\xe8\x82񂲂ł\xb7\x81B\x82Ƃ\xc1\x82Ă\xe0\x82݂\xb8\x82݂\xb8\x82\xb5\x82\xa2\x81I', 0, 'apple.jpg', 1, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x8e\xab\x8f\x91', 2000, '\x82\xb1\x82\xea\x88\xea\x8d\xfb\x82\xaa\x82\xa0\x82\xea\x82Α\xe5\x8f\xe4\x95v\x81I', 1, 'dictionary.jpg', 2, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83I\x83\x8c\x83\x93\x83W', 150, '\x83I\x81[\x83X\x83g\x83\x89\x83\x8a\x83A\x8eY\x82̃I\x83\x8c\x83\x93\x83W\x82ł\xb7\x81B', 5, NULL, 1, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83o\x83i\x83i', 150, '\x83o\x83i\x83i\x82ł\xb7\x81B', 6, NULL, 1, DEFAULT, DEFAULT);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83e\x83X\x83g\x8f\xa4\x95i', 150, '\x83e\x83X\x83g\x97p\x83f\x81[\x83^\x82ł\xb7\x81B', 9999, NULL, 1, DEFAULT, DEFAULT);

-- \x83\x8c\x83R\x81[\x83h\x93o\x98^(\x89\xef\x88\xf5)
INSERT INTO users VALUES(seq_users.NEXTVAL, 'tanaka_taro@test.co.jp', 'Testtest0', '\x83V\x83X\x83e\x83\x80\x8aǗ\x9d\x91\xbe\x98Y', '1111111', '\x93\x8c\x8b\x9e\x93s\x91䓌\x8b\xe61-2-3 ABC\x83r\x83\x8b10\x8aK', '0123456789', 0, DEFAULT, DEFAULT);
INSERT INTO users VALUES(seq_users.NEXTVAL, 'unyo_jiro@test.co.jp', 'Testtest1', '\x89^\x97p\x8aǗ\x9d\x93\xf1\x98Y', '1111111', '\x93\x8c\x8b\x9e\x93s\x91䓌\x8b\xe61-2-3 ABC\x83r\x83\x8b10\x8aK', '0123456789', 1, DEFAULT, DEFAULT);
INSERT INTO users VALUES(seq_users.NEXTVAL, 'ippan_saburo@test.co.jp', 'Testtest2', '\x88\xea\x94ʎO\x98Y', '1111111', '\x93\x8c\x8b\x9e\x93s\x91䓌\x8b\xe64-5-6 ABC\x83}\x83\x93\x83V\x83\x87\x83\x935\x8aK', '0123456789', 2, DEFAULT, DEFAULT);


-- \x83f\x81[\x83^\x8c\x8f\x90\x94\x83e\x83X\x83g\x93\x99\x82ōs\x82\xf0\x92ǉ\xc1
-- \x83\x8c\x83R\x81[\x83h\x93o\x98^(\x92\x8d\x95\xb6)
INSERT INTO orders VALUES(seq_orders.NEXTVAL, '1111111', '\x93\x8c\x8b\x9e\x93s\x91䓌\x8b\xe64-5-6 ABC\x83}\x83\x93\x83V\x83\x87\x83\x935\x8aK', '\x88\xea\x94ʎO\x98Y', '0123456789', 2, 3, DEFAULT);
INSERT INTO orders VALUES(seq_orders.NEXTVAL, '1111111', '\x93\x8c\x8b\x9e\x93s\x91䓌\x8b\xe64-5-6 ABC\x83}\x83\x93\x83V\x83\x87\x83\x935\x8aK', '\x88\xea\x94ʎO\x98Y', '0123456789', 2, 3, DEFAULT);
INSERT INTO orders VALUES(seq_orders.NEXTVAL, '1111111', '\x93\x8c\x8b\x9e\x93s\x91䓌\x8b\xe64-5-6 ABC\x83}\x83\x93\x83V\x83\x87\x83\x935\x8aK', '\x88\xea\x94ʎO\x98Y', '0123456789', 2, 3, DEFAULT);

-- \x83f\x81[\x83^\x8c\x8f\x90\x94\x83e\x83X\x83g\x93\x99\x82ōs\x82\xf0\x92ǉ\xc1
-- \x83\x8c\x83R\x81[\x83h\x93o\x98^(\x8f\xa4\x95i\x92\x8d\x95\xb6)
INSERT INTO order_items VALUES(seq_order_items.NEXTVAL, 4, 1, 1, 100);
INSERT INTO order_items VALUES(seq_order_items.NEXTVAL, 4, 2, 1, 100);
INSERT INTO order_items VALUES(seq_order_items.NEXTVAL, 4, 3, 1, 100);



-----------------------------------------------------------------------

-- users\x83e\x81[\x83u\x83\x8b\x82Ƀe\x81[\x83}ID\x81A\x8dw\x93\xfc\x89񐔁A\x97݌v\x8dw\x93\xfc\x8b\xe0\x8az\x82̃J\x83\x89\x83\x80\x82\xf0\x92ǉ\xc1
ALTER TABLE users ADD purchase_count NUMBER(10) DEFAULT 0;
ALTER TABLE users ADD theme_id NUMBER(10) DEFAULT 1;
ALTER TABLE users ADD total_purchase_amount NUMBER(10) DEFAULT 0;

-----------------------------------------------------------------------
-- \x83R\x83~\x83b\x83g
COMMIT;




-- \x83e\x83X\x83g\x97pSQL
-- 005
DELETE order_items; -- \x94\x84\x82\xea\x8b؏\xa4\x95i\x82̍폜
DELETE items; -- \x8f\xa4\x95i\x8f\xee\x95\xf1\x82̍폜


-- 008
  -- \x94\x84\x82ꂽ\x90\x94\x82𓯂\xb6\x82\xc9
UPDATE order_items SET item_id = 2 where id = 2;
UPDATE order_items SET item_id = 3 where id = 3;

-- 009
DELETE items WHERE category_id = 2; -- \x8f\xa4\x95i\x8f\xee\x95\xf1\x82̍폜

-- 011
UPDATE items SET stock = 1; -- \x8d݌ɂ\xf01\x82\xc9
UPDATE items SET stock = 0; -- \x8d݌ɂ\xf00\x82\xc9
UPDATE items SET delete_flag = 1; -- \x8f\xa4\x95i\x82\xf0\x8d폜