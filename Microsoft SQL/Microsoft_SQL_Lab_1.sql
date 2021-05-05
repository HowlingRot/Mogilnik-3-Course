--Михайлов Илья 31гр
--Лабораторная №1
--Создание базы данных

CREATE DATABASE DreamHome
ON PRIMARY (NAME=DreamHome,
FILENAME = 'A:\Microsoft_SQL_DB\Dreamhome.mdf',
Size=3Mb,
Maxsize=15Mb,
FileGrowth=1Mb)
Log On
(NAME=lDreamHome,
FILENAME = 'A:\Microsoft_SQL_DB\Dreamhome.ldf',
Size=3Mb,
Maxsize=15Mb,
FileGrowth=1Mb) 


DROP DATABASE DreamHome


CREATE DATABASE DreamHome
ON PRIMARY (NAME=DreamHome,
FILENAME = 'A:\Microsoft_SQL_DB\Dreamhome.mdf',
Size=3Mb,
Maxsize=15Mb,
FileGrowth=1Mb)
Log On
(NAME=lDreamHome,
FILENAME = 'A:\Microsoft_SQL_DB\Dreamhome.ldf',
Size=3Mb,
Maxsize=15Mb,
FileGrowth=1Mb)


USE DreamHome
EXEC sp_addtype postcode, 'char(6)',NULL
EXEC sp_addtype member_no, 'smallint'
EXEC sp_addtype Phonenumber, 'char(17)',NULL
EXEC sp_addtype shortstring, 'varchar(20)',NULL