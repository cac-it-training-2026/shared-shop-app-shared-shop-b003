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
-----------------------------------------------------------------------
-- プランナーキーワードカテゴリテーブルの作成
-- \x83J\x83e\x83S\x83\x8a\x92ǉ\xc1
INSERT INTO categories VALUES(seq_categories.NEXTVAL, 'PC', '\x83f\x83X\x83N\x83g\x83b\x83vPC\x81A\x83m\x81[\x83gPC\x82Ȃ\xc7', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '\x83\x82\x83j\x83^\x81[', '\x89t\x8f\xbb\x83f\x83B\x83X\x83v\x83\x8c\x83C\x81A\x83Q\x81[\x83~\x83\x93\x83O\x83\x82\x83j\x83^\x81[\x82Ȃ\xc7', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '\x83L\x81[\x83{\x81[\x83h', '\x83\x81\x83J\x83j\x83J\x83\x8b\x81A\x83\x81\x83\x93\x83u\x83\x8c\x83\x93\x81A\x90Ód\x97e\x97ʖ\xb3\x90ړ_\x95\xfb\x8e\xae\x82Ȃ\xc7', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '\x83}\x83E\x83X', '\x83\x8f\x83C\x83\x84\x83\x8c\x83X\x81A\x83Q\x81[\x83~\x83\x93\x83O\x83}\x83E\x83X\x82Ȃ\xc7', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '\x8d\x82\x90\xab\x94\PC', '\x93\xae\x89\xe6\x95ҏW\x82\xe23D\x83Q\x81[\x83\x80\x8c\xfc\x82\xaf\x82̃n\x83C\x83X\x83y\x83b\x83NPC', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, 'SSD', '\x8d\x82\x91\xac\x83X\x83g\x83\x8c\x81[\x83W\x91\x95\x92u', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '\x83I\x83t\x83B\x83X\x97p\x95i', '\x83f\x83X\x83N\x81A\x83`\x83F\x83A\x81A\x95\xb6\x96[\x8b\xef\x82Ȃ\xc7', DEFAULT, DEFAULT);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '\x89ʕ\xa8', '\x8f{\x82̃t\x83\x8b\x81[\x83c', DEFAULT, DEFAULT);

-- \x8f\xa4\x95i\x92ǉ\xc1 (\x8ae\x83J\x83e\x83S\x83\x8a3\x93_\x88ȏ\xe3\x81A\x8d݌ɂ\xa0\x82\xe8\x81A\x8d폜\x83t\x83\x89\x83O0)

