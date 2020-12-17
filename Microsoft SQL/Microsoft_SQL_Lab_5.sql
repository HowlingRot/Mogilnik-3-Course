--Михайлов Илья 31гр
--Лабораторная №5
--Индивидуальный проект
--Вариант 14
--Таксопарк

--I.Создаём БД
CREATE DATABASE TaxiStation
ON PRIMARY (NAME=TaxiStation,
FILENAME = 'A:\Microsoft_SQL_DB\TaxiStation.mdf',
Size=3Mb,
Maxsize=15Mb,
FileGrowth=1Mb)
Log On
(NAME=lTaxiStation,
FILENAME = 'A:\Microsoft_SQL_DB\TaxiStation.ldf',
Size=3Mb,
Maxsize=15Mb,
FileGrowth=1Mb)

USE TaxiStation
EXEC sp_addtype postcode, 'char(6)',NULL
EXEC sp_addtype member_no, 'smallint'
EXEC sp_addtype Phonenumber, 'char(17)',NULL
EXEC sp_addtype shortstring, 'varchar(20)',NULL

--II.Создаём таблицы

--Водители
CREATE TABLE DRIVER(
Driver_no member_no    NOT NULL PRIMARY KEY,
L_Name    shortstring  NOT NULL,
F_Name    shortstring  NOT NULL,
City      shortstring  NOT NULL,
Street    shortstring  NOT NULL,
House     nchar(6)     NOT NULL,
Flat      smallint         NULL,
Phone_no  Phonenumber  NOT NULL,
Passport  shortstring  NOT NULL,
Position  shortstring  NOT NULL,
Сategory  shortstring  NOT NULL,
Score     money        NOT NULL,
);

--Машины
CREATE TABLE CAR(
Mark                  shortstring NOT NULL,    
Specifications        shortstring NOT NULL,
Cost                  money       NOT NULL,
Car_no                member_no   NOT NULL PRIMARY KEY,
Mark_no				  member_no   NOT NULL,
Year_of_issue         int         NOT NULL,
Mileage				  int         NOT NULL,
Last_maintenance_date date        NOT NULL,
Driver_no             member_no   NOT NULL,
CONSTRAINT FK_CAR_DRIVER FOREIGN KEY(Driver_no) REFERENCES DRIVER ON UPDATE CASCADE,
);

--Вызовы
CREATE TABLE CALL(
Tariff_no              member_no    NOT NULL PRIMARY KEY,
Tariff_name            shortstring  NOT NULL,
Price_km               money        NOT NULL,
Call_date              date         NOT NULL,
Landing_time           time     	NOT NULL,
LCity     			   shortstring  NOT NULL,
LStreet    			   shortstring  NOT NULL,
LHouse    			   shortstring  NOT NULL,
Disembarkation_time    time         NULL,
DCity     			   shortstring  NOT NULL,
DStreet    			   shortstring  NOT NULL,
DHouse    			   shortstring  NOT NULL,
Passenger_no           member_no    NOT NULL,
distance               int          NOT NULL,
Driver_no              member_no    NOT NULL,
Phone_Passenge     	   Phonenumber  NOT NULL,
CONSTRAINT FK_CALL_DRIVER FOREIGN KEY(Driver_no) REFERENCES DRIVER ON UPDATE CASCADE,
);


--III.Заполняем таблицы

-- Таблица DRIVER
INSERT DRIVER VALUES(11,'Ботвинов','Ефим','Витебск','Московский пр-т','16/4',117,'57-12-48','BM27493','Водитель','Категория 1',15000); 
INSERT DRIVER VALUES(12,'Степанов','Ян','Витебск','пр-т Победы','3/1',324,'62-08-19','BM27494','Водитель','Категория 2',12000);
INSERT DRIVER VALUES(13,'Бобоед','Виталий','Витебск','Клиническая','104','','26-32-48','BM27495','Водитель','Категория 1',4000);
INSERT DRIVER VALUES(14,'Егоров','Иван','Витебск','Московский пр-т','22',4,'21-72-25','BM27496','Водитель','Категория 3',7000);

