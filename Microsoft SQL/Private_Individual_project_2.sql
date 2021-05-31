--Михайлов Илья 31гр
--Индивидуальный проект
--Вариант 11
--Автомастерская

--I.Создаём БД

CREATE DATABASE AutoRepairShop
ON PRIMARY (NAME=AutoRepairShop,
FILENAME = 'D:\Work\DB\AutoRepairShop.mdf',
Size=3Mb,
Maxsize=15Mb,
FileGrowth=1Mb)
Log On
(NAME=lAutoRepairShop,
FILENAME = 'D:\Work\DB\AutoRepairShop.ldf',
Size=3Mb,
Maxsize=15Mb,
FileGrowth=1Mb)

USE AutoRepairShop
EXEC sp_addtype postcode, 'char(6)',NULL
EXEC sp_addtype member_no, 'smallint'
EXEC sp_addtype Phonenumber, 'char(17)',NULL
EXEC sp_addtype shortstring, 'varchar(20)',NULL

--II.Создаём таблицы

--Мастер
CREATE TABLE Master(
Master_no member_no    NOT NULL PRIMARY KEY,
F_Name    shortstring  NOT NULL,
L_Name    shortstring  NOT NULL,
Category  smallint	   NOT NULL,
Adress	  shortstring  NOT NULL,
);

--Владелец
CREATE TABLE Owner(
Owner_no  	member_no    NOT NULL PRIMARY KEY,
F_Name    	shortstring  NOT NULL,
L_Name    	shortstring  NOT NULL,
Phone_no  	Phonenumber  NOT NULL,
);

--Автомобиль
CREATE TABLE Auto(
Auto_no  			member_no   NOT NULL PRIMARY KEY,
Goverment_number    shortstring NOT NULL,
Mark    			shortstring NOT NULL,
Power				smallint	NOT NULL,
Year_of_release  	date  		NOT NULL,
Color		  		shortstring NOT NULL,
Owner_no  			member_no   NOT NULL,
CONSTRAINT FK_Auto_Owner FOREIGN KEY(Owner_no) REFERENCES Owner,
);

--Деталь
CREATE TABLE Element(
Element_no  	member_no   NOT NULL PRIMARY KEY,
Name 		   	shortstring NOT NULL,
Cost    		money 		NOT NULL,
Mark    		shortstring NOT NULL,
);

--Ремонт
CREATE TABLE Repair(
Repair_no            member_no    NOT NULL PRIMARY KEY,
Date_start           date         NOT NULL,
Date_plan_end        date         NOT NULL,
Date_real_end        date         NOT NULL,
Type_repair     	 shortstring  NOT NULL,
Cost_repair     	 money 		  NOT NULL,
Master_no 			 member_no    NOT NULL,
Element_no 		   	 member_no    NOT NULL,
Auto_no 			 member_no   	NOT NULL,
CONSTRAINT FK_Repair_Master FOREIGN KEY(Master_no) REFERENCES Master,
CONSTRAINT FK_Repair_Auto FOREIGN KEY(Auto_no) REFERENCES Auto,
CONSTRAINT FK_Repair_Element FOREIGN KEY(Element_no) REFERENCES Element,
);

--III.Заполняем таблицы

--Таблица Master
INSERT Master VALUES(1,'Ефим','Ботвинов',1,'Московский пр-т'); 
INSERT Master VALUES(2,'Ян','Степанов',2,'пр-т Победы');
INSERT Master VALUES(3,'Виталий','Бобоед',1,'Клиническая');

--Таблица Owner
INSERT Owner VALUES(1,'Илья','Михайлов','57-12-48'); 
INSERT Owner VALUES(2,'Анастасия','Паус','62-08-19');
INSERT Owner VALUES(3,'Юлия','Бразгун','26-32-48');

--Таблица Auto
INSERT Auto VALUES(1,'6445 A-1','Toyota',330,'12.07.2019','Красный',1); 
INSERT Auto VALUES(2,'6445 A-2','Audi',300,'10.8.2019','Чёрный',1);
INSERT Auto VALUES(3,'6445 A-3','Toyota',400,'11.11.2019','Металик',2);
INSERT Auto VALUES(4,'6445 A-4','Жигули',200,'11.03.2021','Чёрный',3);

--Таблица Element
INSERT Element VALUES(1,'Двигатель',600,'Audi');
INSERT Element VALUES(2,'Шасси',200,'Toyota');
INSERT Element VALUES(3,'Маховик',300,'Жигули');

--Таблица Repair
INSERT Repair VALUES(1,'12.07.2019','09.01.2020','11.01.2020','Полный',300,1,1,1); 
INSERT Repair VALUES(2,'04.04.2019','09.05.2019','09.05.2019','Частичный',400,1,2,3); 
INSERT Repair VALUES(3,'07.06.2019','09.07.2019','06.07.2019','Полный',250,2,3,2); 
INSERT Repair VALUES(4,'07.06.2019','09.07.2019','06.07.2019','Частичный',250,2,3,4); 
 
