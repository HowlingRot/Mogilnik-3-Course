--Михайлов Илья 31гр
--Лабораторная №9
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


--2.Содержащее данные о количестве квартир, проданных каждым сотрудником.
--Представление должно включать номер сотрудника, фамилию сотрудника и количество проданных им квартир.  
--С помощью представления создать запрос, возвращающий фамилии сотрудников, продавших не менее 2-х квартир.

CREATE VIEW countStaffSellsProperty AS
SELECT STAFF.Staff_no, STAFF.LName, count(CONTRACT.Property_no) as numSellsProperty
FROM STAFF JOIN PROPERTY ON STAFF.Staff_no = PROPERTY.Staff_no JOIN CONTRACT ON CONTRACT.Property_no = PROPERTY.Property_no
GROUP BY STAFF.Staff_no, STAFF.LName

SELECT countStaffSellsProperty.LName
FROM countStaffSellsProperty
WHERE  countStaffSellsProperty.numSellsProperty >= 2