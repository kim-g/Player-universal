unit SQL_Const;

interface

const
  DB_Create_INFO : string = 'CREATE TABLE IF NOT EXISTS `info` (`id`	INTEGER PRIMARY KEY AUTOINCREMENT, `name`	TEXT, `description`	TEXT, `version`	INTEGER DEFAULT 1, `last_d_1`	INTEGER, `last_d_2`	INTEGER)';
  DB_Create_FILES : string = 'CREATE TABLE IF NOT EXISTS `files` (`id`	INTEGER PRIMARY KEY AUTOINCREMENT, `title`	TEXT,	`comment`	TEXT,	`cycle`	INTEGER,	`file`	BLOB)';
  DB_Create_DESK : string = 'CREATE TABLE IF NOT EXISTS `desk` (	`id`	INTEGER PRIMARY KEY AUTOINCREMENT, `desk_n`	INTEGER, `number`	TEXT,	`file`	INTEGER,	`title`	TEXT,	`order`	INTEGER)';

implementation

end.
