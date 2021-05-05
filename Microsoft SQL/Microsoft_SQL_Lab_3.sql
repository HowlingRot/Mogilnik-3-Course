--Михайлов Илья 31гр
--Лабораторная №3
--Заполнение таблиц

USE DreamHome;

--Таблица BRANCH

INSERT BRANCH VALUES (1,210009, 'Витебск','Замковая','4/офис404','8(02122)37-73-56','37-73-58');
INSERT BRANCH VALUES (2,210033, 'Витебск','Суворова','9/11','8(02122)36-01-80','33-25-23');
INSERT BRANCH VALUES (3,211440, 'Новополоцк','Молодёжная','18','8(02144)57-31-29','57-25-30');
INSERT BRANCH VALUES (4,211460, 'Россоны','Ленина','3','8(02159)25-55-20','');

--Таблица OWNER

INSERT OWNER VALUES ('Жерносек','Юрий','Витебск','Терешковой','28/1',7,'62-07-94');
INSERT OWNER VALUES ('Панкратова','Инна','Новополоцк','Парковая','2б',12,'57-12-48'),
('Амбражевич','Сергей','Новополоцк','Двинская','5',18,'52-14-89'),
('Поскрёбышева','Елена','Витебск','П.Бровки','26/1',40,'23-00-72(аб978)'),
('Титов ','Николай','Витебск','Интернационалистов','35',187,'8(029)633-76-68'),
('Скребкова','Алла','Новополоцк','Молодёжная','1',22,'8(029)688-84-46'),
('Николаев','Влад','Витебск','Фрунзе','33',214,'8(029)673-07-30'),
('Цалко','Сергей','Лепель','Ленина','14/2',4,'25-17-90'),
('Цыркунова','Наталья','Россоны','Цветочная','90',15,'26-32-48'),
('Яковлев','Андрей','Витебск','Лазо','65','','21-72-25');

--Таблица BUYER

INSERT BUYER VALUES (1,'Невердасов','Виктор','Витебск','Московский пр-т','16/4',117,'62-08-19','36-40-80',2,110000,2);
INSERT BUYER VALUES (2,'Кассап','Светлана','Новополоцк','Гайдара','17а',4,'57-12-48','',1,78000,3);
INSERT BUYER VALUES (3,'Орлов','Александр','Минск','Либнехта','93',15,'8(017)286-13-21','',3,14500,1);
INSERT BUYER VALUES (4,'Сафронова','Светлана','Витебск','пр-т Победы','3/1',324,'8(029)661-07-30','22-67-94',2,60000,4);
INSERT BUYER VALUES (5,'Окорков','Вадим','Минск','Лермонтова','35',187,'','8(017)224-84-24',5,300000,1);
INSERT BUYER VALUES (6,'Семёнов','Вячеслав','Витебск','Замковая','4',13,'23-00-72(аб964)','',2,10500,1);
INSERT BUYER VALUES (7,'Краснова','Жанна','Витебск','Клиническая','104','','','23-50-70',1,90000,2);
INSERT BUYER VALUES (8,'Будда','Елена','Лепель','Ленина','3',5,'25-17-90','',4,200000,3);
INSERT BUYER VALUES (9,'Боровая','Наталья','Орша','Смоленская','12/4',26,'26-32-48','',2,140000,2);
INSERT BUYER VALUES (10,'Алипов','Игорь','Витебск','Московский пр-т','22',4,'21-72-25','',3,150000,2);

--Таблица STAFF

