--Михайлов Илья 31гр
--Лабораторная №11
--Создать пользовательские функции.

USE DreamHome;

--1.Скалярную, для вывода адреса самой дешевой квартиры с заданным, как параметр, количеством комнат в заданном, как параметр, городе.
--Вызвать функцию для определения адреса самой дешевой однокомнатной квартиры в Полоцке.

CREATE FUNCTION PoorFlat (@room smallint, @city shortstring)
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

SELECT dbo.PoorFlat(1,'Полоцк')

--2.Табличную, возвращающую данные о средней цене квартир в квартир в каждом городе. Таблица должна включать город и среднюю среднюю цену квартиры в городе. 
--С помощью функции создать запрос, возвращающий город, в котором средняя цена квартир минимальна.

CREATE FUNCTION avgPrice()
RETURNS @table TABLE(City shortstring, avg_Selling_Price money)
AS
BEGIN
INSERT @table SELECT PROPERTY.City, avg(PROPERTY.Selling_Price)
FROM PROPERTY
GROUP BY PROPERTY.City
RETURN
END

--

SELECT TOP 1 * 
FROM dbo.avgPrice()
ORDER BY avg_Selling_Price ASC