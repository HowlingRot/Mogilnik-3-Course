--Михайлов Илья 31гр
--Лабораторная №4
--Однотабличные и многотабличные с использованием соединения таблиц.

USE DreamHome;

--1.Вывести список объектов недвижимости не закрепленных ни за одним сотрудником.
SELECT *
FROM PROPERTY
LEFT JOIN STAFF
ON STAFF.Staff_no = PROPERTY.Staff_no
WHERE STAFF.Staff_no IS NULL;

--2.Вывести адреса объектов недвижимости, которые были осмотрены покупателями.
SELECT PROPERTY.City,PROPERTY.Street,PROPERTY.House,PROPERTY.Flat
FROM PROPERTY
INNER JOIN VIEWING 
ON PROPERTY.Property_no = VIEWING.Property_no

--3.Вывести адреса объектов недвижимости, которые не были осмотрены покупателями.
SELECT PROPERTY.City,PROPERTY.Street,PROPERTY.House,PROPERTY.Flat
FROM PROPERTY
LEFT JOIN VIEWING 
ON PROPERTY.Property_no = VIEWING.Property_no
WHERE VIEWING.Property_no IS NULL;

--4.Вывести данные (фамилия, номер телефона) продавцов всех осмотренных покупателями объектов собственности, у которых (объектов) в поле COMMENT таблицы VIEWING установлено значение «требует ремонта».
SELECT OWNER.FName, OWNER.Otel_no
FROM OWNER
INNER  JOIN PROPERTY ON OWNER.Owner_no = PROPERTY.Owner_no
INNER  JOIN VIEWING ON VIEWING.Property_no = PROPERTY.Property_no
WHERE VIEWING.Comments ='требует ремонта';

--5.Вывести данные об объектах собственности (Property_no, адрес) об объектах собственности, которые были зарегистрированы  в БД более трех месяцев назад и не были проданы.
SELECT p.Property_no, CONCAT(p.City, ', ', p.Street, ', ', TRIM(p.House), ' ', p.Flat) AS Address
FROM PROPERTY p
JOIN VIEWING v
ON v.Property_no=p.Property_no
WHERE v.Comments <> 'согласен' AND DATEDIFF(month, p.Data_registration, GETDATE()) > 3;

--6.Вывести список трёхкомнатных квартир в Витебске, расположенных на втором – четвертом этажах, у которых площадь кухни не менее 10 метров и цена которых не превышает 70000$. 
SELECT *
FROM PROPERTY 
WHERE Rooms = 3 AND City = 'Витебск' AND Floor >1 AND Floor <5 AND Selling_price <= 70000 AND (TRY_CONVERT(float,SUBSTRING(PROPERTY.The_area,(LEN(PROPERTY.The_area) - CHARINDEX('/',REVERSE(PROPERTY.The_area)))+2,CHARINDEX('/',REVERSE(PROPERTY.The_area))))) >= 10;


--7.Вывести список сотрудников (Staff_no, Fname), продавших более одного объекта недвижимости.
SELECT STAFF.Staff_no,  STAFF.FName
FROM STAFF 
JOIN PROPERTY ON STAFF.Staff_no = PROPERTY.Staff_no 
JOIN VIEWING ON PROPERTY.Property_no = VIEWING.Property_no
WHERE Comments ='согласен'
GROUP BY STAFF.FName, STAFF.Staff_no
HAVING COUNT(STAFF.FName)>1;

--8.Найти номера отделений и фамилии служащих, однофамильцы которых работают в этом же отделении.
SELECT Branch_no, FName, count(FName)
FROM STAFF
GROUP BY Branch_no, FName
HAVING count(FName)>1;
