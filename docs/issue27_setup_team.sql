-- Issue #27 \x83X\x83}\x81[\x83g\x8dw\x93\xfc\x83v\x83\x89\x83\x93\x83i\x81[ \x83`\x81[\x83\x80\x94z\x95z\x97p\x83Z\x83b\x83g\x83A\x83b\x83vSQL
-- \x8e\xc0\x8ds\x91O\x82\xc9: \x8a\xf9\x91\xb6\x82\xcc categories, items \x82Ɉˑ\xb6\x82\xaa\x82\xa0\x82邽\x82߁A\x95W\x8f\x80\x82̏\x89\x8a\xfa\x83f\x81[\x83^\x93\x8a\x93\xfc\x8c\xe3\x82Ɏ\xc0\x8ds\x82\xb5\x82Ă\xad\x82\xbe\x82\xb3\x82\xa2\x81B

-----------------------------------------------------------------------
-- 1. \x83v\x83\x89\x83\x93\x83i\x81[\x83}\x83b\x83s\x83\x93\x83O\x83e\x81[\x83u\x83\x8b\x82̍쐬
-----------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE planner_keyword_categories';
EXCEPTION
  WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE planner_keyword_categories (
  id NUMBER(6) PRIMARY KEY,
  keyword VARCHAR2(100 CHAR) NOT NULL,
  category_name VARCHAR2(100 CHAR) NOT NULL
);

BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_planner_keyword_categories';
EXCEPTION
  WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/

CREATE SEQUENCE seq_planner_keyword_categories NOCACHE;

-----------------------------------------------------------------------
-- 2. \x83J\x83e\x83S\x83\x8a\x82̒ǉ\xc1 (\x8a\xf9\x91\xb6\x82̐H\x97\xbf\x95i(1), \x8f\x91\x90\xd0(2) \x88ȊO)
-----------------------------------------------------------------------
INSERT INTO categories VALUES(seq_categories.NEXTVAL, 'PC', '\x83f\x83X\x83N\x83g\x83b\x83vPC\x81A\x83m\x81[\x83gPC\x82Ȃ\xc7', 0, SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '\x83\x82\x83j\x83^\x81[', '\x89t\x8f\xbb\x83f\x83B\x83X\x83v\x83\x8c\x83C\x81A\x83Q\x81[\x83~\x83\x93\x83O\x83\x82\x83j\x83^\x81[\x82Ȃ\xc7', 0, SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '\x83L\x81[\x83{\x81[\x83h', '\x83\x81\x83J\x83j\x83J\x83\x8b\x81A\x83\x81\x83\x93\x83u\x83\x8c\x83\x93\x81A\x90Ód\x97e\x97ʖ\xb3\x90ړ_\x95\xfb\x8e\xae\x82Ȃ\xc7', 0, SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '\x83}\x83E\x83X', '\x83\x8f\x83C\x83\x84\x83\x8c\x83X\x81A\x83Q\x81[\x83~\x83\x93\x83O\x83}\x83E\x83X\x82Ȃ\xc7', 0, SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '\x8d\x82\x90\xab\x94\PC', '\x93\xae\x89\xe6\x95ҏW\x82\xe23D\x83Q\x81[\x83\x80\x8c\xfc\x82\xaf\x82̃n\x83C\x83X\x83y\x83b\x83NPC', 0, SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, 'SSD', '\x8d\x82\x91\xac\x83X\x83g\x83\x8c\x81[\x83W\x91\x95\x92u', 0, SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '\x83I\x83t\x83B\x83X\x97p\x95i', '\x83f\x83X\x83N\x81A\x83`\x83F\x83A\x81A\x95\xb6\x96[\x8b\xef\x82Ȃ\xc7', 0, SYSDATE);
INSERT INTO categories VALUES(seq_categories.NEXTVAL, '\x89ʕ\xa8', '\x8f{\x82̃t\x83\x8b\x81[\x83c', 0, SYSDATE);

-----------------------------------------------------------------------
-- 3. \x83e\x83X\x83g\x8f\xa4\x95i\x82̒ǉ\xc1 (\x8ae\x83J\x83e\x83S\x83\x8a \x88\xc0\x89\xbf\x81E\x92\x86\x89\xbf\x8ai\x81E\x8d\x82\x89\xbf\x8ai\x82\xcc3\x93_)
-----------------------------------------------------------------------

-- PC (Category ID: 3\x91z\x92\xe8)
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83X\x83^\x83\x93\x83_\x81[\x83h\x83m\x81[\x83gPC', 50000, '\x95\x81\x92i\x8eg\x82\xa2\x82ɍœK\x82\xc8PC', 10, NULL, (SELECT id FROM categories WHERE name='PC'), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83r\x83W\x83l\x83X\x83m\x81[\x83gPC', 80000, '\x8ed\x8e\x96\x82ɍœK\x82\xc8PC', 10, NULL, (SELECT id FROM categories WHERE name='PC'), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83v\x83\x8c\x83~\x83A\x83\x80\x83m\x81[\x83gPC', 120000, '\x8d\x82\x90\xab\x94\\x82\xc8PC', 10, NULL, (SELECT id FROM categories WHERE name='PC'), 0, SYSDATE);

-- \x83\x82\x83j\x83^\x81[
INSERT INTO items VALUES(seq_items.NEXTVAL, '21\x83C\x83\x93\x83`\x83\x82\x83j\x83^\x81[', 15000, '\x83R\x83\x93\x83p\x83N\x83g\x82ȃ\x82\x83j\x83^\x81[', 10, NULL, (SELECT id FROM categories WHERE name='\x83\x82\x83j\x83^\x81['), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '24\x83C\x83\x93\x83`\x83t\x83\x8bHD\x83\x82\x83j\x83^\x81[', 25000, '\x95W\x8f\x80\x93I\x82ȃ\x82\x83j\x83^\x81[', 10, NULL, (SELECT id FROM categories WHERE name='\x83\x82\x83j\x83^\x81['), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '27\x83C\x83\x93\x83`4K\x83\x82\x83j\x83^\x81[', 45000, '\x8d\x82\x90\xb8\x8dׂȃ\x82\x83j\x83^\x81[', 10, NULL, (SELECT id FROM categories WHERE name='\x83\x82\x83j\x83^\x81['), 0, SYSDATE);

-- \x83L\x81[\x83{\x81[\x83h
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83\x81\x83\x93\x83u\x83\x8c\x83\x93\x83L\x81[\x83{\x81[\x83h', 2000, '\x90Â\xa9\x82ȃL\x81[\x83{\x81[\x83h', 10, NULL, (SELECT id FROM categories WHERE name='\x83L\x81[\x83{\x81[\x83h'), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83\x81\x83J\x83j\x83J\x83\x8b\x83L\x81[\x83{\x81[\x83h', 8000, '\x90S\x92n\x82悢\x91Ō\xae\x8a\xb4', 10, NULL, (SELECT id FROM categories WHERE name='\x83L\x81[\x83{\x81[\x83h'), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x8d\x82\x8b\x89\x90Ód\x97e\x97ʖ\xb3\x90ړ_\x83L\x81[\x83{\x81[\x83h', 25000, '\x8dō\x82\x82̃^\x83C\x83s\x83\x93\x83O\x91̌\xb1', 10, NULL, (SELECT id FROM categories WHERE name='\x83L\x81[\x83{\x81[\x83h'), 0, SYSDATE);

-- \x83}\x83E\x83X
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x97L\x90\xfc\x8c\xf5\x8aw\x8e\xae\x83}\x83E\x83X', 1000, '\x83V\x83\x93\x83v\x83\x8b\x82ȃ}\x83E\x83X', 10, NULL, (SELECT id FROM categories WHERE name='\x83}\x83E\x83X'), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83\x8f\x83C\x83\x84\x83\x8c\x83X\x83}\x83E\x83X', 3000, '\x95֗\x98\x82ȃ}\x83E\x83X', 10, NULL, (SELECT id FROM categories WHERE name='\x83}\x83E\x83X'), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x91\xbd\x83{\x83^\x83\x93\x83Q\x81[\x83~\x83\x93\x83O\x83}\x83E\x83X', 10000, '\x91\xbd\x8b@\x94\\x82ȃ}\x83E\x83X', 10, NULL, (SELECT id FROM categories WHERE name='\x83}\x83E\x83X'), 0, SYSDATE);

-- \x8d\x82\x90\xab\x94\PC
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83G\x83\x93\x83g\x83\x8a\x81[\x83Q\x81[\x83~\x83\x93\x83OPC', 150000, '\x83Q\x81[\x83\x80\x93\xfc\x96\xe5\x82\xc9', 5, NULL, (SELECT id FROM categories WHERE name='\x8d\x82\x90\xab\x94\PC'), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83~\x83h\x83\x8b\x83\x8c\x83\x93\x83W\x83Q\x81[\x83~\x83\x93\x83OPC', 250000, '\x82قƂ\xf1\x82ǂ̃Q\x81[\x83\x80\x82\xaa\x89\xf5\x93K', 5, NULL, (SELECT id FROM categories WHERE name='\x8d\x82\x90\xab\x94\PC'), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83n\x83C\x83G\x83\x93\x83h\x83\x8f\x81[\x83N\x83X\x83e\x81[\x83V\x83\x87\x83\x93', 450000, '\x83v\x83\x8d\x82̓\xae\x89\xe6\x95ҏW\x82\xc9', 5, NULL, (SELECT id FROM categories WHERE name='\x8d\x82\x90\xab\x94\PC'), 0, SYSDATE);

-- SSD
INSERT INTO items VALUES(seq_items.NEXTVAL, '500GB SSD', 7000, '\x8e\xe8\x8cy\x82ɑ\x9d\x90\xdd', 20, NULL, (SELECT id FROM categories WHERE name='SSD'), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '1TB NVMe SSD', 15000, '\x8d\x82\x91\xac\x82ȃf\x81[\x83^\x93]\x91\x97', 20, NULL, (SELECT id FROM categories WHERE name='SSD'), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '2TB \x8d\x82\x91ϋvSSD', 30000, '\x91\xe5\x97e\x97ʂň\xc0\x90S', 20, NULL, (SELECT id FROM categories WHERE name='SSD'), 0, SYSDATE);

-- \x83I\x83t\x83B\x83X\x97p\x95i
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83V\x83\x93\x83v\x83\x8b\x83f\x83X\x83N', 10000, '\x8eg\x82\xa2\x82₷\x82\xa2\x83f\x83X\x83N', 10, NULL, (SELECT id FROM categories WHERE name='\x83I\x83t\x83B\x83X\x97p\x95i'), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83G\x83\x8b\x83S\x83m\x83~\x83N\x83X\x83`\x83F\x83A', 30000, '\x94\xe6\x82\xea\x82ɂ\xad\x82\xa2\x88֎q', 10, NULL, (SELECT id FROM categories WHERE name='\x83I\x83t\x83B\x83X\x97p\x95i'), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x8f\xb8\x8d~\x83f\x83X\x83N', 60000, '\x97\xa7\x82\xc1\x82Ă\xe0\x8d\xc0\x82\xc1\x82Ă\xe0\x8eg\x82\xa6\x82\xe9', 10, NULL, (SELECT id FROM categories WHERE name='\x83I\x83t\x83B\x83X\x97p\x95i'), 0, SYSDATE);

-- \x89ʕ\xa8 (\x8a\xf9\x91\xb6\x83J\x83e\x83S\x83\x8a1\x82\xaa\x90H\x97\xbf\x95i\x82̂\xbd\x82߁A\x96\xbe\x8e\xa6\x93I\x82ɒǉ\xc1\x82\xb5\x82\xbd\x82\xe0\x82̂\xf0\x8ew\x92\xe8)
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83T\x83\x93\x82ӂ\xb6(\x82\xe8\x82\xf1\x82\xb2)', 200, '\x8aÂ݂\xaa\x8b\xad\x82\xa2', 30, NULL, (SELECT id FROM categories WHERE name='\x89ʕ\xa8'), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x8d\x82\x8b\x89\x8a\xae\x8fn\x83\x81\x83\x8d\x83\x93', 3000, '\x96F\x8f\x86\x82ȍ\x81\x82\xe8', 5, NULL, (SELECT id FROM categories WHERE name='\x89ʕ\xa8'), 0, SYSDATE);
INSERT INTO items VALUES(seq_items.NEXTVAL, '\x83V\x83\x83\x83C\x83\x93\x83}\x83X\x83J\x83b\x83g', 5000, '\x8e\xed\x82Ȃ\xb5\x82ŐH\x82ׂ₷\x82\xa2', 5, NULL, (SELECT id FROM categories WHERE name='\x89ʕ\xa8'), 0, SYSDATE);

-----------------------------------------------------------------------
-- 4. \x83L\x81[\x83\x8f\x81[\x83h\x83}\x83b\x83s\x83\x93\x83O\x82̒ǉ\xc1 (35\x83L\x81[\x83\x8f\x81[\x83h)
-----------------------------------------------------------------------

-- \x83Q\x81[\x83\x80\x8cn
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'game', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'game', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'game', '\x83L\x81[\x83{\x81[\x83h');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'game', '\x83}\x83E\x83X');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'gaming', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'gaming', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83Q\x81[\x83\x80', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83Q\x81[\x83\x80', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'FPS', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'FPS', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fps', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'RPG', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'rpg', 'PC');

-- \x83v\x83\x8d\x83O\x83\x89\x83~\x83\x93\x83O\x8cn
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'programming', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'programming', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'java', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'java', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'python', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'ai', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83v\x83\x8d\x83O\x83\x89\x83~\x83\x93\x83O', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83v\x83\x8d\x83O\x83\x89\x83~\x83\x93\x83O', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8aJ\x94\xad', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x90l\x8dH\x92m\x94\', 'PC');

-- \x95׋\xad\x81E\x8f\x91\x90Ќn
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'study', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'learning', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x95׋\xad', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8aw\x8fK', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x96{', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8f\x91\x90\xd0', '\x8f\x91\x90\xd0');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x93Ǐ\x91', '\x8f\x91\x90\xd0');

-- \x8ed\x8e\x96\x8cn
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'work', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'office', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'business', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8ed\x8e\x96', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8dݑ\x81[\x83N', 'PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x8dݑ\x81[\x83N', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83e\x83\x8c\x83\x8f\x81[\x83N', 'PC');

-- \x90H\x97\xbf\x95i\x8cn
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'food', '\x90H\x97\xbf\x95i');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x90H\x97\xbf\x95i', '\x90H\x97\xbf\x95i');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x90H\x82ו\xa8', '\x90H\x97\xbf\x95i');

-- \x89ʕ\xa8\x8cn
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fruit', '\x89ʕ\xa8');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, 'fruits', '\x89ʕ\xa8');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x89ʕ\xa8', '\x89ʕ\xa8');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x83t\x83\x8b\x81[\x83c', '\x89ʕ\xa8');

-- \x93\xae\x89\xe6\x95ҏW\x8cn
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x93\xae\x89\xe6\x95ҏW', '\x8d\x82\x90\xab\x94\PC');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x93\xae\x89\xe6\x95ҏW', '\x83\x82\x83j\x83^\x81[');
INSERT INTO planner_keyword_categories VALUES(seq_planner_keyword_categories.NEXTVAL, '\x93\xae\x89\xe6\x95ҏW', 'SSD');

COMMIT;
