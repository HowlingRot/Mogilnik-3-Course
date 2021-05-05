--Михайлов Илья 31гр

--I.Создаём БД

CREATE DATABASE Faculty
ON PRIMARY (NAME=Faculty,
FILENAME = 'A:\Microsoft_SQL_DB\Faculty.mdf',
Size=3Mb,
Maxsize=15Mb,
FileGrowth=1Mb)
Log On
(NAME=lTaxiStation,
FILENAME = 'A:\Microsoft_SQL_DB\Faculty.ldf',
Size=3Mb,
Maxsize=15Mb,
FileGrowth=1Mb)


USE Faculty
EXEC sp_addtype member_no, 'smallint'
EXEC sp_addtype shortstring, 'varchar(20)',NULL

--II.Создаём таблицы

CREATE TABLE STUDENTS(
Student_id  member_no    NOT NULL PRIMARY KEY,
SName       shortstring  NOT NULL,
SSurname    shortstring  NOT NULL,
SPatronymic shortstring  NOT NULL,
Foto        shortstring   NOT NULL,
Group_id    member_no     NOT NULL,
Admittance  bit           NOT NULL,
Stipend     money         NOT NULL,
CONSTRAINT FK_STUDENTS_GROUP FOREIGN KEY(Group_id) REFERENCES GROUPS ON UPDATE CASCADE,
);

CREATE TABLE GROUPS(
Group_id       member_no    NOT NULL PRIMARY KEY,
GroupName      shortstring  NOT NULL,
Specialty_id   member_no    NOT NULL,
CONSTRAINT FK_GROUP_SPECIALTY FOREIGN KEY(Specialty_id) REFERENCES SPECIALTY ON UPDATE CASCADE,
);

CREATE TABLE SPECIALTY(
Specialty_id   member_no    NOT NULL PRIMARY KEY,
SpecialtyName  shortstring  NOT NULL,
);

CREATE TABLE TIMETABLE(
Group_id       member_no    NOT NULL,
Subjects_id    member_no    NOT NULL,
Data           date         NOT NULL,
Classroom      shortstring  NOT NULL,
Teacher_id     member_no    NOT NULL,
PRIMARY KEY(Group_id,Subjects_id),
CONSTRAINT FK_TIMETABLE_GROUP FOREIGN KEY(Group_id) REFERENCES GROUPS ON UPDATE CASCADE,
);

CREATE TABLE SUBJECTS(
Subjects_id   member_no    NOT NULL PRIMARY KEY,
SubjectName   shortstring  NOT NULL,
Cathedra      shortstring  NOT NULL,
);

CREATE TABLE GRADES(
Student_id      member_no    NOT NULL,
Subjects_id    member_no    NOT NULL,
Grades         int          NOT NULL,
Teacher_id     member_no    NOT NULL,
Data           date         NOT NULL,
TypeOfControl  shortstring  NOT NULL,
PRIMARY KEY(Student_id,Subjects_id),
CONSTRAINT FK_GRADES_SUBJECTS FOREIGN KEY(Subjects_id) REFERENCES SUBJECTS ON UPDATE CASCADE,
CONSTRAINT FK_GRADES_STUDENTS FOREIGN KEY(Student_id) REFERENCES STUDENTS ON UPDATE CASCADE,
CONSTRAINT FK_GRADES_TEACHER FOREIGN KEY(Teacher_id) REFERENCES TEACHER ON UPDATE CASCADE,
); 

CREATE TABLE TEACHER(
Teacher_id    member_no    NOT NULL PRIMARY KEY,
TName         shortstring  NOT NULL,
TSurname      shortstring  NOT NULL,
TPatronymic   shortstring  NOT NULL,
Cathedra      shortstring  NOT NULL,
Position      shortstring  NOT NULL,
);

--III.Заполняем таблицы
--TEACHER
INSERT TEACHER VALUES (1,'Пётр', 'Петров', 'Петрович', 'Геометрия', 'Доцент');
INSERT TEACHER VALUES (2,'Иван', 'Михайлов', 'Петрович', 'Алгебра', 'Ассистент');
INSERT TEACHER VALUES (3,'Никита', 'Степанов', 'Петрович', 'Русский язык', 'Профессор');
INSERT TEACHER VALUES (4,'Семён', 'Ботвинов', 'Петрович', 'Геометрия', 'Доцент');
INSERT TEACHER VALUES (5,'Никита', 'Кузьменьков', 'Владимирович', 'Геометрия', 'Ст.преподаватель');

--STUDENTS
INSERT STUDENTS VALUES(101,'Иван', 'Степанов', 'Семенович', 'C:\photo1', 11, 1, 100);
INSERT STUDENTS VALUES(102,'Илья', 'Семенов', 'Семенович', 'C:\photo2', 13, 0, 140);
INSERT STUDENTS VALUES(103,'Семен', 'Михайлов', 'Семенович', 'C:\photo3', 11, 1, 150);
INSERT STUDENTS VALUES(104,'Виталий', 'Семенов', 'Семенович', 'C:\photo4', 12, 0, 100);
INSERT STUDENTS VALUES(105,'Семен', 'Семенов', 'Семенович', 'C:\photo5', 14, 1, 190);