-- Таблица CAR
INSERT CAR VALUES('Audi','Быстро ездит',20000,21,311,1999,5000,'12.9.2008',12); 
INSERT CAR VALUES('Жигули','Медленно ездит',10000,23,315,1987,7000,'21.2.2015',13);
INSERT CAR VALUES('Audi','Ездит',25000,22,405,2005,2500,'17.5.2018',11);
INSERT CAR VALUES('BMW','Требуется ремонт',30000,28,74,2001,3100,'29.4.2016',14);

-- Таблица CALL
INSERT CALL VALUES(5,'Особый',150,'12.07.2019','17:30','Витебск','Лазо','15','19:26','Витебск','Чкалова','12',44,15,11,'212-23-44'); 
INSERT CALL VALUES(6,'Обычный',100,'15.7.2019','12:30','Витебск','Московский пр-т','10','13:12','Витебск','Чкалова','31',13,24,12,'212-23-55'); 
INSERT CALL VALUES(3,'Особый',150,'15.7.2019','15:20','Витебск','Ленина','13','16:00','Витебск','Чкалова','12',43,5,11,'212-23-66'); 
INSERT CALL VALUES(7,'Обычный',90,'13.8.2019','18:14','Витебск','Лазо','16','18:35','Витебск','Клиническая','31',44,7,14,'212-23-88');
INSERT CALL VALUES(9,'Обычный',90,'15.12.2020','18:14','Витебск','Лазо','16','','Витебск','Клиническая','31',44,7,14,'212-23-11'); 

--IV.Запросы 

--Вывести данные о водителе, который чаще всех доставляет пассажиров на улицу Чкалова.
SELECT DRIVER.L_NAME, DRIVER.F_NAME 
FROM DRIVER JOIN CALL ON DRIVER.Driver_no=CALL.Driver_no
WHERE CALL.DStreet='Чкалова'
GROUP BY CALL.DStreet,DRIVER.L_NAME,DRIVER.F_NAME
HAVING count(CALL.DStreet) = (
	SELECT MAX(Number)
	FROM (SELECT DRIVER.L_NAME AS Name, count(CALL.DStreet) AS Number
		FROM DRIVER JOIN CALL ON DRIVER.Driver_no=CALL.Driver_no
		WHERE CALL.DStreet='Чкалова'
		GROUP BY CALL.DStreet,DRIVER.L_NAME)X);


--Вывести данные об автомобилях, которые имеют пробег более 250 тысяч. километров и которые не проходили ТО в текущем году.
SELECT CAR.Car_no, CAR.Mark
FROM CAR
WHERE CAR.Mileage > 4000 AND YEAR(Last_maintenance_date) != GETDATE();

--Сколько раз каждый пассажир воспользовался услугами таксопарка?
SELECT Passenger_no, count(Passenger_no) AS 'Кол-во вызовов'
FROM CALL
GROUP BY CALL.Passenger_no

--Вывести данные пассажира, который воспользовался услугами таксопарка максимальное число раз.
SELECT Passenger_no, count(Passenger_no) AS 'Кол-во вызовов'
FROM CALL
GROUP BY CALL.Passenger_no
HAVING count(Passenger_no) = (
	SELECT MAX(Number)
	FROM(SELECT Passenger_no, count(Passenger_no) AS Number
	FROM CALL
	GROUP BY CALL.Passenger_no)X);

--Вывести данные о водителе, который ездит на самом дорогом автомобиле.
SELECT DRIVER.L_NAME, DRIVER.F_NAME, CAR.Mark
FROM DRIVER JOIN CAR ON DRIVER.Driver_no=CAR.Driver_no
WHERE CAR.Cost = (SELECT MAX(CAR.Cost)
FROM CAR);