--IV.Запросы 
--Выбрать фамилию того механика, который чаще всех работает с автомобилями марки ”Тойота”.
SELECT TOP 1 Master.Master_no, count(Auto.Mark)
FROM Master JOIN Repair ON Master.Master_no = Repair.Master_no JOIN Auto ON Auto.Auto_no = Repair.Auto_no
WHERE Auto.Mark = 'Toyota'
GROUP BY Master.Master_no
ORDER BY count(Auto.Mark) DESC

--Определить тех владельцев автомобилей, которых всегда обслуживает один и тот же механик.
SELECT Owner.L_Name
FROM Master JOIN Repair ON Master.Master_no = Repair.Master_no JOIN Auto ON Auto.Auto_no = Repair.Auto_no JOIN Owner ON Owner.Owner_no = Auto.Owner_no
GROUP BY Owner.L_Name
HAVING count(Master.L_Name) = 1

--Вывести фамилии механиков, которые не выполняли работы в срок и количество дней просрочки выполнения заказа.
SELECT Master.L_Name, DATEDIFF(day, Repair.Date_plan_end, Repair.Date_real_end)
FROM Master JOIN Repair ON Master.Master_no = Repair.Master_no
WHERE Repair.Date_plan_end < Repair.Date_real_end 

--Вывести данные владельца самого старого автомобиля.
SELECT TOP 1 Owner.Owner_no
FROM Auto JOIN Owner ON Owner.Owner_no = Auto.Owner_no
ORDER BY Auto.Year_of_release DESC

--Сколько автомобилей отремонтировал каждый механик.
SELECT Master.L_Name, count(Repair.Repair_no)
FROM Master JOIN Repair ON Master.Master_no = Repair.Master_no
GROUP BY Master.L_Name

--Вывести данные механика, который выполнял все виды ремонта за прошедшую неделю.
SELECT Master.Master_no
FROM Master JOIN Repair ON Master.Master_no = Repair.Master_no
WHERE DATEDIFF(DAY, Repair.Date_real_end, GETDATE()) < 7
GROUP BY Master.Master_no
HAVING count(Repair.Type_repair) = 2

--Сколько заработал каждый механик за прошедший месяц?
SELECT Master.Master_no, SUM(Repair.Cost_repair/2)
FROM Master JOIN Repair ON Master.Master_no = Repair.Master_no
WHERE DATEDIFF(MONTH, Repair.Date_real_end, GETDATE()) < 1
GROUP BY Master.Master_no

--Вывести данные владельцев автомобилей, которые обращались в ремонт больше одного раза.
SELECT Owner.Owner_no
FROM Repair JOIN Auto ON Auto.Auto_no = Repair.Auto_no JOIN Owner ON Owner.Owner_no = Auto.Owner_no
GROUP BY Owner.Owner_no
HAVING count(Owner.Owner_no) > 1

--За каждый день просрочки выполнения заказа механику назначается штраф в размере 5%. Рассчитать штраф каждого механика за прошедший месяц.
SELECT Master.Master_no, SUM((Repair.Cost_repair*0.05)*DATEDIFF(DAY, Repair.Date_plan_end, Repair.Date_real_end))
FROM Master JOIN Repair ON Master.Master_no = Repair.Master_no
WHERE DATEDIFF(MONTH, Repair.Date_real_end, GETDATE()) < 1
GROUP BY Master.Master_no

--V.Создать представление для заказчиков (фамилию механика и модель автомобиля, которую он ремонтирует чаще всего).
CREATE VIEW forCustomers
AS
SELECT z.Master_no, Auto.Mark
FROM Master as z JOIN Repair ON z.Master_no = Repair.Master_no JOIN Auto ON Auto.Auto_no = Repair.Auto_no
GROUP BY z.Master_no, Auto.Mark
HAVING count(Auto.Mark) >= ALL(SELECT count(Auto.Mark)
FROM Master as x JOIN Repair ON x.Master_no = Repair.Master_no JOIN Auto ON Auto.Auto_no = Repair.Auto_no
WHERE z.Master_no = x.Master_no
GROUP BY x.Master_no, Auto.Mark)

--VI.Создать хранимые процедуры:
--Повышения цены деталей для автомобиля “Ford” на 10 %.
CREATE PROCEDURE upCostElement
AS
BEGIN
UPDATE Element
	SET Cost = Cost + Cost*(0.1) 
	FROM Element
	WHERE Element.Mark = 'Ford'
END

--Создайте процедуру для повышения разряда тех мастеров, которые отремонтировали больше 3 автомобилей.
CREATE PROCEDURE upCategoryMaster
AS
BEGIN
UPDATE Master
	SET Category = Category + 1 
	FROM Master JOIN Repair ON Master.Master_no = Repair.Master_no
	GROUP BY Master.Master_no
	HAVING count(Repair.Repair_no) > 3
END

--VII.Создать триггер для занесения стоимости каждого выполненного заказа во временную таблицу «выручка мастера за текущий день».
CREATE TABLE #MasterSalary
(
	Salary_no 	smallint 	NOT NULL PRIMARY KEY,
	Master_no 	smallint	NOT NULL,
	Salary 		money 		NOT NULL,
)

CREATE TRIGGER catchMoney
ON Repair
AFTER INSERT
AS
INSERT INTO #MasterSalary 
VALUES ((SELECT INSERTED.Master_no FROM INSERTED), (SELECT INSERTED.Cost_repair FROM INSERTED))