--SPECIALTY
INSERT INTO SPECIALTY VALUES(100,'ПИ');
INSERT INTO SPECIALTY VALUES(101,'ПОИТ');
INSERT INTO SPECIALTY VALUES(102,'КБ');
INSERT INTO SPECIALTY VALUES(103,'ПМ');

--GROUP
INSERT INTO GROUPS VALUES (11, 'ПОКС',100);
INSERT INTO GROUPS VALUES (12, 'ПриМат',101);
INSERT INTO GROUPS VALUES (13, 'МатИнф',102);
INSERT INTO GROUPS VALUES (14, 'WEB',103);

--SUBJECTS
INSERT INTO SUBJECTS VALUES(1,'Анал.геом.','Геометрия');
INSERT INTO SUBJECTS VALUES(2,'Теория чисел','Алгебра');
INSERT INTO SUBJECTS VALUES(3,'Орфография','Русский язык');
INSERT INTO SUBJECTS VALUES(4,'Матимака','Алгебра');

--GRADES
INSERT INTO GRADES VALUES (101,1,10,1,'2020-12-17','Экзамен');
INSERT INTO GRADES VALUES (102,3,9,1,'2020-12-18','Зачёт');
INSERT INTO GRADES VALUES (103,1,8,1,'2020-12-19','Экзамен');
INSERT INTO GRADES VALUES (101,2,5,1,'2020-12-20','Зачёт');
INSERT INTO GRADES VALUES (101,4,3,2,'2020-12-20','Зачёт');

--TIMETABLE
INSERT TIMETABLE VALUES(11,1,'2020-12-17','117a',3);
INSERT TIMETABLE VALUES(12,2,'2020-12-17','118a',2);
INSERT TIMETABLE VALUES(13,3,'2020-12-17','119a',1);
INSERT TIMETABLE VALUES(14,4,'2020-12-17','118a',4);


--IV.Контрольная работа №1
--20 Вариант

--1.Вывести фамилии студентов, у которых есть однофамильцы преподаватели.
SELECT *
FROM STUDENTS JOIN GROUPS ON STUDENTS.Group_id = GROUPS.Group_id
JOIN TIMETABLE ON TIMETABLE.Group_id = GROUPS.Group_id
JOIN TEACHER ON TEACHER.Teacher_id = TIMETABLE.Teacher_id
WHERE STUDENTS.SSurname = TEACHER.TSurname;

--2.Сколько доцентов, ассистентов, профессоров, старших преподавателей работает на каждой кафедре.
SELECT TEACHER.Cathedra, TEACHER.Position, COUNT(TEACHER.Position)
FROM TEACHER
GROUP BY TEACHER.Cathedra, TEACHER.Position;

--3.Создать локальную временную таблицу,содержащую количество оценок ниже 4 баллов, поставленных преподавателями (кафедра, фамилия преподавателя, количество оценок <4 баллов)
SELECT TEACHER.TSurname, TEACHER.Cathedra, count(GRADES.Grades) AS 'Количество низких оценок'
FROM GRADES JOIN TEACHER ON TEACHER.Teacher_id = GRADES.Teacher_id
WHERE GRADES.Grades < 4
Group by TEACHER.TSurname, TEACHER.Cathedra, GRADES.Grades;

--IV.Контрольная работа №2
--7 Вариант

--Процедура.
CREATE PROCEDURE studentOverSeven(@Group_id member_no) AS
BEGIN
SELECT STUDENTS.Student_id
FROM STUDENTS JOIN GRADES ON STUDENTS.Student_id = GRADES.Student_id JOIN GROUPS ON STUDENTS.Group_id = GROUPS.Group_id
GROUP BY STUDENTS.Student_id,STUDENTS.Group_id
HAVING AVG(Grades)>7 AND STUDENTS.Group_id = 45 
END

--

EXEC addContract 45

--Триггер.
CREATE TRIGGER insertThirdGrade
ON GRADES
AFTER INSERT
AS
BEGIN
IF (SELECT count(GRADES.Grades)
	FROM GRADES 
	WHERE GRADES.Student_id = (SELECT Student_id FROM INSERTED) AND GRADES.Grades = 10) = 3
		UPDATE STUDENTS
		SET Stipend = Stipend*2
		WHERE STUDENTS.Student_id = (SELECT Student_id FROM INSERTED)
END

--Скалярная пользовательская функция
CREATE FUNCTION Avg_Mark (@Group_id int)
RETURNS real
AS
BEGIN
Declare @Avg_Mark int
SET @Avg_Mark = (SELECT avg(Grades) FROM GRADES
WHERE Student_id IN (Select Student_id FROM STUDENTS WHERE Group_id=@Group_id)
RETURN @Avg_Mark
END

--

SELECT DISTINCT Group_id 
FROM STUDENTS 
WHERE dbo.Avg_Mark(Group_no)>7



