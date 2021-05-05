--Михайлов Илья 31гр
--Лабораторная №9
--Создайте хранимые процедуры.

USE DreamHome;

--1.Для ввода данных в таблицу CONTRACT.

CREATE PROCEDURE addContract(@Sale_no member_no,@Notary_Office shortstring, @Date_Contract smalldatetime, @Service_Cost money, @Property_no int, @Buyer_no member_no) AS
BEGIN
INSERT CONTRACT VALUES(@Sale_no,@Notary_Office,@Date_Contract,@Service_Cost,@Property_no,@Buyer_no)
END

--

EXEC addContract 1,'NO_1','1955-12-13','150',3000,1

--2.Для повышения заработной платы сотрудника компании 
--(на 20%, если сотрудник продал одну квартиру в текущем году, на  30%,  если он продал две квартиры в текущем году, на 40%,  если  он продал более двух квартир в текущем году).
--Входной параметр - Staff_no. Предусмотреть вывод данных о заработной плате до и после ее повышения. 

CREATE PROCEDURE riseSalary(@Staff_no shortstring) AS
BEGIN
SELECT STAFF.Salary as 'old_Salary' FROM STAFF WHERE @Staff_no = STAFF.Staff_no

DECLARE @up int
IF 1 = (
	SELECT count(CONTRACT.Sale_no) 
	FROM STAFF JOIN PROPERTY ON STAFF.Staff_no = PROPERTY.Staff_no JOIN CONTRACT ON PROPERTY.Property_no = CONTRACT.Property_no
	WHERE @Staff_no = STAFF.Staff_no AND DATEDIFF(year, CONTRACT.Date_Contract, GETDATE()) < 1)
SET @up = 0.2

ELSE IF 2 = (
	SELECT count(CONTRACT.Sale_no) 
	FROM STAFF JOIN PROPERTY ON STAFF.Staff_no = PROPERTY.Staff_no JOIN CONTRACT ON PROPERTY.Property_no = CONTRACT.Property_no
	WHERE @Staff_no = STAFF.Staff_no AND DATEDIFF(year, CONTRACT.Date_Contract, GETDATE()) < 1)
SET @up = 0.3

ELSE IF 2 < (
	SELECT count(CONTRACT.Sale_no) 
	FROM STAFF JOIN PROPERTY ON STAFF.Staff_no = PROPERTY.Staff_no JOIN CONTRACT ON PROPERTY.Property_no = CONTRACT.Property_no
	WHERE @Staff_no = STAFF.Staff_no AND DATEDIFF(year, CONTRACT.Date_Contract, GETDATE()) < 1)
SET @up = 0.4

UPDATE STAFF
SET Salary = Salary + Salary*@up
WHERE @Staff_no = STAFF.Staff_no

SELECT STAFF.Salary AS 'new_Salary' FROM STAFF WHERE @Staff_no = STAFF.Staff_no

END

--

EXEC riseSalary 'BMO550260'

--3.Для вычисления количества отделений компании, в которых среднее число объектов недвижимости, за которые отвечает сотрудник меньше двух.
--Результат вернуть через выходной параметр.

CREATE PROCEDURE countBranch () AS
BEGIN
SELECT count(BRANCH.Branch_no)
FROM BRANCH AS branch1
GROUP BY BRANCH.Branch_no
HAVING avg(SELECT count(PROPERTY.Property_no)
	FROM BRANCH JOIN STAFF ON BRANCH.Branch_no = STAFF.Branch_no JOIN PROPERTY ON STAFF.Staff_no = PROPERTY.Staff_no
	WHERE BRANCH.Branch_no = branch1.Branch_no
	GROUP BY STAFF.Staff_no) < 2
END

--

EXEC countBranch

--4.Для выбора объектов собственности, удовлетворяющих требованиям покупателя(в процедуру передать следующие параметры: количество комнат, этаж, площадь).

CREATE PROCEDURE choiceProperty (@room smallint, @floor smallint, @the_area shortstring) AS
BEGIN
SELECT (PROPERTY.Property_no)
FROM  PROPERTY, BUYER
WHERE @buyer_no = BUYER.Buyer_no AND BUYER.City = PROPERTY.City AND @room = PROPERTY.Rooms AND @floor = PROPERTY.Floor AND @the_area = PROPERTY.The_area
END

--

EXEC choiceProperty 3, 2, '31/18/10'

--5.Для повышения заработной платы сотрудника на заданный, как параметр, процент при условии, что его заработная плата является минимальной в своем отделении
--(в процедуру передаётся номер сотрудника, процент повышения заработной платы).
--Вывести сообщение о результате выполнения операции. 
--Вызвать процедуру для сотрудника с заданным Staff_no.

CREATE PROCEDURE riseMinSalary (@staff_no shortstring, @up smallint) AS
BEGIN
UPDATE STAFF
SET Salary = Salary + Salary*(@up/100)
FROM STAFF
WHERE @staff_no = STAFF.Staff_no AND STAFF.Salary = (
	SELECT TOP 1 STAFF.Salary 
	FROM STAFF JOIN BRANCH ON STAFF.Branch_no = BRANCH.Branch_no 
	WHERE @staff_no = BRANCH.Branch_no
	ORDER BY num ASC)
END

--

EXEC riseMinSalary 'BMO550260', 20

--6.Для вывода списка сотрудников заданного отделения, которые не продали ни одной квартиры в заданном интервале времени(передать в процедуру дату начала и конца интервала).

CREATE PROCEDURE ListBadStaff (@start smalldatetime, @end smalldatetime) AS
BEGIN
SELECT STAFF.Staff_no
FROM  STAFF JOIN PROPERTY ON STAFF.Staff_no = PROPERTY.Staff_no = JOIN CONTRACT ON PROPERTY.Property_no = CONTRACT.Property_no
WHERE CONTRACT.Date_Contract < @start or CONTRACT.Date_Contract > @end 
GROUP BY STAFF.Staff_no, CONTRACT.Sale_no
HAVING count(CONTRACT.Sale_no) = 0
END

--

EXEC ListBadStaff '2020-12-13', '2020-12-27'

--7.Для снижения цены квартиры на заданный как параметр процент, если квартира была осмотрена покупателями более двух раз, но не была куплена.
--Предусмотрите вывод списка квартир, цены которых были понижены(с указанием цены после снижения).

CREATE PROCEDURE decreasePrice (@down smallint) AS
BEGIN
UPDATE PROPERTY
SET Selling_Price = Selling_Price - Selling_Price*@down
FROM PROPERTY JOIN VIEWING on PROPERTY.Property_no = VIEWING.Property_no LEFT JOIN CONTRACT ON CONTRACT.Property_no = PROPERTY.Property_no
WHERE CONTRACT.Sale_no is NULL
GROUP BY Property_no
HAVING count(Property_no)>1
END

--

EXEC decreasePrice 15

--8.Для удаления из базы данных информации об определенном владельце недвижимости.
--Если с данных владельцем связаны записи в подчиненных таблицах, удаление должно быть отменено.
--Вывести сообщение о результате выполнения операции.

CREATE PROCEDURE deleteOwner (@Owner_no member_no) AS
BEGIN
DELETE OWNER 
WHERE Owner_no = @Owner_no
IF @Owner_no IS NULL
	PRINT "Deleted"
END

EXEC deleteOwner 1
















































































--го пить пиво :)))