--Вывести данные пассажира, который всегда ездит с одним и тем же водителем.
SELECT X.v
FROM (SELECT  CALL.Passenger_no v
FROM CALL JOIN DRIVER ON DRIVER.Driver_no=CALL.Driver_no
GROUP BY DRIVER.L_NAME, DRIVER.F_NAME , CALL.Passenger_no)X
GROUP BY X.v
HAVING count(X.v)=1;

--Какие автомобили имеют пробег больше среднего пробега для своей марки.
SELECT v.Car_no
FROM CAR v
WHERE v.Mileage > (SELECT AVG(z.Mileage)
FROM CAR z
GROUP BY z.Mark
HAVING z.Mark = v.Mark)


--V.Создать представление, содержащее сведения о незанятых на данный момент водителях.
CREATE VIEW FreeDrivers
AS
SELECT DRIVER.Driver_no,CALL.Disembarkation_time 
FROM DRIVER JOIN CALL ON DRIVER.Driver_no=CALL.Driver_no
WHERE GETDATE() = CALL.Call_date AND  CALL.Disembarkation_time = '00:00';

--VI.Создать хранимые процедуры.

--Вывести данные о зарплате заданного водителя за прошедшие сутки.
CREATE PROCEDURE DaySalaryDriver
@Driver_no member_no
AS
BEGIN
SELECT SUM((CALL.distance * CALL.Price_km)/2)
FROM DRIVER JOIN CALL ON DRIVER.Driver_no=CALL.Driver_no
WHERE DATEADD(day,-1,GETDATE()) = CALL.Call_date AND DRIVER.Driver_no = @Driver_no
END;

--Для вывода данных о пассажирах, которые заказывали такси в заданном, как параметр, временном интервале.
CREATE PROCEDURE FindPassenger
@Landing_time time,
@Disembarkation_time time
AS
BEGIN
SELECT CALL.Passenger_no
FROM CALL
WHERE CALL.Landing_time >= @Landing_time AND CALL.Landing_time <= @Disembarkation_time
GROUP BY CALL.Passenger_no
END;

--Вывести сведения о том, куда был доставлен пассажир по заданному, как параметр, номеру телефона пассажира.
CREATE PROCEDURE FindAdress
@Phone_Passenge Phonenumber
AS
BEGIN
SELECT CONCAT(CALL.DCity, ', ', CALL.DStreet, ', ', CALL.DHouse) AS Address
FROM CALL
WHERE @Phone_Passenge = CALL.Phone_Passenge;
END;

--Для вычисления суммарного дохода  таксопарка за прошедший  месяц.
CREATE PROCEDURE SalaryStationMouth AS
BEGIN
SELECT SUM((CALL.distance * CALL.Price_km)/2)
FROM DRIVER JOIN CALL ON DRIVER.Driver_no=CALL.Driver_no
WHERE DATEPART(year,DATEADD(MONTH,-1,GETDATE())) = DATEPART(year,CALL.Call_date) AND DATEPART(month,DATEADD(MONTH,-1,GETDATE())) = DATEPART(MONTH,CALL.Call_date) 
END;

--VII.Создать пользовательскую функцию для вычисления заработка водителя за прошедшие сутки. Аргумент функции – код сотрудника.
CREATE FUNCTION DaySalaryDriver
(@Driver_no member_no)
RETURN money 
BEGIN
SELECT SUM((CALL.distance * CALL.Price_km)/2)
FROM DRIVER JOIN CALL ON DRIVER.Driver_no=CALL.Driver_no
WHERE DRIVER.Driver_no = @Driver_no AND DATEADD(day,-1,GETDATE()) = CALL.Call_date 
END;

--VIII.Создать триггер для фиксации в БД заработанной водителем суммы и начисления ему заработной платы.
CREATE TRIGGER AccrualOfMoney
ON CALL
AFTER INSERT
AS
UPDATE DRIVER SET Score = Score + (Price_km*distance)/2
FROM INSERTED
WHERE DRIVER.Driver_no = INSERTED.Driver_no;