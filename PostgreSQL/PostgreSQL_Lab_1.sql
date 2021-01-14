--Михайлов Илья 31гр
--Лабораторная №1
--Проектирование базы данных.

--I.Создаём таблицы



CREATE TABLE roles(
id bigint PRIMARY KEY NOT NULL,
position varchar(20) NOT NULL
);



CREATE TABLE users(
id bigint PRIMARY KEY NOT NULL,
login varchar(255) NOT NULL,
password varchar(255) NOT NULL,
email varchar(255) NULL,
role_id bigint REFERENCES roles(id) NOT NULL
);



CREATE TABLE profiles(
user_id bigint REFERENCES users(id) NOT NULL,
name varchar(30) NOT NULL,
foto varchar(255) NOT NULL,
sex varchar(1) NOT NULL,
birth_day date NOT NULL,
dossier text NULL,
hobby varchar(30)[] NULL,
profession varchar(30) NOT NULL,
PRIMARY KEY(user_id)
);



CREATE TABLE advertisements(
id bigint PRIMARY KEY NOT NULL,
preview varchar(255) NOT NULL,
atext text NOT NULL,
creator_id bigint REFERENCES users(id) NOT NULL,
tags varchar(30)[] NULL
);



CREATE TABLE messages(
id bigint PRIMARY KEY NOT NULL,
mtext text NOT NULL,
sender_id bigint REFERENCES users(id) NOT NULL,
receiver_id bigint REFERENCES users(id) NOT NULL,
create_at timestamp DEFAULT NOW()
);



--II.Заполняем таблицы

--roles
INSERT INTO roles VALUES (1, 'user');
INSERT INTO roles VALUES (2, 'meneger');
INSERT INTO roles VALUES (3, 'admin');

--users
INSERT INTO users VALUES (1,'USER1', '0001',NULL, 1);
INSERT INTO users VALUES (2,'USER2', '0002',NULL, 1);
INSERT INTO users VALUES (3,'USER3', '0003',NULL, 1);
INSERT INTO users VALUES (4,'MENEGER1', '0004',NULL, 2);
INSERT INTO users VALUES (5,'ADMIN1', '0005',NULL, 3);

--profiles
INSERT INTO profiles  VALUES (1,'Иван','Foto1','M','17.08.2001','dossier_1','{anime,dogs}','designer');
INSERT INTO profiles  VALUES (2,'Ян','Foto2','M','11.02.2000','dossier_2','{beer,dogs}','programmer');
INSERT INTO profiles  VALUES (3,'Наташа','Foto3','Ж','07.03.2005','dossier_3','{walk,sleep}','screenwriter');
INSERT INTO profiles  VALUES (4,'Кристина','Foto4','Ж','05.12.2001','dossier_4','{anime,walk}','designer');
INSERT INTO profiles  VALUES (5,'Дима','Foto5','M','25.04.2000','dossier_5','{anime,beer}','editor');

--advertisements
INSERT INTO advertisements VALUES (1,'Foto1','text1',1,'{tag1}');
INSERT INTO advertisements VALUES (2,'Foto2','text2',2,'{tag2}');
INSERT INTO advertisements VALUES (3,'Foto3','text3',3,'{tag3}');
INSERT INTO advertisements VALUES (4,'Foto4','text4',4,'{tag4}');
INSERT INTO advertisements VALUES (5,'Foto5','text5',5,'{tag5}');

--messages
INSERT INTO messages  VALUES (1,'Привет',1,2);
INSERT INTO messages  VALUES (2,'Пока',2,3);
INSERT INTO messages  VALUES (3,'Как дела?',1,5);
INSERT INTO messages  VALUES (4,'Hello',3,1);
INSERT INTO messages  VALUES (5,'Мде',4,2);