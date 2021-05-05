--Михайлов Илья 31гр
--Лабораторная №8
--Создайте представления.

USE DreamHome;

--1.Содержащее данные о средней заработной плате отделений компании.
--Представление должно включать номер  отделения и среднюю заработную плату.
--С помощью представления создать запрос, возвращающий номера  отделений с максимальной и минимальной заработной платой.

CREATE VIEW avgSalaryBranch AS
SELECT STAFF.Branch_no, avg(STAFF.Salary) as 'avg_Salary'
FROM STAFF 
GROUP BY STAFF.Branch_no 

SELECT TOP 1 avgSalaryBranch.Branch_no AS 'Отделение с максимальной зарплатой'
FROM avgSalaryBranch
ORDER BY avgSalaryBranch.avg_Salary DESC

SELECT TOP 1 avgSalaryBranch.Branch_no AS 'Отделение с минимальной зарплатой'
FROM avgSalaryBranch
ORDER BY avgSalaryBranch.avg_Salary ASC



--2.Содержащее   данные о количестве квартир, за который отвечает каждый сотрудник. 
--Представление должно включать номер сотрудника и количество квартир, за которые он отвечает. 
--С помощью представления создать запрос, возвращающий фамилии сотрудников, отвечающих за 3 квартиры.

CREATE VIEW countStaffProperty AS
SELECT STAFF.Staff_no, STAFF.LName, count(PROPERTY.Property_no) as numProperty
FROM STAFF JOIN PROPERTY ON STAFF.Staff_no = PROPERTY.Staff_no 
GROUP BY STAFF.Staff_no, STAFF.LName

SELECT countStaffProperty.LName
FROM countStaffProperty
WHERE  countStaffProperty.numProperty = 3

--3.Содержащее сведения об общей площади и площади кухни каждой квартиры в таблице PROPERTY.
--(Представление должно содержать поля Property_no, Общая площадь, Площадь кухни).
--С помощью представления вывести адреса  квартир, у которых площадь кухни не менее 12 метров.

CREATE VIEW areaInfo AS
SELECT PROPERTY.Property_no, SUBSTRING(PROPERTY.The_area,(LEN(PROPERTY.The_area) - CHARINDEX('/',REVERSE(PROPERTY.The_area)))+2,CHARINDEX('/',REVERSE(PROPERTY.The_area))) as "Kitchen",  SUBSTRING(PROPERTY.The_area, 0, CHARINDEX('/',PROPERTY.The_area)) as "AllArea"
FROM PROPERTY


SELECT City, Street, House, Flat
FROM PROPERTY
WHERE PROPERTY.Property_no = (
SELECT areaInfo.Property_no
FROM areaInfo
WHERE areaInfo.Kitchen >= 12)

--4.Содержащее данные о квартирах, которые были осмотрены более 2 раз и у которых в поле comment таблицы Viewing записано «требует ремонта».  
--С помощью представления создать запрос, возвращающий фамилии и номера телефонов владельцев этих квартир.

CREATE VIEW propertyView AS
SELECT OWNER.FName, OWNER.Otel_no
FROM PROPERTY JOIN OWNER ON PROPERTY.owner_no = OWNER.owner_no JOIN VIEWING ON PROPERTY.Property_no = VIEWING.Property_no
WHERE VIEWING.Comments = 'требует ремонта'
GROUP BY PROPERTY.property_no,OWNER.FName, OWNER.Otel_no
HAVING count(PROPERTY.property_no) >= 2

SELECT propertyView.FName,propertyView.Otel_no
FROM propertyView
