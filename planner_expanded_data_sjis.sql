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
