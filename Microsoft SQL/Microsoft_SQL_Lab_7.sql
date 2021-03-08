--Михайлов Илья 31гр
--Лабораторная №2
--С использованием подчиненных запросов.

USE DreamHome;

--1.Вывести адреса объектов недвижимости, которые не были осмотрены покупателями (использовать  NOT IN).

SELECT PROPERTY.City,PROPERTY.Street,PROPERTY.House,PROPERTY.Flat
FROM PROPERTY left JOIN VIEWING ON PROPERTY.Property_no = VIEWING.Property_no
WHERE PROPERTY.Property_no NOT IN(SELECT Property_no FROM VIEWING)

--2.Вывести адреса объектов недвижимости, которые не были осмотрены покупателями (использовать NOT EXISTS).

SELECT PROPERTY.City,PROPERTY.Street,PROPERTY.House,PROPERTY.Flat
FROM PROPERTY 
WHERE NOT EXISTS(SELECT * FROM VIEWING WHERE PROPERTY.Property_no=VIEWING.Property_no)

--3.Вывести список трехкомнатных квартир, цены которых не превышают средней цены двухкомнатной квартиры.

SELECT *
FROM PROPERTY
WHERE PROPERTY.Rooms = 3 AND PROPERTY.Selling_Price <=(SELECT avg(PROPERTY.Selling_Price) FROM PROPERTY WHERE PROPERTY.Rooms = 2)

--4.Вывести список адресов квартир в каждом городе, цены которых превышают среднюю цену квартир в этом городе. 

SELECT s.City,s.Street,s.House,s.Flat
FROM PROPERTY as s
WHERE s.Selling_Price > (SELECT avg(f.Selling_Price)
FROM PROPERTY as f
GROUP BY f.City
HAVING f.City = s.City
) 

--5.Вывести номера  отделений, в которых средняя заработная плата сотрудников в два раза ниже заработной платы директора компании. 

SELECT BRANCH.Branch_no
FROM BRANCH join STAFF ON BRANCH.Branch_no = STAFF.Branch_no
GROUP BY BRANCH.Branch_no, STAFF.Salary
HAVING avg(STAFF.Salary) = (SELECT STAFF.Salary FROM STAFF WHERE STAFF.Position = 'Директор')

--6.Найти сотрудников (Staff_no, Fname), продавших максимальное количество объектов недвижимости в своем отделении, в течение последних трех месяцев.

SELECT f.Staff_no, f.FName
FROM STAFF as f 
GROUP BY f.Staff_no, f.FName
HAVING count(f.Staff_no) = (SELECT TOP 1 count(z.Staff_no) as num 
	FROM STAFF as z join PROPERTY ON z.Staff_no = PROPERTY.Staff_no join CONTRACT on CONTRACT.Property_no = PROPERTY.Property_no
	WHERE DATEDIFF(month, CONTRACT.Date_Contract, GETDATE()) < 3
	GROUP BY z.Staff_no
	HAVING f.Staff_no = z.Staff_no
	ORDER BY num DESC)

--7.Определить количество отделений, в которых средняя заработная плата в два раза ниже заработной платы директора компании. 

SELECT count(BRANCH.Branch_no) as 'Кол-во отделений'
FROM BRANCH join STAFF ON BRANCH.Branch_no = STAFF.Branch_no
GROUP BY BRANCH.Branch_no, STAFF.Salary
HAVING avg(STAFF.Salary) = (SELECT STAFF.Salary FROM STAFF WHERE STAFF.Position = 'Директор')/2

--8.Определить количество сотрудников компании заработная плата которых превышают среднюю заработную плату.

SELECT count(STAFF.Staff_no) as 'Кол-во сотрудников',STAFF.Salary as 'Их зарплата'
FROM STAFF
GROUP BY  STAFF.Salary
HAVING STAFF.Salary > (SELECT avg(STAFF.Salary) FROM STAFF)


--9.Вывести данные сотрудников каждого отделения, заработная плата которых не превышает среднюю заработную плату и которые продали более двух квартир в течение последних шести месяцев.

SELECT f.Staff_no, f.FName
FROM STAFF as f
WHERE f.Salary > (SELECT avg(STAFF.Salary) FROM STAFF) AND (SELECT count(z.Staff_no)
	FROM STAFF as z join PROPERTY ON z.Staff_no = PROPERTY.Staff_no join CONTRACT on CONTRACT.Property_no = PROPERTY.Property_no
	WHERE DATEDIFF(month, CONTRACT.Date_Contract, GETDATE())< 6 AND f.Staff_no = z.Staff_no
	GROUP BY z.Staff_no) > 2
GROUP BY f.Staff_no, f.FName