-- PC (Category ID: 3)
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83X\x83^\x83\x93\x83_\x81[\x83h\x83m\x81[\x83gPC', 50000, '\x95\x81\x92i\x8eg\x82\xa2\x82ɍœK\x82\xc8PC', 10, NULL, 3, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83r\x83W\x83l\x83X\x83m\x81[\x83gPC', 80000, '\x8ed\x8e\x96\x82ɍœK\x82\xc8PC', 10, NULL, 3, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83v\x83\x8c\x83~\x83A\x83\x80\x83m\x81[\x83gPC', 120000, '\x8d\x82\x90\xab\x94\\x82\xc8PC', 10, NULL, 3, 0, SYSDATE);

-- \x83\x82\x83j\x83^\x81[ (Category ID: 4)
INSERT INTO items VALUES(seq_items.NEXTVAL, '21\x83C\x83\x93\x83`\x83\x82\x83j\x83^\x81[', 15000, '\x83R\x83\x93\x83p\x83N\x83g\x82ȃ\x82\x83j\x83^\x81[', 10, NULL, 4, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '24\x83C\x83\x93\x83`\x83t\x83\x8bHD\x83\x82\x83j\x83^\x81[', 25000, '\x95W\x8f\x80\x93I\x82ȃ\x82\x83j\x83^\x81[', 10, NULL, 4, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '27\x83C\x83\x93\x83`4K\x83\x82\x83j\x83^\x81[', 45000, '\x8d\x82\x90\xb8\x8dׂȃ\x82\x83j\x83^\x81[', 10, NULL, 4, 0, SYSDATE);

-- \x83L\x81[\x83{\x81[\x83h (Category ID: 5)
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83\x81\x83\x93\x83u\x83\x8c\x83\x93\x83L\x81[\x83{\x81[\x83h', 2000, '\x90Â\xa9\x82ȃL\x81[\x83{\x81[\x83h', 10, NULL, 5, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83\x81\x83J\x83j\x83J\x83\x8b\x83L\x81[\x83{\x81[\x83h', 8000, '\x90S\x92n\x82悢\x91Ō\xae\x8a\xb4', 10, NULL, 5, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x8d\x82\x8b\x89\x90Ód\x97e\x97ʖ\xb3\x90ړ_\x83L\x81[\x83{\x81[\x83h', 25000, '\x8dō\x82\x82̃^\x83C\x83s\x83\x93\x83O\x91̌\xb1', 10, NULL, 5, 0, SYSDATE);

-- \x83}\x83E\x83X (Category ID: 6)
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x97L\x90\xfc\x8c\xf5\x8aw\x8e\xae\x83}\x83E\x83X', 1000, '\x83V\x83\x93\x83v\x83\x8b\x82ȃ}\x83E\x83X', 10, NULL, 6, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83\x8f\x83C\x83\x84\x83\x8c\x83X\x83}\x83E\x83X', 3000, '\x95֗\x98\x82ȃ}\x83E\x83X', 10, NULL, 6, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x91\xbd\x83{\x83^\x83\x93\x83Q\x81[\x83~\x83\x93\x83O\x83}\x83E\x83X', 10000, '\x91\xbd\x8b@\x94\\x82ȃ}\x83E\x83X', 10, NULL, 6, 0, SYSDATE);

-- \x8f\x91\x90\xd0 (Category ID: 2)
INSERT INTO items VALUES(seq_items.NEXTVAL, 'Java\x93\xfc\x96\xe5', 3000, 'Java\x82̊\xee\x91b\x82\xf0\x8aw\x82\xd4', 10, NULL, 2, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, 'Spring Boot\x93O\x92\xea\x89\xf0\x90\xe0', 4500, '\x8e\xc0\x91H\x93I\x82ȃt\x83\x8c\x81[\x83\x80\x83\x8f\x81[\x83N\x8aw\x8fK', 10, NULL, 2, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83\\x83t\x83g\x83E\x83F\x83A\x83A\x81[\x83L\x83e\x83N\x83`\x83\x83', 6000, '\x8d\x82\x93x\x82Ȑ݌v\x8e\xe8\x96@', 10, NULL, 2, 0, SYSDATE);

-- \x8d\x82\x90\xab\x94\PC (Category ID: 7)
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83G\x83\x93\x83g\x83\x8a\x81[\x83Q\x81[\x83~\x83\x93\x83OPC', 150000, '\x83Q\x81[\x83\x80\x93\xfc\x96\xe5\x82\xc9', 5, NULL, 7, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83~\x83h\x83\x8b\x83\x8c\x83\x93\x83W\x83Q\x81[\x83~\x83\x93\x83OPC', 250000, '\x82قƂ\xf1\x82ǂ̃Q\x81[\x83\x80\x82\xaa\x89\xf5\x93K', 5, NULL, 7, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83n\x83C\x83G\x83\x93\x83h\x83\x8f\x81[\x83N\x83X\x83e\x81[\x83V\x83\x87\x83\x93', 450000, '\x83v\x83\x8d\x82̓\xae\x89\xe6\x95ҏW\x82\xc9', 5, NULL, 7, 0, SYSDATE);

-- SSD (Category ID: 8)
INSERT INTO items VALUES(seq_items.NEXTVAL, '500GB SSD', 7000, '\x8e\xe8\x8cy\x82ɑ\x9d\x90\xdd', 20, NULL, 8, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '1TB NVMe SSD', 15000, '\x8d\x82\x91\xac\x82ȃf\x81[\x83^\x93]\x91\x97', 20, NULL, 8, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '2TB \x8d\x82\x91ϋvSSD', 30000, '\x91\xe5\x97e\x97ʂň\xc0\x90S', 20, NULL, 8, 0, SYSDATE);

-- \x83I\x83t\x83B\x83X\x97p\x95i (Category ID: 9)
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83V\x83\x93\x83v\x83\x8b\x83f\x83X\x83N', 10000, '\x8eg\x82\xa2\x82₷\x82\xa2\x83f\x83X\x83N', 10, NULL, 9, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83G\x83\x8b\x83S\x83m\x83~\x83N\x83X\x83`\x83F\x83A', 30000, '\x94\xe6\x82\xea\x82ɂ\xad\x82\xa2\x88֎q', 10, NULL, 9, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x8f\xb8\x8d~\x83f\x83X\x83N', 60000, '\x97\xa7\x82\xc1\x82Ă\xe0\x8d\xc0\x82\xc1\x82Ă\xe0\x8eg\x82\xa6\x82\xe9', 10, NULL, 9, 0, SYSDATE);

-- \x90H\x97\xbf\x95i (Category ID: 1)
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x93\xc1\x91储\x82ɂ\xac\x82\xe8', 200, '\x83{\x83\x8a\x83\x85\x81[\x83\x80\x96\x9e\x93_', 50, NULL, 1, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x8d\x82\x8b\x89\x83\x8c\x83g\x83\x8b\x83g\x83J\x83\x8c\x81[', 800, '\x82\xa8\x93X\x82̖\xa1', 50, NULL, 1, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x8d\x8b\x89؂\xa8\x8e\xe6\x82\xe8\x8a񂹃Z\x83b\x83g', 5000, '\x8e\xa9\x95\xaa\x82ւ̂\xb2\x96J\x94\xfc', 10, NULL, 1, 0, SYSDATE);

-- \x89ʕ\xa8 (Category ID: 10)
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83T\x83\x93\x82ӂ\xb6(\x82\xe8\x82\xf1\x82\xb2)', 200, '\x8aÂ݂\xaa\x8b\xad\x82\xa2', 30, NULL, 10, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x8d\x82\x8b\x89\x8a\xae\x8fn\x83\x81\x83\x8d\x83\x93', 3000, '\x96F\x8f\x86\x82ȍ\x81\x82\xe8', 5, NULL, 10, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83V\x83\x83\x83C\x83\x93\x83}\x83X\x83J\x83b\x83g', 5000, '\x8e\xed\x82Ȃ\xb5\x82ŐH\x82ׂ₷\x82\xa2', 5, NULL, 10, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x8a\xae\x8fn\x83o\x83i\x83i', 300, '\x89h\x97{\x96\x9e\x93_', 20, NULL, 10, 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x89\xb7\x8fB\x82݂\xa9\x82\xf1 5kg', 2500, '\x93~\x82̒\xe8\x94\xd4', 15, NULL, 10, 0, SYSDATE);

-- \x83L\x81[\x83\x8f\x81[\x83h\x83}\x83b\x83s\x83\x93\x83O\x82̃N\x83\x8a\x83A
-- \x83J\x83e\x83S\x83\x8a\x8am\x94F\x81E\x92ǉ\xc1
-- \x90H\x97\xbf\x95i (1), \x8f\x91\x90\xd0 (2) \x82͊\xf9\x82ɂ\xa0\x82\xe9\x91z\x92\xe8
-- \x90V\x8bK: PC (3), \x83\x82\x83j\x83^\x81[ (4), \x83L\x81[\x83{\x81[\x83h (5), \x83}\x83E\x83X (6), \x8d\x82\x90\xab\x94\PC (7), SSD (8), \x83I\x83t\x83B\x83X\x97p\x95i (9), \x89ʕ\xa8 (10)

-- \x83L\x81[\x83\x8f\x81[\x83h\x83}\x83b\x83s\x83\x93\x83O\x8ag\x92\xa3
TRUNCATE TABLE planner_keyword_categories;
-- \x83V\x81[\x83P\x83\x93\x83X\x82̃\x8a\x83Z\x83b\x83g\x82͊\xab\x82Ɉˑ\xb6\x82\xb7\x82邽\x82߁A\x8d폜\x82\xb5\x82čč쐬\x82\xaa\x88\xc0\x91S
DROP SEQUENCE seq_planner_keyword_categories;
CREATE SEQUENCE seq_planner_keyword_categories NOCACHE;

-- \x83Q\x81[\x83\x80\x8cn -> PC, \x83\x82\x83j\x83^\x81[, \x83L\x81[\x83{\x81[\x83h, \x83}\x83E\x83X
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'game', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'game', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'game', '\x83L\x81[\x83{\x81[\x83h');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'game', '\x83}\x83E\x83X');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'gaming', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'gaming', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'gaming', '\x83L\x81[\x83{\x81[\x83h');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'gaming', '\x83}\x83E\x83X');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83Q\x81[\x83\x80', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83Q\x81[\x83\x80', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83Q\x81[\x83\x80', '\x83L\x81[\x83{\x81[\x83h');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83Q\x81[\x83\x80', '\x83}\x83E\x83X');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'FPS', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'FPS', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'FPS', '\x83L\x81[\x83{\x81[\x83h');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'FPS', '\x83}\x83E\x83X');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fps', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fps', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fps', '\x83L\x81[\x83{\x81[\x83h');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fps', '\x83}\x83E\x83X');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'RPG', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'RPG', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'RPG', '\x83L\x81[\x83{\x81[\x83h');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'RPG', '\x83}\x83E\x83X');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'rpg', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'rpg', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'rpg', '\x83L\x81[\x83{\x81[\x83h');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'rpg', '\x83}\x83E\x83X');

-- \x83v\x83\x8d\x83O\x83\x89\x83~\x83\x93\x83O\x8cn -> PC, \x8f\x91\x90\xd0
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'programming', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'programming', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'java', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'java', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'python', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'python', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ai', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ai', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'development', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'development', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'coding', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'coding', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83v\x83\x8d\x83O\x83\x89\x83~\x83\x93\x83O', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83v\x83\x8d\x83O\x83\x89\x83~\x83\x93\x83O', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8aJ\x94\xad', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'Java', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'Java', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'Python', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'Python', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'AI', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'AI', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x90l\x8dH\x92m\x94\', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x90l\x8dH\x92m\x94\', '\x8f\x91\x90\xd0');

-- \x95׋\xad\x8cn\x81E\x8f\x91\x90Ќn -> \x8f\x91\x90\xd0
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'study', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'learning', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'school', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x95׋\xad', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8aw\x8fK', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x91\xe5\x8aw', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83\x8c\x83|\x81[\x83g', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8e\x91\x8ai', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8eQ\x8dl\x8f\x91', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'book', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'books', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'reading', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x96{', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8f\x91\x90\xd0', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x93Ǐ\x91', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8f\xac\x90\xe0', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x96\x9f\x89\xe6', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83}\x83\x93\x83K', '\x8f\x91\x90\xd0');

-- \x8ed\x8e\x96\x8cn -> PC, \x83\x82\x83j\x83^\x81[, \x83I\x83t\x83B\x83X\x97p\x95i
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'work', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'work', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'office', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'office', '\x83I\x83t\x83B\x83X\x97p\x95i');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'business', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'business', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8ed\x8e\x96', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8ed\x8e\x96', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8dݑ\x81[\x83N', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8dݑ\x81[\x83N', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83e\x83\x8c\x83\x8f\x81[\x83N', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83e\x83\x8c\x83\x8f\x81[\x83N', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83I\x83t\x83B\x83X', '\x83I\x83t\x83B\x83X\x97p\x95i');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8e\x96\x96\xb1\x8d\xec\x8b\xc6', '\x83I\x83t\x83B\x83X\x97p\x95i');

-- \x90H\x97\xbf\x95i\x8cn -> \x90H\x97\xbf\x95i
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'food', '\x90H\x97\xbf\x95i');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'meal', '\x90H\x97\xbf\x95i');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'grocery', '\x90H\x97\xbf\x95i');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x90H\x82ו\xa8', '\x90H\x97\xbf\x95i');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x90H\x95i', '\x90H\x97\xbf\x95i');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x90H\x97\xbf\x95i', '\x90H\x97\xbf\x95i');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x82\xb2\x94\xd1', '\x90H\x97\xbf\x95i');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x97\xbf\x97\x9d', '\x90H\x97\xbf\x95i');

-- \x89ʕ\xa8\x8cn -> \x89ʕ\xa8
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fruit', '\x89ʕ\xa8');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fruits', '\x89ʕ\xa8');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x89ʕ\xa8', '\x89ʕ\xa8');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83t\x83\x8b\x81[\x83c', '\x89ʕ\xa8');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x82\xe8\x82\xf1\x82\xb2', '\x89ʕ\xa8');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83\x8a\x83\x93\x83S', '\x89ʕ\xa8');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x82݂\xa9\x82\xf1', '\x89ʕ\xa8');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83o\x83i\x83i', '\x89ʕ\xa8');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x82Ԃǂ\xa4', '\x89ʕ\xa8');

-- \x93\xae\x89\xe6\x95ҏW -> \x8d\x82\x90\xab\x94\PC, \x83\x82\x83j\x83^\x81[, SSD
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x93\xae\x89\xe6\x95ҏW', '\x8d\x82\x90\xab\x94\PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x93\xae\x89\xe6\x95ҏW', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x93\xae\x89\xe6\x95ҏW', 'SSD');

COMMIT;
