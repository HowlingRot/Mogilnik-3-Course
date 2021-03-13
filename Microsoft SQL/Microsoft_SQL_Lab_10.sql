--Михайлов Илья 31гр
--Лабораторная №10
--Создайте хранимые  процедуры.

USE DreamHome;

--1.Для вычисления количества объектов, проданных в текущем году в заданном, как параметр, городе. Результат вернуть через выходной параметр.

CREATE PROCEDURE numSellProperty (@city shortstring, @counter int OUTPUT) AS
BEGIN
SELECT @counter = count(CONTRACT.Property_no)
FROM CONTRACT JOIN PROPERTY ON CONTRACT.Property_no = PROPERTY.Property_no
WHERE DATEDIFF(year, CONTRACT.Date_Contract, GETDATE()) < 1 AND  @city = PROPERTY.City
END

--

DECLARE  @counter int
DECLARE  @city shortstring
SET @city = 'Полоцк'

EXEC numSellProperty @city, @counter OUTPUT

PRINT @counter

--2.Для выбора объектов собственности, удовлетворяющих требованиям покупателя (в процедуру передать следующие параметры: количество комнат, этаж, общую площадь).
--Квартира должна находиться в том городе, где проживает покупатель.

CREATE PROCEDURE choiceProperty (@room smallint, @floor smallint, @the_area shortstring, @buyer_no member_no) AS
BEGIN
SELECT (PROPERTY.Property_no)
FROM  PROPERTY, BUYER
WHERE @buyer_no = BUYER.Buyer_no AND BUYER.City = PROPERTY.City AND @room = PROPERTY.Rooms AND @floor = PROPERTY.Floor AND @the_area = PROPERTY.The_area
END

--

EXEC choiceProperty 2, 2, '81/29/9', 1 

--3.Для повышения заработной сотрудника на заданный, как параметр, процент при условии наличия у него проданных объектов недвижимости (в процедуру передаётся номер сотрудника, процент повышения заработной платы).
--Вызвать процедуру для сотрудника с заданным Staff_no.

CREATE PROCEDURE SalaryUp (@staff_no shortstring, @up smallint) AS
BEGIN
UPDATE STAFF
SET Salary = Salary + Salary*@up
FROM STAFF JOIN PROPERTY ON STAFF.Staff_no = PROPERTY.Staff_no JOIN CONTRACT on CONTRACT.Property_no = PROPERTY.Property_no
WHERE @staff_no = STAFF.Staff_no
END

--

EXEC SalaryUp BMO550262, 10

--4.Для снижения стоимости квартир, которые не были проданы в течение трех месяцев с даты их регистрации (снизить на заданный, как параметр, процент). 

CREATE PROCEDURE PriceDown (@down smallint) AS
BEGIN
UPDATE PROPERTY
SET Selling_Price = Selling_Price - Selling_Price*@down
FROM PROPERTY JOIN CONTRACT on CONTRACT.Property_no = PROPERTY.Property_no
WHERE CONTRACT.Sale_no is null AND DATEDIFF(month, PROPERTY.Data_registration, GETDATE()) < 3
END

--

EXEC PriceDown 10