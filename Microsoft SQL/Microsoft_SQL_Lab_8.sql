--Михайлов Илья 31гр
--Лабораторная №3
--Запросы на модификацию данных.

USE DreamHome;

--1.Снизить на 10% заработную плату сотрудников, которые не продали ни одной квартиры, и заработная плата которых превышает среднюю заработную плату в своем отделении.

UPDATE STAFF
SET Salary = Salary*0.1
FROM STAFF as f JOIN PROPERTY ON f.Staff_no = PROPERTY.Staff_no LEFT JOIN CONTRACT on CONTRACT.Property_no = PROPERTY.Property_no
WHERE CONTRACT.Property_no IS NULL AND f.Salary > (SELECT avg(z.Salary) FROM STAFF as z GROUP BY z.Branch_no HAVING f.Branch_no = z.Branch_no) 

--2.Уменьшить на 10% цены самых дорогих в своих отделениях квартир.

UPDATE PROPERTY
SET Selling_Price = Selling_Price*0.1
WHERE PROPERTY.Selling_Price = (SELECT max(z.Selling_Price)
	FROM PROPERTY as z
	WHERE PROPERTY.Branch_no = z.Branch_no
	GROUP BY z.Branch_no)

--3.В локальную временную таблицу занести список сотрудников, которые не продали ни одной квартиры в течение последнего года. 

SELECT f.Staff_no, f.FName
INTO #BadStaff
FROM STAFF as f JOIN PROPERTY ON f.Staff_no = PROPERTY.Staff_no LEFT JOIN CONTRACT on CONTRACT.Property_no = PROPERTY.Property_no 
WHERE DATEDIFF(year, CONTRACT.Date_Contract, GETDATE()) < 1

--4.В таблицу BONUS (Staff_no, Amt) занести данные сотрудников, которые продали максимальное количество квартир (Amt). 

SELECT f.Staff_no, count(PROPERTY.Property_no) as Amt
INTO BONUS
FROM STAFF as f JOIN PROPERTY ON f.Staff_no = PROPERTY.Staff_no join CONTRACT on CONTRACT.Property_no = PROPERTY.Property_no 
GROUP BY f.Staff_no, PROPERTY.Property_no
HAVING count(PROPERTY.Property_no) = (SELECT max(n.Amt) FROM (SELECT count(PROPERTY.Property_no) as Amt
FROM STAFF as f JOIN PROPERTY ON f.Staff_no = PROPERTY.Staff_no join CONTRACT on CONTRACT.Property_no = PROPERTY.Property_no 
GROUP BY f.Staff_no, PROPERTY.Property_no)as n)

--5.Таблица PROPERTY_1 служит для хранения данных о проданных объектах собственности (находятся в таблице CONTRACT). 
--С помощью команды INSERT вставить данные об этих квартирах из таблицы PROPERTY в таблицу PROPERTY_1.

CREATE TABLE PROPERTY_1  (
    Property_no         int   NOT NULL PRIMARY KEY,
    Data_registration   nchar(8)    NOT NULL,
    Postcode            postcode    NOT NULL,
    City                shortstring NOT NULL,
    Street              shortstring NOT NULL,
    House               nchar(6)    NOT NULL,
    Flat                smallint        NULL,
    Floor_Type          nchar(6)    NOT NULL,
    Floor               smallint    NOT NULL,
    Rooms               smallint    NOT NULL,
    The_area            shortstring NOT NULL,
    Balcony             shortstring NOT NULL,
    Ptel                shortstring NOT NULL DEFAULT 'Т',
    Selling_Price       money       NOT NULL,
    Branch_no           member_no   NOT NULL,
    Staff_no            shortstring     NULL,
    Owner_no            member_no   NOT NULL,
    
    CONSTRAINT PROPERTY1_Staff  FOREIGN KEY(Staff_no)  REFERENCES STAFF  ON UPDATE  CASCADE,
)


INSERT INTO PROPERTY_1
SELECT Property_no, Data_registration, Postcode, City, Street, House, Flat, Floor_Type, Floor, Rooms, The_area,Balcony,Ptel,Selling_Price,Branch_no,Staff_no,Owner_no
FROM PROPERTY LEFT JOIN CONTRACT on CONTRACT.Property_no = PROPERTY.Property_no 


--6.Удалить из базы данных записи о проданных объектах недвижимости.

DELETE PROPERTY
FROM PROPERTY, PROPERTY_1
WHERE PROPERTY.Property_no = PROPERTY_1.Property_no