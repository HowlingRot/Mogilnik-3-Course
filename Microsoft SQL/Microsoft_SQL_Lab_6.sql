--Михайлов Илья 31гр
--Лабораторная №1
--С использованием агрегатных функций.

USE DreamHome;

--1.Вывести список сотрудников (Staff_no, Fname), продавших более одного объекта недвижимости.

SELECT STAFF.Staff_no,  STAFF.FName
FROM STAFF join PROPERTY ON STAFF.Staff_no = PROPERTY.Staff_no join CONTRACT on CONTRACT.Property_no = PROPERTY.Property_no
GROUP BY STAFF.Staff_no,  STAFF.FName
HAVING count(STAFF.Staff_no)>1

--2.Найти номера отделений и фамилии служащих, однофамильцы которых работают в этом же отделении.

SELECT Branch_no, FName
FROM STAFF
GROUP BY Branch_no, FName
HAVING count(FName)>1;

--3.Вывести количество объектов недвижимости, проданных каждым отделением в текущем году.

SELECT Branch_no, count(Branch_no) as 'Кол-во проданной недвижимости'
FROM CONTRACT join PROPERTY on CONTRACT.Property_no = PROPERTY.Property_no
WHERE DATEDIFF(year, CONTRACT.Date_Contract, GETDATE()) = 0
GROUP BY PROPERTY.Branch_no

--4.Определить, сколько однокомнатных, двухкомнатных, … ,n-комнатных квартир продано в каждом городе(проданные квартиры содержатся в таблице CONTRACT). 

SELECT PROPERTY.City, PROPERTY.Rooms, count(PROPERTY.Property_no) as 'Кол-во'
FROM CONTRACT join PROPERTY on CONTRACT.Property_no = PROPERTY.Property_no
GROUP BY PROPERTY.City, PROPERTY.Rooms

--5.Вывести цены самых дорогих и самых дешевых квартир в каждом городе.

SELECT PROPERTY.City, max(PROPERTY.Selling_Price) as 'max', min(PROPERTY.Selling_Price) as 'min'
FROM PROPERTY
GROUP BY PROPERTY.City

--6.Найти сотрудника(Staff_no, Fname), продавшего максимальное количество объектов недвижимости в течение последних трех месяцев.

SELECT TOP 1 STAFF.Staff_no,  STAFF.FName, count(CONTRACT.Sale_no) as 'Кол-во проданной недвижимости'
FROM STAFF join PROPERTY ON STAFF.Staff_no = PROPERTY.Staff_no join CONTRACT on CONTRACT.Property_no = PROPERTY.Property_no
WHERE DATEDIFF(month, CONTRACT.Date_Contract, GETDATE()) < 3
GROUP BY STAFF.Staff_no,  STAFF.FName
ORDER BY 'Кол-во проданной недвижимости' DESC

--7.Вывести адрес квартиры, которая была осмотрена покупателями максимальное число раз и не была продана.

SELECT TOP 1 PROPERTY.City,PROPERTY.Street,PROPERTY.House,PROPERTY.Flat, count(VIEWING.Property_no) as 'Кол-во осмотров недвижимости'
FROM PROPERTY JOIN VIEWING ON PROPERTY.Property_no = VIEWING.Property_no left join CONTRACT on CONTRACT.Property_no = PROPERTY.Property_no
WHERE CONTRACT.Sale_no is null
GROUP BY PROPERTY.City,PROPERTY.Street,PROPERTY.House,PROPERTY.Flat, VIEWING.Property_no
ORDER BY 'Кол-во осмотров недвижимости' DESC

--8.Найти номер отделения, у которого средняя заработная плата является максимальной из средних заработных плат отделений компании. 

SELECT TOP 1 BRANCH.Branch_no, avg(STAFF.salary) as 'Средняя зарплата'
FROM BRANCH join STAFF ON BRANCH.Branch_no = STAFF.Branch_no
GROUP BY BRANCH.Branch_no
ORDER BY 'Средняя зарплата' DESC