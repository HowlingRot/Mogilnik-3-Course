--Михайлов Илья 31гр
--Лабораторная №10
--Создать пользовательские функции.

USE DreamHome;

--1.Скалярную, возвращающую  имя заданного сотрудника в формате Фамилия И.
--С помощью функции создать запрос для вывода номеров телефонов сотрудников.

CREATE FUNCTION nameStaff (@Staff_no shortstring)
RETURNS varchar(30)
BEGIN
DECLARE @fullName varchar(30)
SELECT @fullName = STAFF.LName + ' ' + SUBSTRING(STAFF.FName,0,1)
FROM STAFF
WHERE STAFF.@Staff_no = STAFF.Staff_no
RETURN @fullName
END

--
SELECT dbo.nameStaff('BMO550260'), STAFF.Stel_no
FROM STAFF
WHERE STAFF.Staff_no = 'BMO550260'

--2.Скалярную, для вывода адреса самой дешевой квартиры с заданным, как параметр, количеством комнат в заданном, как параметр, городе.
--Вызвать функцию для определения адреса самой дешевой однокомнатной квартиры в Витебске.

CREATE FUNCTION poorFlat (@room smallint, @city shortstring)
RETURNS varchar(30) 
BEGIN
DECLARE @adress varchar(30)
SELECT TOP 1 @adress = PROPERTY.City + ' ' + PROPERTY.Street + ' ' + PROPERTY.House + ' ' + CONVERT(varchar(30), PROPERTY.Flat)
FROM PROPERTY
WHERE PROPERTY.City = @city AND PROPERTY.Rooms = @room
ORDER BY PROPERTY.Selling_Price ASC
RETURN @adress
END

--

SELECT dbo.PoorFlat(1,'Витебск')

--3.Скалярную, для  вычисления количества объектов, проданных отделением в заданном интервале времени. Вызвать функцию для определения количества объектов:
--а) проданных одним из отделений  за определенный период времени.
--б) проданных каждым отделением за определенный период времени. 
--в) рейтинг отделений по числу проданных объектов в заданном интервале времени.

CREATE FUNCTION countProperty (@branch member_no,@start smalldatetime, @end smalldatetime)
RETURNS smallint 
BEGIN
DECLARE @countProperty smallint
SELECT @countProperty = count(PROPERTY.Property_no)
FROM PROPERTY JOIN CONTRACT ON PROPERTY.Property_no = CONTRACT.Property_no
WHERE PROPERTY.Branch_no = @branch AND CONTRACT.Date_Contract > @start AND CONTRACT.Date_Contract < @end
GROUP BY PROPERTY.Branch_no
RETURN @adress
END

--A
SELECT dbo.countProperty(1,'2020-12-13', '2020-12-27')

--B
SELECT BRANCH.Branch_no, dbo.countProperty(BRANCH.Branch_no,'2020-12-13', '2020-12-27')
FROM BRANCH 

--C
SELECT BRANCH.Branch_no, dbo.countProperty(BRANCH.Branch_no,'2020-12-13', '2020-12-27') as 'rating'
FROM BRANCH 
ORDER BY rating DESC

--4.Табличную, возвращающую данные о среднем возрасте сотрудников отделения компании. Таблица должна включать номер отделения и средний возраст. 
--С помощью функции создать запрос для вывода:
--а) списка отделений, в которых средний возраст сотрудников превышает 50 лет.
--б) количества отделений, в которых средний возраст сотрудников превышает 50 лет.
--в) отделения с минимальным средним возрастом сотрудников.

CREATE FUNCTION avgAge()
RETURNS @table TABLE(Branch Branch_no, avgAge int)
AS
BEGIN
INSERT @table SELECT BRANCH.Branch_no, avg(STAFF.DOB)
FROM BRANCH JOIN STAFF ON BRANCH.Branch_no = STAFF.Branch_no
GROUP BY BRANCH.Branch_no
RETURN
END

--A
SELECT Branch_no 
FROM dbo.avgAge()
WHERE avgAge > 50

--B
SELECT count(Branch_no) 
FROM dbo.avgAge()
WHERE avgAge > 50

--C

SELECT TOP 1 Branch_no 
FROM dbo.avgAge()
ORDER BY avgAge ASC