INSERT STAFF VALUES ('BMO550260','Батуркин','Александр','17.10.68','М','Новополоцк','Парковая','5',13,'23-79-77','1.01.2001','менеджер',2500000,3);
INSERT STAFF VALUES ('BMO550261','Чубаро','Наталья','25.05.72','Ж','Витебск','Чкалова','21/1',12,'8(029)662-47-32','10.02.2002','торговый агент',1800000,1);
INSERT STAFF VALUES ('BMO550262','Коваленко','Светлана','1.02.70','Ж','Витебск','Чкалова','24',49,'62-51-23','15.01.2001','менеджер',2500000,3);
INSERT STAFF VALUES ('BMO550263','Логинов','Вадим','9.09.67','М','Витебск','Чкалова','41/2',96,'23-06-73','2.09.1999','директор',3000000,1);
INSERT STAFF VALUES ('BMO550264','Суворов','Виталий','11.07.65','М','Новополоцк','Школьная','47/1',157,'22-29-03','1.02.1999','торговый агент',1800000,3);
INSERT STAFF VALUES ('BMO550265','Жарков','Герман','6.03.68','М','Витебск','Гагарина','31',28,'63-43-98','2.10.2001','менеджер',2800000,2);
INSERT STAFF VALUES ('BMO550266','Ганущенко','Галина','5.11.69','Ж','Витебск','Лазо','90/1',54,'62-43-64','3.11.2004','курьер',1800000,2);
INSERT STAFF VALUES ('BMO550267','Сотникова','Галина','7.12.67','Ж','Полоцк','Вокзальная','7','','','2.02.2002','маклер',1000000,3);
INSERT STAFF VALUES ('BMO550268','Янчиленко','Сергей','28.02.70','М','Россоны','Ленина','28/2',25,'','17.05.2005','торговый агент',1500000,4);
--Таблица PROPERTY

INSERT PROPERTY VALUES (3000,'16.10.16','210033','Витебск','Смоленская','11',57,'5П',3,1,'31/18/10','Б','T',60000,1,'BMO550262',1);
INSERT PROPERTY VALUES (3001,'17.10.15','210035','Витебск','Россоны','11',49,'9К',9,1,'37/21/7','Бз','',70000,2,'BMO550262',5);
INSERT PROPERTY VALUES (3002,'18.10.16','210029','Витебск','Строителей','23/2',214,'12П',2,2,'81/29/9','Лз','T',92000,2,'BMO550266',7);
INSERT PROPERTY VALUES (3003,'19.09.16','210005','Витебск','Лазо','11',4,'3К',3,2,'81/29/9','2Бз','',15000,1,'BMO550261',5);
INSERT PROPERTY VALUES (3004,'15.08.16','211460','Россоны','Ленина','32',20,'5П',5,3,'68,4/44,3/9,81','2Бз','T',100000,4,'BMO550268',7);
INSERT PROPERTY VALUES (3005,'11.09.16','211440','Новопол','Школьная','11',56,'9П',3,1,'36/18/8,2','Б','T',75000,3,'BMO550260',6);
INSERT PROPERTY VALUES (3006,'14.11.16','211440','Новопол','Молодёжная','5',14,'9П',2,2,'46/27/6,8','Лз','T',60000,3,'BMO550264',3);
INSERT PROPERTY VALUES (3007,'20.10.16','211180','Полоцк','Вокзальная','8',15,'5K',5,3,'65/38/7','Б','T',80000,3,'BMO550267',2);
INSERT PROPERTY VALUES (3008,'16.09.16','211460','Россоны','Советская','17',1,'5K',1,3,'65/38/7','-','T',47500,4,'BMO550268',7);

--Таблица VIEWING

INSERT VIEWING VALUES ('19.10.16','согласен',3002,1);
INSERT VIEWING VALUES ('17.10.16','согласен',3003,1);
INSERT VIEWING VALUES ('18.11.16','не согласен',3002,4);
INSERT VIEWING VALUES ('19.10.16','согласен',3005,2);
INSERT VIEWING VALUES ('25.10.16','требует ремонта',3001,7);

--Таблица CONTRACT

INSERT CONTRACT VALUES (1,'NO_1','1955-12-13','150',3000,1);
INSERT CONTRACT VALUES (2,'NO_2','1965-12-13','160',3001,2);
INSERT CONTRACT VALUES (3,'NO_1','1975-12-13','150',3002,3);
INSERT CONTRACT VALUES (4,'NO_3','1985-12-13','200',3003,4);
INSERT CONTRACT VALUES (5,'NO_4','1995-12-13','30',3004,2);
INSERT CONTRACT VALUES (6,'NO_4','2021-01-13','30',3008,2);